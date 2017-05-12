defmodule Integrator.Router do
  use Integrator.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
  end

  scope "/", Integrator do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/auth", AuthController, :index
    get "/auth/callback", AuthController, :callback
    resources "/session", SessionController, only: [:create, :delete], singleton: true
  end

  scope "/api", Integrator.API do
    pipe_through :api

    resources "/events", EventController
  end
end
