defmodule ExPolygon.Rest.DailyOpenCloseTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and open/close statistic" do
    use_cassette "rest/daily_open_close/query_ok" do
      assert {:ok, day_stat} =
               ExPolygon.Rest.DailyOpenClose.query(
                 "AAPL",
                 "2020-06-03",
                 @api_key
               )

      assert %ExPolygon.DayOpenClose{} = day_stat
      assert day_stat.from == "2020-06-03"
      assert day_stat.symbol == "AAPL"
      assert is_float(day_stat.open)
      assert is_float(day_stat.high)
      assert is_float(day_stat.low)
      assert is_float(day_stat.close)
      assert is_number(day_stat.volume)
      assert is_number(day_stat.pre_market)
      assert is_float(day_stat.after_hours)
    end
  end
end
