defmodule ExPolygon.Rest.GroupedDaily do
  @moduledoc """
  Returns a call to "Grouped Daily ( Bars )" Polygon.io
  """

  @type aggregate :: ExPolygon.Aggregate.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/aggs/grouped/locale/:locale/market/:market/:date"

  @spec query(String.t(), String.t(), String.t(), map, api_key) ::
          {:ok, aggregate} | {:error, shared_error_reasons}
  def query(symbol, market, date, map \\ %{}, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":locale", symbol)
           |> String.replace(":market", market)
           |> String.replace(":date", date)
           |> ExPolygon.Rest.HTTPClient.get(map, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "results" => results} = data) do
    results =
      results
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.DayClose, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, aggregate} =
      data
      |> Map.put("results", results)
      |> Mapail.map_to_struct(ExPolygon.Aggregate, transformations: [:snake_case])

    {:ok, aggregate}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
