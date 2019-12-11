defmodule BankingApiWeb.HealthCheckController do
  use BankingApiWeb, :controller

  def index(conn, _) do
    text conn, Application.get_env(:banking_api, :cool_text)
  end
end
