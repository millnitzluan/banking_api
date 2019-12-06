defmodule BankingApiWeb.AccountController do
  use BankingApiWeb, :controller

  alias BankingApi.Account
  alias BankingApi.Account.User
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

  def transfer(conn,  %{"value" => value, "receiver_email" => receiver_email}) do
    user = Guardian.Plug.current_resource(conn) |> Repo.preload(:account)

    case Bank.valid_transaction?(user.account, value) do
      {:ok, account} ->
        case Account.find_user_by_email(receiver_email) do
          {:ok, %User{} = receiver_user} ->
            {:ok, account} = Bank.transfer_to_account(account, receiver_user.account, value)

            conn
            |> render("balance.json", account: account)
          {:error, _} ->
            {:error, :invalid_receiver}
        end
      _ ->
        {:error, :invalid_transfer}
    end
  end
end
