defmodule ExPolygon.Rest.Crypto.DailyOpenCloseTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and open/close statistic" do
    use_cassette "rest/crypto/daily_open_close/query_ok" do
      assert {:ok, day_stat} =
               ExPolygon.Rest.Crypto.DailyOpenClose.query(
                 "BTC",
                 "USD",
                 "2020-06-05",
                 @api_key
               )

      assert %ExPolygon.CryptoOpenClose{} = day_stat

      #! For some reasons it returns a previous date day
      # and the format is off
      assert day_stat.day == "2020-6-4"
      assert day_stat.symbol == "BTC-USD"
      assert is_number(day_stat.open)
      assert is_number(day_stat.close)
      assert is_list(day_stat.open_trades)
      assert is_list(day_stat.closing_trades)
    end
  end
end
