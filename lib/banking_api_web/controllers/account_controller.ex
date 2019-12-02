defmodule BankingApiWeb.AccountController do
  use BankingApiWeb, :controller

  alias BankingApi.Auth.Guardian
  alias BankingApi.Bank
  alias BankingApi.Repo

  action_fallback BankingApiWeb.FallbackController

  def withdraw(conn,  %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:account)

    case Bank.valid_transaction?(user.account, value) do
      {:ok, account} ->
        {:ok, account} = Bank.withdraw_from_account(account, value)

        conn
        |> render("balance.json", account: account)
      _ ->
        {:error, :invalid_withdraw}
    end
  end
end
