defmodule Integrator.API.EventView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :description, :inserted_at, :updated_at]

  has_one :organisation,
    field: :organisation_id,
    type: "organisation"

  def render("error.json", conn) do
    %{
      errors: conn.message
    }
  end
end
