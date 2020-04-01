# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nine_men_morris,
  ecto_repos: [NineMenMorris.Repo]

# Configures the endpoint
config :nine_men_morris, NineMenMorrisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FB7bdAr6YyQeBhpqzkMinnZyHekKvMQM9ly4pYlhpTwx9PjyuWu2fiU4H4Qry0Kr",
  render_errors: [view: NineMenMorrisWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NineMenMorris.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "EAAcA8wA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
