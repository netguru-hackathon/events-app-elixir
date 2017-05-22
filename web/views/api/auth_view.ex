defmodule Integrator.API.AuthView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  attributes [:token, :expire]

  def type do
    "sessions"
  end
end
