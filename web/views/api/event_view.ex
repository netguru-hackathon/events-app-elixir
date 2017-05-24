defmodule Integrator.API.EventView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  location "/events/:id"
  attributes [:name, :description, :inserted_at, :updated_at, :image]

  has_one :organisation,
    include: false,
    identifiers: :when_included

  has_many :items,
    serializer: Integrator.API.ItemView,
    include: false,
    identifiers: :when_included

  has_many :users,
    serializer: Integrator.API.UserView,
    include: false,
    identifiers: :when_included


  def image(event, _), do: event.avatar_url

  def render("error.json", conn) do
    %{
      errors: conn.message
    }
  end

  def type, do: "event"
end
