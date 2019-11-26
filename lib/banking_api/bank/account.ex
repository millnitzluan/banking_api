defmodule BankingApi.Bank.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :balance, :float, default: 1000.0
    belongs_to :user, BankingApi.Account.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end