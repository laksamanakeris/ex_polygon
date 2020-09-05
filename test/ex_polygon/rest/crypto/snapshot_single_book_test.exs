defmodule ExPolygon.Rest.Crypto.SnapshotSingleBookTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExPolygon.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @api_key System.get_env("POLYGON_API_KEY")

  test ".query returns an ok tuple and a book for a ticker" do
    use_cassette "rest/crypto/snapshot_single_book/query_ok" do
      assert {:ok, book} = ExPolygon.Rest.Crypto.SnapshotSingleBook.query("X:BTCUSD", @api_key)

      assert %ExPolygon.CryptoBook{} = book
      assert book.ticker == "X:BTCUSD"
      assert is_number(book.bid_count)
      assert is_number(book.ask_count)
      assert is_number(book.spread)
      assert is_number(book.updated)

      assert [%ExPolygon.Ask{} | _] = book.asks
      assert [%ExPolygon.Bid{} | _] = book.bids
    end
  end
end
