defmodule BankingApi.AccountTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.Account
  alias BankingApi.Auth.Guardian

  describe "users" do
    alias BankingApi.Account.User

    @valid_attrs %{email: "luan@email.com", password: "123321"}
    @invalid_attrs %{email: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "find_user_by_email/1 returns the user with given id" do
      user = user_fixture() |> BankingApi.Repo.preload(:account)
      assert Account.find_user_by_email(user.email) == {:ok, user}
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "luan@email.com"
      assert Argon2.verify_pass("123321", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email returns error changeset" do
      invalid_email = %{email: "das@cas", password: "123123"}
      assert {:error, %Ecto.Changeset{}} = Account.create_user(invalid_email)
    end

    test "token_sign_in/2 returns a valid token" do
      user_fixture()
      {:ok, token, _claims} = Account.token_sign_in("luan@email.com", "123321")

      assert {:ok, jwt} = Guardian.decode_and_verify(token)
    end
  end
end
