defmodule ExPolygon.Rest.LastQuoteCurrency do
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
    {:ok, last} = Mapail.map_to_struct(last, ExPolygon.Last, transformations: [:snake_case])

    {:ok, last}
  end
end
