defmodule BankingApiWeb.AccountControllerTest do
  use BankingApiWeb.ConnCase

  alias BankingApi.Account
  alias BankingApi.Auth.Guardian
  alias BankingApi.Bank

  @create_attrs %{
    email: "some email",
    password: "some password"
  }

  describe "withdraw" do
    setup %{conn: conn} do
      {:ok, user} = Account.create_user(@create_attrs)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      Bank.create_account(%{user_id: user.id})

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "withdraws value from current_account and returns current balance ", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :withdraw), value: 20.0)

      assert %{"balance" => balance} = json_response(conn, 200)
      assert balance == 980.0
    end

    test "renders errors when value to withdraw is more than account balance", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :withdraw), value: 2000.0)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
