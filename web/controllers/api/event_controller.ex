defmodule Integrator.API.EventController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.Event
  use PhoenixSwagger

  swagger_path :index do
    get "/api/events"
    summary "List events"
    description "Query for events. This operation supports pagination"
    produces "application/vnd.api+json"
    tag "Events"
    operation_id "list_events"
    paging size: "page[page-size]", number: "page[page]"
    response 200, "Success", JsonApi.page(:EventResource)
  end

  def index(conn, params) do
    events = Repo.paginate(Event, page: params["page"]["page"])
    render(conn, "index.json-api", data: events)
  end

  swagger_path :show do
    get "/api/events/{id}"
    description "Query for event"
    produces "application/vnd.api+json"
    tag "Event"
    operation_id "show_event"
    parameters do
      id :path, :integer, "Event id", required: true, example: 1
    end
    response 200, "Success", JsonApi.single(:EventResource)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Event, id) |> Repo.preload([:items]) do
      nil ->
        conn
        |> put_status(404)
        |> render(Integrator.ErrorView, "404.json-api")
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

  def swagger_definitions do
    %{
      EventResource: JsonApi.resource do
        description "Event"
        attributes do
          name :string, "Event name", required: true, example: "Amazing event name"
          description :string, "Event description", example: "Lorem amazing event"
          avatar_url :string, "Image url", example: "http://robohash.org/set_set1/bgset_bg2/8TaB4QkJEKSFv70fQCVz"
        end
        relationship :items
      end,
      Events: JsonApi.page(:EventResource),
      Event: JsonApi.single(:EventResource),

      ItemResource: JsonApi.resource do
        description "Item"
        attributes do
          id :string, "Unique identifier", example: "1"
          name :string, "Item name", required: true, example: "Incredible item name"
          description :string, "Item description", required: true, example: "Lorem Incredible item"
        end
      end,
      Items: JsonApi.page(:ItemResource),
      Item: JsonApi.single(:ItemResource),
    }
  end
end
