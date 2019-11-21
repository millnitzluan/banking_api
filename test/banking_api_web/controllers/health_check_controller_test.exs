defmodule HealthCheckControllerTest do
  use BankingApiWeb.ConnCase

  test "index/1 responds with up!! message", %{conn: conn} do
    response =
      conn
      |> get(Routes.health_check_path(conn, :index))
      |> text_response(200)

    assert response == "Up!!"
  end
end
