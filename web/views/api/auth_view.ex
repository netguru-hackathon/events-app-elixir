defmodule Integrator.API.AuthView do
  use Integrator.Web, :view

  def render("login.json", params) do
    %{
      jwt: params[:jwt],
      expire: params[:exp]
    }
  end
end
