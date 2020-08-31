defmodule ExPolygon.Rest.PreviousClose do
  @type aggregate :: ExPolygon.Aggregate.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/aggs/ticker/:symbol/prev"

  @spec query(String.t(), api_key) :: {:ok, aggregate} | {:error, shared_error_reasons}
  def query(symbol, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"results" => results} = data) do
    results =
      results
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.AggregateResult, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, aggregate} =
      data
      |> Map.put("results", results)
      |> Mapail.map_to_struct(ExPolygon.Aggregate, transformations: [:snake_case])

    {:ok, aggregate}
  end
end
