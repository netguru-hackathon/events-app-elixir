defmodule Integrator.SessionController do
  use Integrator.Web, :controller

  def logout(conn, params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
