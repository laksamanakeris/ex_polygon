defmodule ExPolygon.Rest.HistoricQuoteTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and quote history" do
    use_cassette "rest/historic_quote/query_ok" do
      limit = 10

      assert {:ok, history} =
               ExPolygon.Rest.HistoricQuotes.query(
                 "AAPL",
                 "2019-02-01",
                 %{"reverse" => false, "limit" => limit},
                 @api_key
               )

      assert %ExPolygon.History{} = history
      assert history.results_count == limit
      assert history.ticker == "AAPL"
      assert [%ExPolygon.StocksV2NBBO{} = quot | _] = history.results
      assert length(history.results) == history.results_count
      assert Map.fetch(quot, :T) == {:ok, nil}
      assert is_integer(quot.t)
      assert is_integer(quot.y)
      # assert is_integer(quot.f)
      assert is_integer(quot.q)
      assert is_list(quot.c)
      # assert is_list(quot.i)
      assert is_float(quot.p)
      assert is_integer(quot.x)
      assert is_integer(quot.s)
      assert Map.fetch(quot, :P) == {:ok, 0}
      assert Map.fetch(quot, :X) == {:ok, 0}
      assert Map.fetch(quot, :S) == {:ok, 0}
      assert is_integer(quot.z)
    end
  end
end
