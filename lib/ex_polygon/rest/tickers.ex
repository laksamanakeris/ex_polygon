defmodule ExPolygon.Rest.Tickers do
  @moduledoc """
  Returns a call to "Tickers" Polygon.io
  """

  @type tickers :: ExPolygon.Tickers.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v3/reference/tickers"

  # params is a string format map, that contains possible parameters
  # for the call, like %{"ticker" => "AAPL", "limit" => 50, "date" => "2024-06-15"} etc
  @spec query(map, api_key) :: {:ok, tickers} | {:error, shared_error_reasons}
  def query(params \\ %{}, api_key) do
    with {:ok, data} <- ExPolygon.Rest.HTTPClient.get(@path, params, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "results" => results} = data) do
    results =
      results
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.Ticker, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, news} =
      data
      |> Map.put("results", results)
      |> Mapail.map_to_struct(ExPolygon.Tickers, transformations: [:snake_case])

    {:ok, news}
  end
end
