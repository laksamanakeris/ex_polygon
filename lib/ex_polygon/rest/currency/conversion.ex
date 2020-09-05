defmodule ExPolygon.Rest.Currency.Conversion do
  @moduledoc """
  Returns a call to "Real-time Currency Conversion" Polygon.io
  """

  @type conversion :: ExPolygon.CurrencyConversion.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/conversion/:from/:to"

  @spec query(String.t(), String.t(), map, api_key) ::
          {:ok, conversion} | {:error, shared_error_reasons}
  def query(from, to, map \\ %{}, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":from", from)
           |> String.replace(":to", to)
           |> ExPolygon.Rest.HTTPClient.get(map, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "success", "last" => last} = data) do
    {:ok, last} =
      Mapail.map_to_struct(last, ExPolygon.CurrencyQuote, transformations: [:snake_case])

    {:ok, conversion} =
      data
      |> Map.put("last", last)
      |> Mapail.map_to_struct(ExPolygon.CurrencyConversion, transformations: [:snake_case])

    {:ok, conversion}
  end
end
