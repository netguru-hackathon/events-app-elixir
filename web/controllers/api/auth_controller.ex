defmodule Integrator.API.AuthController do
  use Integrator.Web, :controller

  alias Integrator.User

  def create(conn, params) do
    client = Slack.get_token!(code: params["code"])

    case Slack.get_user(client) do
      {:ok, user_params} -> _callback(:success, conn, user_params)
      {:error, reason} -> _callback(:error, conn, reason)
    end
  end

  defp _callback(:error, conn, reason) do
    json conn, %{error: reason}
  end

  defp _callback(:success, conn, user_params) do
    case User.find_or_create_for_slack(user_params) do
      {:ok, user} ->
         new_conn = Guardian.Plug.api_sign_in(conn, user)
         jwt = Guardian.Plug.current_token(new_conn)
         {:ok, claims} = Guardian.Plug.claims(new_conn)

         exp = Map.get(claims, "exp")
         new_conn
         |> put_resp_header("authorization", "Bearer #{jwt}")
         |> put_resp_header("x-expires", Integer.to_string(exp))
         |> render "login.json", jwt: jwt, exp: exp, user: user_params
      {:error, _changeset} ->
        conn
        |> put_status(401)
        |> render "error.json", message: "Could not login"
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    render "logout.json"
  end
end
