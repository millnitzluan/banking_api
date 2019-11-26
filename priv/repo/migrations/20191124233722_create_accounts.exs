defmodule BankingApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :float
      add :user_id, references(:users)

      timestamps()
    end

  end
end
