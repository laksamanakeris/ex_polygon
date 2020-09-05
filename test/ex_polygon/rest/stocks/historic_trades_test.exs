defmodule ExPolygon.Rest.Stocks.HistoricTradesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and trade history" do
    use_cassette "rest/stocks/historic_trade/query_ok" do
      limit = 10

      assert {:ok, history} =
               ExPolygon.Rest.Stocks.HistoricTrades.query(
                 "AAPL",
                 "2019-02-01",
                 %{"reverse" => false, "limit" => limit},
                 @api_key
               )

      assert %ExPolygon.History{} = history
      assert history.results_count == limit
      assert history.ticker == "AAPL"
      assert [%ExPolygon.StocksV2Trade{} = trade | _] = history.results
      assert length(history.results) == history.results_count
      assert Map.fetch(trade, :T) == {:ok, nil}
      assert is_integer(trade.t)
      assert is_integer(trade.y)
      # assert is_integer(trade.f)
      assert is_integer(trade.q)
      assert is_bitstring(trade.i)
      assert is_integer(trade.x)
      assert is_integer(trade.s)
      assert is_list(trade.c)
      assert is_float(trade.p)
      assert is_integer(trade.z)
    end
  end
end
