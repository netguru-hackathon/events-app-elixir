defmodule Integrator.API.ItemView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :description, :inserted_at, :updated_at, :start_time, :end_time, :image]

  def render("error.json", conn) do
    %{
      errors: conn.message
    }
  end

  def type, do: "item"
end
