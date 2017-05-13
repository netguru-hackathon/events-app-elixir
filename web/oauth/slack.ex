defmodule Slack do
  @moduledoc """
  An OAuth2 strategy for Slack.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode
  alias OAuth2.Client

  defp config do
    [strategy: Slack,
     site: "https://slack.com",
     authorize_url: "https://slack.com/oauth/authorize",
     token_url: "https://slack.com/api/oauth.access"]
  end

  # Public API

  def client do
    Application.get_env(:integrator, Slack)
    |> Keyword.merge(config())
    |> Client.new()
  end
  def client(token), do: add_token(client(), token)

  def authorize_url!(params \\ []) do
    Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    Client.get_token!(client(), params)
  end

  def add_token(client, token) do
    token = OAuth2.AccessToken.new(%{"access_token" => token})
    %{client | headers: [], params: %{}, token: token}
  end

  def get!(client, url, headers \\ [], opts \\ []) do
    url = url <> "?token=#{client.token.access_token}"
    Client.get!(client, url, headers, opts)
  end

  def get_user(client) do
    case Slack.get!(client, "/api/users.identity").body do
      %{"ok" => true, "team" => team, "user" => user} -> _get_user(user, team)
      %{"ok" => false, "error" => error} -> {:error, error}
    end
  end
  defp _get_user(user, team) do
    user_params = %{email: user["email"], slack_id: user["id"], slack_team_id: team["id"]}
    {:ok, user_params}
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_id, client.client_id)
    |> put_param(:client_secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
