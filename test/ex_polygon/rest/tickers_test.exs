defmodule ExPolygon.Rest.TickersTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with the parsed json data" do
    use_cassette "rest/tickers/query_ok" do
      assert {:ok, tickers} =
               ExPolygon.Rest.Tickers.query(
                  %{"ticker" => "AAPL", "limit" => 50, "date" => "2024-06-15"},
                 @api_key
               )

      assert tickers.count != nil
      assert [%ExPolygon.Ticker{} = _ | _] = tickers.results
      IO.inspect(tickers.results)
    end
  end
end
