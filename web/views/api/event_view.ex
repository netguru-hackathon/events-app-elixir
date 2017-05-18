defmodule Integrator.API.EventView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  location "/events/:id"
  attributes [:name, :description, :inserted_at, :updated_at, :avatar_url]

  has_one :organisation,
    include: false,
    identifiers: :when_included

  has_many :items,
    serializer: Integrator.API.ItemView,
    include: false,
    identifiers: :when_included

  def render("error.json", conn) do
    %{
      errors: conn.message
    }
  end

  def type, do: "event"
end
