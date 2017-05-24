defmodule Integrator.API.EventUsersController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.User

  def index(conn, params) do
    users = Repo.paginate(User, page: params["page"]["page"])

    conn
    |> render(Integrator.API.UserView, "index.json-api", data: users)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render Integrator.API.UserView, "error.json", message: "Authentication required"
  end
end
