use Mix.Config

config :integrator, Integrator.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "inegrator-elixir.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  debug_errors: true,
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info
config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 2

config :integrator, Integrator.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :guardian, Guardian,
  secret_key: System.get_env("SECRET_KEY_BASE")
