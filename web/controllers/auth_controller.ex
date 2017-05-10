defmodule Integrator.AuthController do
  use Integrator.Web, :controller

  def index(conn, _params) do
    # Generate the authorization URL and redirect the user to the provider.
    redirect conn, external: OAuth2.Client.authorize_url!(client(), scope: "identity.basic")
    # => "https://auth.example.com/oauth/authorize?client_id=client_id&redirect_uri=https%3A%2F%2Fexample.com%2Fauth%2Fcallback&response_type=code"
  end

  def callback(conn, params) do
    # Use the authorization code returned from the provider to obtain an access token.
    client = OAuth2.Client.get_token!(client(),
                                      code: params["code"],
                                      client_secret: client().client_secret,
                                      client_id: client().client_id)

    resource = OAuth2.Client.get!(client, "/api/users.identity?token=#{client.token.access_token}").body

    conn
    |> assign(:user, resource["user"]["email"])
    |> render("callback.html")
  end

  defp client() do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode, #default
      client_id: System.get_env("SLACK_CLIENT_ID"),
      client_secret: System.get_env("SLACK_CLIENT_SECRET"),
      site: "https://slack.com",
      redirect_uri: "http://localhost:4000/auth/callback",
      authorize_url: "https://slack.com/oauth/authorize",
      token_url: "https://slack.com/api/oauth.access"
    ])
  end
end
