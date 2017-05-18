defmodule Integrator.API.EventController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.Event

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.json-api", data: events)
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id) |> Repo.preload([:items])
    render(conn, "show.json-api",
      data: event,
      opts: [
        include: "items",
        fields: %{"items" => "name,description"}
      ]
    )
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render "error.json", message: "Authentication required"
  end
end
