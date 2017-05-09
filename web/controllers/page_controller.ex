defmodule Integrator.PageController do
  use Integrator.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
