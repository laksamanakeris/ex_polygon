defmodule ExPolygon.Rest.Crypto.LastTradeTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with a last trade" do
    use_cassette "rest/crypto/last_trade/query_ok" do
      assert {:ok, quot} = ExPolygon.Rest.Crypto.LastTrade.query("BTC", "USD", @api_key)

      assert %ExPolygon.LastCryptoConversion{} = quot
      assert quot.symbol == "BTC-USD"

      assert %ExPolygon.LastTrade{} = quot.last
      # assert is_map(quot.last_average)
    end
  end
end
