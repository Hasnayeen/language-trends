defmodule LanguageTrends.Twitter do
  import Twittex.Client
  import LanguageTrends.Query

  def search_with_hashtag(hashtag, since_id \\ nil, count \\ 100) do
    search("#" <> hashtag <> "-filter:retweets", since_id: since_id, count: count, result_type: "recent")
    |> (fn {:ok, x} -> get_in(x, ["statuses"]) end).() 
    |> Enum.map(fn x -> [get_in(x, ["id_str"]), get_in(x, ["text"])] end)
  end

  def get_all_languages_hashtag(table_name \\ "languages") do
    get_document(table_name)
    |> elem(1)
    |> Enum.map(fn x -> [get_in(x, ["hashtag"]), get_in(x, ["id"])] end)
  end

  def insert_latest_trends_into_db() do
    get_all_languages_hashtag()
    |> Enum.map(fn x -> [tl(x), search_with_hashtag(hd(x), 0)] end)
    |> Enum.map(fn x -> insert_into_db(x) end)
  end

  def insert_into_db(item) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.to_string()
    data = %{"language_id" => hd(hd(item)), "query_time" => now, "total_tweets" => Enum.count(hd(tl(item)))}
    since_id = Enum.take(tl(item), -1) |> hd |> hd |> hd
    insert_document("tweets", data)
    update_document("languages", hd(hd(item)), %{"since_id" => since_id})
    :ok
  end
end