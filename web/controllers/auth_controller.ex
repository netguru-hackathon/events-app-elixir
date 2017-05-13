defmodule Integrator.AuthController do
  use Integrator.Web, :controller

  alias Integrator.User

  def index(conn, _params) do
    redirect conn, external: Slack.authorize_url!(scope: "identity.basic,identity.email,identity.team,identity.avatar")
  end

  def callback(conn, %{"code" => code}) do
    client = Slack.get_token!(code: code)

    conn = case Slack.get_user(client) do
      {:ok, user_params} -> _callback(:success, conn, user_params)
      {:error, reason} -> _callback(:error, conn, reason)
    end
  end
  defp _callback(:error, conn, reason) do
    conn
    |> put_flash(:error, reason)
    |> render("error.html")
  end
  defp _callback(:success, conn, user_params) do
    case User.find_or_create_for_slack(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Slack auth successful")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Slack auth failed")
        |> render("error.html")
    end
  end
end
