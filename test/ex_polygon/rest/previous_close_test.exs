defmodule ExPolygon.Rest.PreviousCloseTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and the aggregate with DayClose result" do
    use_cassette "rest/previous_close/query_ok" do
      assert {:ok, previous_close} =
               ExPolygon.Rest.PreviousClose.query(
                 "AAPL",
                 %{"unadjusted" => false},
                 @api_key
               )

      assert %ExPolygon.Aggregate{} = previous_close
      assert previous_close.adjusted == true
      assert [%ExPolygon.DayClose{} = day_close | _] = previous_close.results
      assert Map.fetch(day_close, :T) == {:ok, "AAPL"}
      assert is_float(day_close.c)
      assert is_float(day_close.h)
      assert is_float(day_close.l)
      assert day_close.n == nil
      assert is_float(day_close.o)
      assert is_integer(day_close.t)
      assert is_float(day_close.v)
    end
  end
end
