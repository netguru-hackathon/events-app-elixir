defmodule Integrator.AuthController do
  use Integrator.Web, :controller

  def index(conn, _params) do
    redirect conn, external: Slack.authorize_url!(scope: "identity.basic")
  end

  def callback(conn, params) do
    client = Slack.get_token!(code: params["code"])
    resource = Slack.get!(client, "/api/users.identity").body

    conn
    |> assign(:email, resource["user"]["email"])
    |> assign(:team_id, resource["team"]["id"])
    |> assign(:user_id, resource["user"]["id"])
    |> render("callback.html")
  end
end
