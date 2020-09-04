defmodule ExPolygon.Rest.Stocks.LastQuoteTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and last quote" do
    use_cassette "rest/last_quote/query_ok" do
      assert {:ok, last_quote} =
               ExPolygon.Rest.Stocks.LastQuoteOfTicker.query(
                 "AAPL",
                 @api_key
               )

      assert %ExPolygon.LastQuote{} = last_quote
      assert is_float(last_quote.askprice)
      assert is_integer(last_quote.asksize)
      assert is_integer(last_quote.askexchange)
      assert is_float(last_quote.bidprice)
      assert is_integer(last_quote.bidsize)
      assert is_integer(last_quote.bidexchange)
      assert is_integer(last_quote.timestamp)
    end
  end
end
