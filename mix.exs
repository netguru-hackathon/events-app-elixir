defmodule Integrator.Mixfile do
  use Mix.Project

  def project do
    [app: :integrator,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Integrator, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :faker, :mime, :oauth2, :scrivener_ecto] ++ env_applications(Mix.env)]
  end

  defp env_applications(:prod), do: [:rollbax]
  defp env_applications(:test), do: []
  defp env_applications(:dev), do: []


  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:credo, "~> 0.3", only: [:dev, :test]},
     {:faker, "~> 0.8"},
     {:ja_serializer, "~> 0.12.0"},
     {:oauth2, "~> 0.9"},
     {:guardian, "~> 0.14"},
     {:scrivener_ecto, "~> 1.0"},
     {:phoenix_swagger, git: "https://github.com/xerions/phoenix_swagger.git", tag: "master"},
     {:ex_json_schema, "~> 0.5"},
     {:rollbax, "~> 0.6"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
