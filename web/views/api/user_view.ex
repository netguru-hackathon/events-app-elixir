defmodule Integrator.API.UserView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  location "/users/:id"
  attributes [:email, :name, :avatar_url]

  def name(user, _) do
    user.first_name
  end

  def render("error.json", conn) do
    %{
      errors: conn.message
    }
  end
end
