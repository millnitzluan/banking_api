defmodule BankingApiWeb.UserController do
  use BankingApiWeb, :controller

  alias BankingApi.Account
  alias BankingApi.Account.User
  alias BankingApi.Bank
  alias BankingApi.Auth.Guardian

  action_fallback BankingApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params),
         {:ok, %Bank.Account{} = account} <- Bank.create_account(%{user_id: user.id}),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> render("new.json", jwt: token, balance: account.balance)
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> render("user.json", user: user)
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Account.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn
        |> render("jwt.json", jwt: token)
      {:error, _} ->
        {:error, :unauthorized}
    end
  end
end
