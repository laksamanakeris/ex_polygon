defmodule ExPolygon.LastTrade do
  @type t :: %ExPolygon.LastTrade{}

  defstruct ~w(
    price
    size
    exchange
    cond1
    cond2
    cond3
    cond4
    timestamp
  )a
end
