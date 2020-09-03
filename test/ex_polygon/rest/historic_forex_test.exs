defmodule ExPolygon.Rest.HistoricForexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with a historic forex" do
    use_cassette "rest/historic_forex/query_ok" do
      assert {:ok, historic} =
               ExPolygon.Rest.HistoricForex.query(
                 "AUD",
                 "USD",
                 "2018-02-02",
                 %{"limit" => 10},
                 @api_key
               )

      assert %ExPolygon.HistoricForex{} = historic
      assert historic.pair == "AUD/USD"
      assert historic.day == "2018-02-02"
      assert length(historic.ticks) == 10

      assert [%ExPolygon.Forex{} = tick | _] = historic.ticks
      assert is_number(tick.a)
      assert is_number(tick.b)
      assert is_number(tick.t)
    end
  end
end
