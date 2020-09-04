defmodule ExPolygon.Rest.Stocks.LastQuoteOfTicker do
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
end
