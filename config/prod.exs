use Mix.Config

# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
config :banking_api, BankingApiWeb.Endpoint,
  load_from_system_env: true,
  url: [
    host: Application.get_env(:banking_api, :app_hostname),
    port: Application.get_env(:banking_api, :app_port)
  ]

# Do not print debug messages in production
config :logger, level: :info

# Which server to start per endpoint:
#
config :banking_api, BankingApiWeb.Endpoint, server: true
