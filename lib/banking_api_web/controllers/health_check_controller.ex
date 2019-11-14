defmodule BankingApiWeb.HealthCheckController do
  use BankingApiWeb, :controller

  def index(conn, _) do
    text conn, "Up!!"
  end
end
