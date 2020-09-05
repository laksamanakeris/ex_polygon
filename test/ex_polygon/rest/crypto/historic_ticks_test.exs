defmodule ExPolygon.Rest.Crypto.HistoricTicksTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple with historic crypto with empty historic ticks" do
    use_cassette "rest/crypto/historic_forex/query_empty" do
      assert {:ok, historic} =
               ExPolygon.Rest.Crypto.HistoricTicks.query(
                 "BTC",
                 "USD",
                 "2018-02-02",
                 %{"limit" => 10},
                 @api_key
               )

      assert %ExPolygon.HistoricCrypto{} = historic
      assert historic.symbol == "BTC-USD"
      assert historic.day == "2018-02-02}"
      assert historic.ticks == nil
    end
  end

  test ".query returns an ok tuple with a historic crypto" do
    use_cassette "rest/crypto/historic_forex/query_ok" do
      assert {:ok, historic} =
               ExPolygon.Rest.Crypto.HistoricTicks.query(
                 "BTC",
                 "USD",
                 "2019-02-02",
                 %{"limit" => 10},
                 @api_key
               )

      assert %ExPolygon.HistoricCrypto{} = historic
      assert historic.symbol == "BTC-USD"
      assert historic.day == "2019-02-02}"
      assert length(historic.ticks) == 10

      assert [%ExPolygon.CryptoTickJson{} = tick | _] = historic.ticks
      assert is_list(tick.c)
      assert is_number(tick.p)
      assert is_number(tick.s)
      assert is_number(tick.t)
      assert is_number(tick.x)
    end
  end
end
