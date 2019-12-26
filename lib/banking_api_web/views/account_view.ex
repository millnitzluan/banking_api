defmodule BankingApiWeb.AccountView do
  use BankingApiWeb, :view
  alias BankingApiWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id, balance: account.balance}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, balance: user.account.balance}
  end

  def render("balance.json", %{account: account}) do
    %{balance: account.balance}
  end
end
