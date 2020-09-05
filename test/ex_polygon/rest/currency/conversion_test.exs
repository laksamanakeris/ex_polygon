defmodule ExPolygon.Rest.Currency.ConversionTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with a conversion of currencies" do
    use_cassette "rest/currency/conversion/query_ok" do
      assert {:ok, conversion} =
               ExPolygon.Rest.Currency.Conversion.query(
                 "AUD",
                 "USD",
                 %{"amount" => 100},
                 @api_key
               )

      assert %ExPolygon.CurrencyConversion{} = conversion
      assert conversion.from == "AUD"
      assert conversion.to == "USD"
      assert conversion.initial_amount == 100

      assert %ExPolygon.CurrencyQuote{} = last = conversion.last
      assert is_number(last.ask)
      assert is_number(last.bid)
      assert is_number(last.exchange)
      assert is_number(last.timestamp)
    end
  end
end
