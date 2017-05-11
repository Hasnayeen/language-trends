defmodule LanguageTrends do
  use Application
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

end
