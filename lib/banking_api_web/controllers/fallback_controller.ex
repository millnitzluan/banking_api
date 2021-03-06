defmodule BankingApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BankingApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankingApiWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankingApiWeb.ErrorView)
    |> render(:"422")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Login error"})
  end

  def call(conn, {:error, :invalid_withdraw}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid balance value to withdraw"})
  end

  def call(conn, {:error, :invalid_transfer}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid balance value to transfer"})
  end

  def call(conn, {:error, :invalid_receiver}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid receiver"})
  end
end
