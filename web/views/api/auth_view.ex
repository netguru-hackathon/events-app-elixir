defmodule Integrator.API.AuthView do
  use Integrator.Web, :view
  use JaSerializer.PhoenixView

  attributes [:token, :expire]

  has_one :user,
    serializer: Integrator.API.UserView,
    included: true,
    identifiers: :when_included

  def type do
    "sessions"
  end
end
