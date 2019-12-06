defmodule BankingApi.BankTest do
  use BankingApi.DataCase

  alias BankingApi.Bank

  describe "accounts" do
    alias BankingApi.Bank.Account

    @valid_attrs %{balance: 120.5}
    @update_attrs %{balance: 456.7}
    @invalid_attrs %{balance: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Bank.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Bank.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Bank.create_account(@valid_attrs)
      assert account.balance == 120.5
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Bank.update_account(account, @update_attrs)
      assert account.balance == 456.7
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Bank.update_account(account, @invalid_attrs)
      assert account == Bank.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Bank.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Bank.change_account(account)
    end
  end

  describe "transactions" do
    alias BankingApi.Bank.Transaction

    @valid_attrs %{type: "some type", value: 120.5}
    @invalid_attrs %{type: nil, value: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Bank.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Bank.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Bank.create_transaction(@valid_attrs)
      assert transaction.type == "some type"
      assert transaction.value == 120.5
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_transaction(@invalid_attrs)
    end
  end

  describe "withdraw from account" do
    test "withdraws from account and create transaction" do
      account = account_fixture()
      {:ok, account} = Bank.withdraw_from_account(account, 20.0)

      transaction = List.first(Bank.list_transactions)

      assert account.balance == 100.5
      assert transaction.value == 20.0
      assert transaction.type == "withdraw"
    end
  end

  describe "transfer to receiver" do
    test "transfer to receiver and create transaction" do
      account = account_fixture()
      receiver = account_fixture()

      {:ok, account} = Bank.transfer_to_account(account, receiver, 10.0)
      receiver = Bank.get_account!(receiver.id)

      transaction = List.first(Bank.list_transactions)

      assert account.balance == 110.5
      assert transaction.value == 10.0
      assert transaction.type == "transfer"
      assert receiver.balance == 130.5
    end
  end

  describe "valid transaction" do
    test "returns account if is a valid trasnsaction" do
      account = account_fixture()
      assert {:ok, account} = Bank.valid_transaction?(account, 20.0)
    end

    test "returns error if is not a valid trasnsaction" do
      account = account_fixture()
      assert {:error} = Bank.valid_transaction?(account, 200.0)
    end
  end
end
