defmodule ExPolygon.Rest.TickerDetailsV3 do
  @moduledoc """
  Returns a call to "Ticker Details v3" Polygon.io
  """

  @type details :: ExPolygon.TickerDetail.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v3/reference/tickers/:ticker"

  @spec query(String.t(), api_key) :: {:ok, [details]} | {:error, shared_error_reasons}
  def query(ticker, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":ticker", ticker)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "results" => results}) do
    {:ok, type} =
      Mapail.map_to_struct(results, ExPolygon.TickerDetailV3, transformations: [:snake_case])

    {:ok, type}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
