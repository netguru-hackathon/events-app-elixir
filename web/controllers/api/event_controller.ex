defmodule Integrator.API.EventController do
  use Integrator.Web, :controller

  alias Integrator.Event

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.json", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.json", event: event)
  end
end
