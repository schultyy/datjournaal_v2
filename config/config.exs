# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :datjournaal,
  ecto_repos: [Datjournaal.Repo]

# Configures the endpoint
config :datjournaal, Datjournaal.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z/LX99jQ9KYbpmPLBOqUP6Sd9Bbx7UsCyhDzk+gAB3Bnq+LGw74bfCj1X/4fICmq",
  render_errors: [view: Datjournaal.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Datjournaal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
