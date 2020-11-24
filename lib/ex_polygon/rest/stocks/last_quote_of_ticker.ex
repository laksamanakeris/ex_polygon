defmodule ExPolygon.Rest.Stocks.LastQuoteOfTicker do
  @moduledoc """
  Returns a call to "Last Quote for a Symbol" Polygon.io
  """

  @type last_quote :: ExPolygon.LastQuote.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/last_quote/stocks/:symbol"

  @spec query(String.t(), api_key) :: {:ok, last_quote} | {:error, shared_error_reasons}
  def query(symbol, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "success", "last" => results}) do
    {:ok, last_quote} =
      Mapail.map_to_struct(results, ExPolygon.LastQuote, transformations: [:snake_case])

    {:ok, last_quote}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
