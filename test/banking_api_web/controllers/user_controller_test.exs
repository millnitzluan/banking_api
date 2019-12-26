defmodule BankingApiWeb.UserControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.Account
  alias BankingApi.Auth.Guardian

  @create_attrs %{
    email: "luan@email.com",
    password: "some password"
  }
  @invalid_attrs %{email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "returns valid jwt token when user is created", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{"jwt" => jwt, "balance" => balance} = json_response(conn, 200)
      assert {:ok, claims} = Guardian.decode_and_verify(jwt)
      assert balance == 1000.0
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when email is invalid", %{conn: conn} do
      invalid_email = %{
        email: "luan@email",
        password: "some password"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: invalid_email)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "sign in" do
    test "returns valid jwt token when user is created", %{conn: conn} do
      Account.create_user(@create_attrs)

      conn = post(conn, Routes.user_path(conn, :sign_in), user: @create_attrs)

      assert %{"jwt" => jwt} = json_response(conn, 200)
      assert {:ok, claims} = Guardian.decode_and_verify(jwt)
    end

    test "returns error when login does not exist or is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :sign_in), user: @create_attrs)

      assert %{"error" => error} = json_response(conn, 401)
      assert error == "Login error"
    end
  end
end
