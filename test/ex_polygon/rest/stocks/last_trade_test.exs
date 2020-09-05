defmodule ExPolygon.Rest.Stocks.LastTradeTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and last trade" do
    use_cassette "rest/stocks/last_trade/query_ok" do
      assert {:ok, last_trade} =
               ExPolygon.Rest.Stocks.LastTradeOfTicker.query(
                 "AAPL",
                 @api_key
               )

      assert %ExPolygon.LastTrade{} = last_trade
      assert is_number(last_trade.price)
      assert is_integer(last_trade.size)
      assert is_integer(last_trade.exchange)
      assert is_integer(last_trade.cond1)
      # assert is_integer(last_trade.cond2)
      # assert is_integer(last_trade.cond3)
      # assert is_integer(last_trade.cond4)
      assert is_integer(last_trade.timestamp)
    end
  end
end
