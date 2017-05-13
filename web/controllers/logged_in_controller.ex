defmodule Integrator.LoggedInController do
  use Integrator.Web, :controller

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "logged_in_page.html", user: user
  end

  # handle the case where no authenticated user
  # was found
  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: "/")
  end
end
