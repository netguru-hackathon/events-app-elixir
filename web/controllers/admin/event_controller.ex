defmodule Integrator.Admin.EventController do
  use Integrator.Web, :controller

  alias Integrator.{Repo, Event}

  def index(conn, params) do
    conn
    |> assign(:events, Repo.all(Event))
    |> render("index.html")
  end
end
