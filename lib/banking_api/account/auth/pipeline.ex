defmodule BankingApi.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :banking_api,
  module: BankingApi.Auth.Guardian,
  error_handler: BankingApi.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
