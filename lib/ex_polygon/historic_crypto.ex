defmodule ExPolygon.HistoricCrypto do
  @type t :: %ExPolygon.HistoricCrypto{}

  defstruct ~w(
    day
    map
    msLatency
    status
    symbol
    ticks
  )a
end
