defmodule ExPolygon.Rest.DailyOpenClose do
  @moduledoc """
  Returns a call to "Daily Open / Close" Polygon.io
  """

  @type day_stat :: ExPolygon.DayOpenClose.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/open-close/:symbol/:date"

  @spec query(String.t(), String.t(), api_key) :: {:ok, day_stat} | {:error, shared_error_reasons}
  def query(symbol, date, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":symbol", symbol)
           |> String.replace(":date", date)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"status" => "OK"} = data) do
    {:ok, open_close} =
      Mapail.map_to_struct(data, ExPolygon.DayOpenClose, transformations: [:snake_case])

    {:ok, open_close}
  end

  defp parse_response(%{"status" => "NOT_FOUND"} = _data) do
    {:error, :not_found}
  end

  defp parse_response(_) do
    {:error, :bad_request}
  end
end
