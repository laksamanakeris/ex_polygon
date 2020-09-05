defmodule ExPolygon.Rest.Currency.LastQuoteTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with a last quote for currency" do
    use_cassette "rest/last_quote_currency/query_ok" do
      assert {:ok, quot} = ExPolygon.Rest.Currency.LastQuote.query("AUD", "USD", @api_key)

      assert %ExPolygon.CurrencyQuote{} = quot
      assert is_number(quot.ask)
      assert is_number(quot.bid)
      assert is_number(quot.exchange)
      assert is_number(quot.timestamp)
    end
  end
end
