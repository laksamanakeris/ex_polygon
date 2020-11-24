defmodule ExPolygon.Rest.Currency.LastQuote do
  @moduledoc """
  Returns a call to "Last Quote for a Currency Pair" Polygon.io
  """

  @type last :: ExPolygon.Last.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/last_quote/currencies/:from/:to"

  @spec query(String.t(), String.t(), api_key) ::
          {:ok, last} | {:error, shared_error_reasons}
  def query(from, to, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":from", from)
           |> String.replace(":to", to)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "success", "last" => last}) do
    {:ok, last} =
      Mapail.map_to_struct(last, ExPolygon.CurrencyQuote, transformations: [:snake_case])

    {:ok, last}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
