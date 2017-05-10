# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :integrator,
  ecto_repos: [Integrator.Repo]

# Configures the endpoint
config :integrator, Integrator.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J0JUco5FqXNHv/c0u2B9RTS7bioaV6CacNuemjFrt0BxAdDTl+/jiVIowMjPR4zp",
  render_errors: [view: Integrator.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Integrator.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
