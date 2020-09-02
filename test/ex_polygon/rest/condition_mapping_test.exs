defmodule ExPolygon.Rest.ConditionMappingTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and conditions on trades and quotes" do
    use_cassette "rest/condition_mapping/query_ok" do
      assert {:ok, conditions} =
               ExPolygon.Rest.ConditionMapping.query(
                 "trades",
                 @api_key
               )

      assert Map.fetch(conditions, "1") == {:ok, "Acquisition"}
    end
  end
end
