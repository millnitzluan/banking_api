defmodule BankingApi.Repo do
  use Ecto.Repo,
    otp_app: :banking_api,
    adapter: Ecto.Adapters.Postgres
end
