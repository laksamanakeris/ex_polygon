defmodule ExPolygon.Rest.Crypto.ExchangesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with a list of exchanges for crypto" do
    use_cassette "rest/crypto/exchanges/query_ok" do
      assert {:ok, exchanges} = ExPolygon.Rest.Crypto.Exchanges.query(@api_key)
      assert [%ExPolygon.CryptoExchange{} = exchange | _] = exchanges
      assert is_bitstring(exchange.type)
      assert is_bitstring(exchange.name)
      assert is_bitstring(exchange.url)
      assert is_bitstring(exchange.market)
    end
  end
end
