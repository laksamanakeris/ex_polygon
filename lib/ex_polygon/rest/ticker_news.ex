defmodule ExPolygon.Rest.TickerNews do
  @moduledoc """
  Returns a call to "Ticker News" Polygon.io
  """

  @type news :: ExPolygon.TickerNews.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/reference/news"

  # params is a string format map, that contains possible parameters
  # for the call, like %{"perpage" => 3, "page" => 1} etc
  @spec query(map, api_key) :: {:ok, [news]} | {:error, shared_error_reasons}
  def query(params \\ %{}, api_key) do
    with {:ok, data} <-
           @path
           |> ExPolygon.Rest.HTTPClient.get(params, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "results" => results} = data) do
    results =
      results
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.TickerNewsResult, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, news} =
      data
      |> Map.put("results", results)
      |> Mapail.map_to_struct(ExPolygon.TickerNews, transformations: [:snake_case])

    {:ok, news}
  end
end
