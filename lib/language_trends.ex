defmodule LanguageTrends do
  use Application
  import RethinkDB.Query
  @moduledoc """
  Documentation for LanguageTrends.
  """

  @doc """
  Hello world.

  ## Examples

      iex> LanguageTrends.hello
      :world

  """
  def start(_type, _args) do
    import Supervisor.Spec

    children = [worker(LanguageTrends.Database, [[host: 'rethinkdb', port: 28015, db: "language_trends"]])]
    opts = [strategy: :one_for_one, name: LanguageTrends.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def create_database(name) do
    db_create(name) |> LanguageTrends.Database.run
  end

  def create_table(name) do
    table_create(name) |> LanguageTrends.Database.run()
  end

  def drop_table(name) do
    table_drop(name) |> LanguageTrends.Database.run()
  end

  def get_document(name) do
    table(name) |> LanguageTrends.Database.run()
  end

  def insert_document(name, data) do
    table(name) |> insert(data) |> LanguageTrends.Database.run()
  end

  def update_document(name, id, data) do
    table(name) |> get(id) |> update(data) |> LanguageTrends.Database.run()
  end

  def delete_document(name, filter) do
    table(name) |> filter(filter) |> delete() |> LanguageTrends.Database.run()
  end

  def delete_all(name) do
    table(name) |> delete() |> LanguageTrends.Database.run()
  end

  def filter_document(name, filter) do
    table(name) |> filter(filter) |> LanguageTrends.Database.run()
  end
end
