defmodule BankingApiWeb.AccountControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.Account
  alias BankingApi.Auth.Guardian
  alias BankingApi.Bank

  @current_user %{
    email: "luan@email.com",
    password: "some password"
  }

  @receiver_user %{
    email: "receiver@email.com",
    password: "some password"
  }

  describe "withdraw" do
    setup %{conn: conn} do
      {:ok, user} = Account.create_user(@current_user)
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

    test "transfer value from current_account to receiver, and return current balance ", %{
      conn: conn
    } do
      {:ok, %BankingApi.Account.User{} = receiver} = Account.create_user(@receiver_user)
      Bank.create_account(%{user_id: receiver.id})

      conn =
        post(conn, Routes.account_path(conn, :transfer), %{
          value: 20.0,
          receiver_email: receiver.email
        })

      assert %{"balance" => balance} = json_response(conn, 200)
      assert balance == 980.0
    end

    test "renders errors when value to transfer is more than account balance", %{conn: conn} do
      {:ok, %BankingApi.Account.User{} = receiver} = Account.create_user(@receiver_user)
      Bank.create_account(%{user_id: receiver.id})

      conn =
        post(conn, Routes.account_path(conn, :transfer), %{
          value: 2000.0,
          receiver_email: receiver.email
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when receiver is not valid", %{conn: conn} do
      conn =
        post(conn, Routes.account_path(conn, :transfer), %{
          value: 2000.0,
          receiver_email: "invalid email"
        })

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "account info" do
    setup %{conn: conn} do
      {:ok, user} = Account.create_user(@current_user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      Bank.create_account(%{user_id: user.id})

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "returns user that is authenticated with jwt", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :show))

      assert %{"id" => id, "email" => email, "balance" => balance} = json_response(conn, 200)
      assert email == "luan@email.com"
      assert balance == 1000.0
    end
  end
end
