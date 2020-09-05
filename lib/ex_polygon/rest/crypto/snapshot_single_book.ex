defmodule ExPolygon.Rest.Crypto.SnapshotSingleBook do
  @moduledoc """
  Returns a call to Crypto "Snapshot - Single Ticker Full Book" Polygon.io
  """

  @type book :: ExPolygon.CryptoBook.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/snapshot/locale/global/markets/crypto/tickers/:symbol/book"

  @spec query(String.t(), api_key) :: {:ok, book} | {:error, shared_error_reasons}
  def query(symbol, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "data" => data}) do
    %{"bids" => bids, "asks" => asks} = data

    bids =
      bids
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.Bid, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, result} -> result end)

    asks =
      asks
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.Ask, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, book} =
      data
      |> Map.put("asks", asks)
      |> Map.put("bids", bids)
      |> Mapail.map_to_struct(ExPolygon.CryptoBook, transformations: [:snake_case])

    {:ok, book}
  end
end
