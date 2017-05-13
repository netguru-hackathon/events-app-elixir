defmodule Integrator.Admin.UserController do
  use Integrator.Web, :controller

  alias Integrator.{User, Repo}

  def index(conn, _params) do
    conn
    |> assign(:users, Repo.all(User))
    |> render("index.html")
  end
end
