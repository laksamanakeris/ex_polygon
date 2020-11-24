defmodule ExPolygon.Rest.Stocks.HistoricTrades do
  @moduledoc """
  Returns a call to "Historic Trades" Polygon.io
  """

  @type history :: ExPolygon.History.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/ticks/stocks/trades/:symbol/:date"

  @spec query(
          String.t(),
          String.t(),
          map,
          api_key
        ) ::
          {:ok, [history]} | {:error, shared_error_reasons}
  def query(symbol, date, map \\ %{}, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> String.replace(":date", date)
           |> ExPolygon.Rest.HTTPClient.get(map, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"results" => results, "success" => true} = data) do
    results =
      results
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.StocksV2Trade, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, trades} =
      data
      |> Map.put("results", results)
      |> Mapail.map_to_struct(ExPolygon.History, transformations: [:snake_case])

    {:ok, trades}
  end

  defp parse_response(%{"success" => false} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
