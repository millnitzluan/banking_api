defmodule BankingApi.Bank.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :balance, :float, default: 1000.0
    has_many :transactions, BankingApi.Bank.Transaction
    belongs_to :user, BankingApi.Account.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:balance, :user_id])
    |> validate_required([:balance])
  end

  def withdraw(account, %{value: value}) do
    account
    |> change(%{balance: account.balance - value})
  end
end
