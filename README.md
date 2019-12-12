# BankingApi

This API was created to demonstrate a fully fledged backend application built with **Elixir and Phoenix** including CRUD operations and authentication.

## Installing / Getting started

To run this project, you will need to install the following dependencies on your system:

* [Elixir 1.9.2](https://elixir-lang.org/install.html)
* [Phoenix](https://hexdocs.pm/phoenix/installation.html)
* [PostgreSQL](https://www.postgresql.org/download/macosx/)

To get started, run the following commands in your project folder:

```shell
cp .env.sample .env
mix deps.get  # installs the dependencies
mix ecto.create  # creates the database.
mix ecto.migrate  # run the database migrations.
mix phx.server  # run the application.
```

## Tests

To run the tests for this project, simply run in your terminal:

```shell
mix test
```

## Style guide

This project uses [mix credo --strict](https://github.com/rrrene/elixir-style-guide).
