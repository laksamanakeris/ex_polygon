defmodule ExPolygon.HistoricForex do
  @type t :: %ExPolygon.HistoricForex{}

  defstruct ~w(
    day
    map
    msLatency
    status
    pair
    ticks
  )a
end
