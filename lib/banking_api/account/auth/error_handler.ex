defmodule BankingApi.Auth.ErrorHandler do
  @moduledoc """
  Implementation of Error handler for guardian.
  """
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end
end
