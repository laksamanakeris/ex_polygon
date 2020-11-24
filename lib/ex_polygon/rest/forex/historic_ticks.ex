defmodule ExPolygon.Rest.Forex.HistoricTicks do
  @moduledoc """
  Returns a call to "Historic Forex Ticks" Polygon.io
  """

  @type historic :: ExPolygon.HistoricForex.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/historic/forex/:from/:to/:date"

  @spec query(String.t(), String.t(), String.t(), map, api_key) ::
          {:ok, [historic]} | {:error, shared_error_reasons}
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

  defp parse_response(%{"status" => "success", "ticks" => results} = data) do
    ticks =
      results
      |> Enum.map(&Mapail.map_to_struct(&1, ExPolygon.Forex, transformations: [:snake_case]))
      |> Enum.map(fn {:ok, t} -> t end)

    {:ok, historic} =
      data
      |> Map.put("ticks", ticks)
      |> Mapail.map_to_struct(ExPolygon.HistoricForex, transformations: [:snake_case])

    {:ok, historic}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
