defmodule BankingApi.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false

  alias BankingApi.{Account.User, Auth.Guardian, Repo}

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)

      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
         do: verify_password(password, user)
  end

  @doc false
  defp get_by_email(email) when is_binary(email) do
    case find_user_by_email(email) do
      {:error, _} ->
        Argon2.no_user_verify()
        {:error, "Authentication error."}

      {:ok, _} = result ->
        result
    end
  end

  @doc false
  defp verify_password(password, %User{} = user) when is_binary(password) do
    if Argon2.check_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  def find_user_by_email(email) do
    case Repo.get_by(User, email: email) |> Repo.preload(:account) do
      nil ->
        {:error, "User not found"}

      user ->
        {:ok, user}
    end
  end
end
