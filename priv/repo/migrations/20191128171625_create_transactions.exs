defmodule BankingApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :float
      add :type, :string
      add :account_id, references(:accounts)

      timestamps()
    end

  end
end
