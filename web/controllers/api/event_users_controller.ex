defmodule Integrator.API.EventUsersController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.User

  def index(conn, %{"event_id" => event_id, "page" => %{"page" => page, "page_size" => page_size}}) do
    users = Repo.paginate(User, page: page, page_size: page_size)

    conn
    |> render(Integrator.API.UserView, "index.json-api",
        data: users,
        opts: [
          page: %{base_url: "/events/#{event_id}/users"}
        ])
  end

  def index(conn, %{"event_id" => event_id}) do
    users = Repo.paginate(User)

    conn
    |> render(Integrator.API.UserView, "index.json-api",
        data: users,
        opts: [
          page: %{base_url: "/events/#{event_id}/users"}
        ])
  end



  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render Integrator.API.UserView, "error.json", message: "Authentication required"
  end
end
