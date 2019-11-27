defmodule BankingApiWeb.UserView do
  use BankingApiWeb, :view
  alias BankingApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("new.json", %{jwt: jwt, balance: balance}) do
    %{jwt: jwt, balance: balance}
  end
end
