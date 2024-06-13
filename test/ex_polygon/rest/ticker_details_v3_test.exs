defmodule ExPolygon.Rest.TickerDetailsV3Test do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with ticker details" do
    use_cassette "rest/ticker_details_v3/query_ok" do
      assert {:ok, details} = ExPolygon.Rest.TickerDetailsV3.query("AAPL", @api_key)
      assert %ExPolygon.TickerDetailV3{} = details
      assert details.active == true
      assert details.ticker == "AAPL"

    end
  end
end
