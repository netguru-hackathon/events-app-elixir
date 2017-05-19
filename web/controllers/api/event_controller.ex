defmodule Integrator.API.EventController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.Event

  def index(conn, params) do
    events = Repo.paginate(Event, page: params["page"]["page"])
    render(conn, "index.json-api", data: events)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Event, id) |> Repo.preload([:items]) do
      nil ->
        conn
        |> put_status(404)
        |> render(Integrator.API.ErrorView, "404.json-api")
      event ->
        conn
        |> render("show.json-api",
          data: event,
          opts: [
            include: "items",
            fields: %{"items" => "name,description"}
          ]
        )
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render "error.json", message: "Authentication required"
  end
end
