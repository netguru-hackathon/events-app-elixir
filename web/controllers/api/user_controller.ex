defmodule Integrator.API.UserController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.User


  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) |> Repo.preload([:events]) do
      nil ->
        conn
        |> put_status(404)
        |> render(Integrator.ErrorView, "404.json-api")
      user ->
        conn
        |> render("show.json-api",
          data: user,
          opts: [
            include: "events",
            fields: %{"events" => "name,description"}
          ]
        )
    end
  end


  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render Integrator.API.UserView, "error.json", message: "Authentication required"
  end
end
