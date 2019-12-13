defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  alias BankingApi.Auth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Auth.Pipeline
  end

  scope "/api/v1", BankingApiWeb do
    pipe_through :api

    get "/health_check", HealthCheckController, :index
    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end

  scope "/api/v1", BankingApiWeb do
    pipe_through [:api, :jwt_authenticated]

  end

  scope "/api/v1/accounts", BankingApiWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/info", AccountController, :show
    post "/withdraw", AccountController, :withdraw
    post "/transfer", AccountController, :transfer
  end
end
