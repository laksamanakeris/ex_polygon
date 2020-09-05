defmodule ExPolygon.Rest.GroupedDailyTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and the aggregate with DayClose results" do
    use_cassette "rest/grouped_daily/query_ok" do
      assert {:ok, grouped_daily} =
               ExPolygon.Rest.GroupedDaily.query(
                 "US",
                 "STOCKS",
                 "2019-02-01",
                 %{"unadjusted" => false},
                 @api_key
               )

      assert %ExPolygon.Aggregate{} = grouped_daily
      assert grouped_daily.adjusted == true
      assert [%ExPolygon.DayClose{} = day_close | _] = grouped_daily.results
      assert length(grouped_daily.results) == grouped_daily.results_count
      assert {:ok, ticker} = Map.fetch(day_close, :T)
      assert is_bitstring(ticker)
      assert is_float(day_close.c)
      assert is_float(day_close.h)
      assert is_float(day_close.l)
      assert is_integer(day_close.n)
      assert is_float(day_close.o)
      assert is_integer(day_close.t)
      assert is_number(day_close.v)
    end
  end
end
