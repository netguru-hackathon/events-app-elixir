defmodule Integrator.API.UserView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  location "/users/:id"
  attributes [:email]
end
