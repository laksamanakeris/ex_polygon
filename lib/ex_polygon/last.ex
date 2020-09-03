defmodule ExPolygon.Last do
  @type t :: %ExPolygon.Last{}

  defstruct ~w(
    ask
    bid
    exchange
    timestamp
  )a
end
