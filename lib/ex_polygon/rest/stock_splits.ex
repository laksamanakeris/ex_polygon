defmodule ExPolygon.Rest.StockSplits do
  @moduledoc """
  Returns a call to "Stock Splits" Polygon.io
  """

  @type split :: ExPolygon.Split.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/reference/splits/:symbol"

  @spec query(String.t(), api_key) :: {:ok, [split]} | {:error, shared_error_reasons}
  def query(symbol, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "results" => results}) do
    splits =
      results
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.Split, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, t} -> t end)

    {:ok, splits}
  end
end
