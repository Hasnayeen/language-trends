defmodule LanguageTrends.Query do
  import RethinkDB.Query

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