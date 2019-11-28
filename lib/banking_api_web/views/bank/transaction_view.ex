defmodule BankingApiWeb.Bank.TransactionView do
  use BankingApiWeb, :view
  alias BankingApiWeb.Bank.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      value: transaction.value,
      type: transaction.type}
  end
end
