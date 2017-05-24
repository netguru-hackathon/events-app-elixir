defmodule Integrator.Router do
  use Integrator.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Props.Web.Plugs.CurrentUser
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
    plug Props.Web.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
  end

  scope "/", Integrator do
    pipe_through :browser
    get "/", PageController, :index
    get "/auth", AuthController, :index
    get "/auth/callback", AuthController, :callback
    get "/logout", SessionController, :logout
    resources "/session", SessionController, only: [:create, :delete], singleton: true
  end

  scope "/admin", Integrator.Admin do
    pipe_through [:browser, :browser_auth]

    resources "/users", UserController, only: [:index, :show]
    resources "/events", EventController
  end

  scope "/", Integrator do
    pipe_through [:browser, :browser_auth]
    get "/logged_in_page", LoggedInController, :index
  end

  scope "/api", Integrator.API do
    pipe_through :api

    resources "/events", EventController do
      post "/join", EventController, :join, as: :join
      resources "/users", EventUsersController, only: [:index]
    end
  end

  scope "/api/session", Integrator.API do
    pipe_through :api_auth

    resources "/", AuthController, singular: true
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Integrator"
      }
    }
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :integrator,
      swagger_file: "swagger.yml",
      disable_validator: true
  end
end
