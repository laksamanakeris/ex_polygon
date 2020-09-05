defmodule ExPolygon.Rest.Crypto.LastTrade do
  @type last_crypto :: ExPolygon.LastCryptoConversion.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/last/crypto/:from/:to"

  @spec query(String.t(), String.t(), api_key) ::
          {:ok, last_crypto} | {:error, shared_error_reasons}
  def query(from, to, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":from", from)
           |> String.replace(":to", to)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "success", "last" => result} = data) do
    # cracking the differences in the same type between different API calls
    {:ok, last} =
      result
      |> Map.put("cond1", Enum.at(result["conditions"], 0))
      |> Map.put("cond2", Enum.at(result["conditions"], 1))
      |> Map.put("cond3", Enum.at(result["conditions"], 2))
      |> Map.put("cond4", Enum.at(result["conditions"], 3))
      |> Mapail.map_to_struct(ExPolygon.LastTrade, transformations: [:snake_case])

    {:ok, last_crypto} =
      data
      |> Map.put("last", last)
      |> Mapail.map_to_struct(ExPolygon.LastCryptoConversion,
        transformations: [:snake_case]
      )

    {:ok, last_crypto}
  end
end
