defmodule Datjournaal.Mixfile do
  use Mix.Project

  def project do
    [app: :datjournaal,
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
    [mod: {Datjournaal, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :arc_ecto, :comeonin, :timex, :httpotion,
                    :ex_machina, :guardian, :extwitter, :arc, :calendar, :oauther,
                    :scrivener_ecto, :scrivener_html]]
  end

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
     {:arc, "~> 0.8.0"},
     {:arc_ecto, "~> 0.7.0"},
     {:uuid, "~> 1.1"},
     {:comeonin, "~> 3.0"},
     {:guardian, "~> 0.12.0"},
     {:ex_machina, "~> 2.0"},
     {:extwitter, "~> 0.8.3"},
     {:timex, "~> 3.0"},
     {:exvcr, "~> 0.8", only: :test},
     {:httpotion, "~> 3.0.2"},
     {:calendar, "~> 0.14.2"},
     {:exrm, "~> 1.0.8"},
     {:plug, "~> 1.3"},
     {:scrivener_ecto, "~> 1.3"},
     {:scrivener_html, "~> 1.7"}]
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
