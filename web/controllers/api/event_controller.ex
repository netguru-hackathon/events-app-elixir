defmodule Integrator.API.EventController do
  use Integrator.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias Integrator.Event
  use PhoenixSwagger

  def index(conn, params) do
    events = Repo.paginate(Event,
      page: params["page"]["page"],
      page_size: params["page"]["page_size"])

    render(conn, "index.json-api", data: events, opts: [page: %{base_url: "/events"}])
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Event, id) |> Repo.preload([:items]) |> Repo.preload([:users]) do
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

  def join(conn, %{"event_id" => event_id}) do
    user_id = Guardian.Plug.current_resource(conn).id

    changeset = Integrator.EventParticipation.changeset(
      %Integrator.EventParticipation{}, %{event_id: event_id, user_id: user_id}
    )

    case Repo.insert(changeset) do
      {:ok, _event_participation} ->
        event = Integrator.Repo.get(Event, event_id) |> Repo.preload([:items]) |> Repo.preload([:users])
        conn
        |> put_status(:created)
        |> put_resp_header("location", event_path(conn, :show, event_id))
        |> render("show.json-api",
                  data: event,
                  opts: [
                      include: "items,users",
                      fields: %{"items" => "name,description", "users" => "email"}
                    ]
          )
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Integrator.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render "error.json", message: "Authentication required"
  end
end
