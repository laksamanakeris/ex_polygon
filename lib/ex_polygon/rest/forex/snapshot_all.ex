defmodule ExPolygon.Rest.Forex.SnapshotAll do
  @type snap :: ExPolygon.Snapshot.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v2/snapshot/locale/global/markets/forex/tickers"

  # Data heavy, may take a while to spit a responce
  # might error and return empty due to the load
  @spec query(api_key) :: {:ok, [snap]} | {:error, shared_error_reasons}
  def query(api_key) do
    with {:ok, data} <- ExPolygon.Rest.HTTPClient.get(@path, %{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK", "tickers" => results} = data) do
    IO.inspect(data)

    snapshots =
      results
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.Snapshot, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, t} -> t end)

    {:ok, snapshots}
  end
end
