import Config

config :banking_api, BankingApiWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.fetch_env!("APP_PORT"))],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :banking_api,
  app_port: System.fetch_env!("APP_PORT")

config :banking_api,
  app_hostname: System.fetch_env!("APP_HOSTNAME")

# Configure your database
config :banking_api, BankingApi.Repo,
  username: System.fetch_env!("DB_USER"),
  password: System.fetch_env!("DB_PASSWORD"),
  database: "banking_api_prod",
  hostname: System.fetch_env!("DB_HOST"),
  pool_size: 10
