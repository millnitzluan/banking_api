defmodule BankingApi.Bank.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :type, :string
    field :value, :float
    belongs_to :account, BankingApi.Bank.Account

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:value, :type])
    |> validate_required([:value, :type])
  end
end
