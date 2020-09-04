defmodule ExPolygon.Rest.Stocks.SnapshotSingleTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and a snapshot of choise" do
    use_cassette "rest/snapshot_single/query_ok" do
      assert {:ok, snap} = ExPolygon.Rest.Stocks.SnapshotSingle.query("AAPL", @api_key)

      assert %ExPolygon.Snapshot{} = snap
      assert is_bitstring(snap.ticker)
      assert is_map(snap.day)
      assert is_map(snap.last_trade)
      assert is_map(snap.last_quote)
      assert is_map(snap.min)
      assert is_map(snap.prev_day)
      assert is_float(snap.todays_change)
      assert is_float(snap.todays_change_perc)
      assert is_integer(snap.updated)
    end
  end
end
