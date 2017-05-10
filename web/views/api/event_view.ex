defmodule Integrator.API.EventView do
  use Integrator.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, Integrator.API.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, Integrator.API.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id, name: event.name}
  end
end
