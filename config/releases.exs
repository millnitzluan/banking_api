import Config

cool_text = System.fetch_env!("COOL_TEXT")

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
app_port = System.fetch_env!("APP_PORT")
app_hostname = System.fetch_env!("APP_HOSTNAME")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")
db_host = System.fetch_env!("DB_HOST")

config :banking_api, BankingApiWeb.Endpoint,
  http: [:inet6, port: String.to_integer(app_port)],
  secret_key_base: secret_key_base

config :banking_api,
  cool_text: cool_text

config :banking_api,
  app_port: app_port

config :banking_api,
  app_hostname: app_hostname

# Configure your database
config :banking_api, BankingApi.Repo,
  username: db_user,
  password: db_password,
  database: "banking_api_prod",
  hostname: db_host,
  pool_size: 10
