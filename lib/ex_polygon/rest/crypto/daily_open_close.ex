defmodule ExPolygon.Rest.Crypto.DailyOpenClose do
  @moduledoc """
  Returns a call to Crypto "Daily Open / Close" Polygon.io
  """

  @type day_stat :: ExPolygon.CryptoOpenClose.t()
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/open-close/crypto/:from/:to/:date"

  @spec query(String.t(), String.t(), String.t(), api_key) ::
          {:ok, day_stat} | {:error, shared_error_reasons}
  def query(from, to, date, api_key) do
    with {:ok, data} <-
           @path
           |> String.replace(":from", from)
           |> String.replace(":to", to)
           |> String.replace(":date", date)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      parse_response(data)
    end
  end

  defp parse_response(%{"closingTrades" => close_trades, "openTrades" => open_trades} = data) do
    open_trades =
      open_trades
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.CryptoTrade, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    close_trades =
      close_trades
      |> Enum.map(
        &Mapail.map_to_struct(&1, ExPolygon.CryptoTrade, transformations: [:snake_case])
      )
      |> Enum.map(fn {:ok, result} -> result end)

    {:ok, open_close} =
      data
      |> Map.put("openTrades", open_trades)
      |> Map.put("closingTrades", close_trades)
      |> Mapail.map_to_struct(ExPolygon.CryptoOpenClose, transformations: [:snake_case])

    {:ok, open_close}
  end
end
