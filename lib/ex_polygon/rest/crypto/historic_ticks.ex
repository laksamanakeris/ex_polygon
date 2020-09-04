defmodule ExPolygon.Rest.Crypto.HistoricTicks do
  @type history :: ExPolygon.HistoricCrypto.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/historic/crypto/:from/:to/:date}"

  @spec query(
          String.t(),
          String.t(),
          String.t(),
          map,
          api_key
        ) ::
          {:ok, [history]} | {:error, shared_error_reasons}
  def query(from, to, date, map \\ %{}, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":from", from)
           |> String.replace(":to", to)
           |> String.replace(":date", date)
           |> ExPolygon.Rest.HTTPClient.get(map, api_key) do
      parse_response(data)
    end
  end

  def parse_response(%{"ticks" => ticks, "status" => "success"} = data) do
    ticks =
      ticks
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.CryptoTickJson, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, h_crypto} =
      data
      |> Map.put("ticks", ticks)
      |> Mapail.map_to_struct(ExPolygon.HistoricCrypto, transformations: [:snake_case])

    {:ok, h_crypto}
  end
end
