defmodule ExPolygon.CryptoOpenClose do
  @type t :: %ExPolygon.CryptoOpenClose{}

  defstruct ~w(
    symbol
    is_utc
    day
    open
    close
    open_trades
    closing_trades
  )a
end
