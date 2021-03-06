# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :banking_api,
  ecto_repos: [BankingApi.Repo]

# Configures the endpoint
config :banking_api, BankingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RArweHlachnJZQjBzdQVm/IjVH5jcuhXA4W9mXaVlob5CEBUDGebqMEZm26BXOH8",
  render_errors: [view: BankingApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankingApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :banking_api, BankingApi.Auth.Guardian,
  issuer: "banking_api",
  secret_key: "+QDEWMZaetawNIW4Yf586aoFyzVwP6hNCv8zwdu7wWYiO7Gkyv2M9ORlj+5COWXH"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
