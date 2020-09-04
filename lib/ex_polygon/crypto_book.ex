defmodule ExPolygon.CryptoBook do
  @type t :: %ExPolygon.CryptoBook{}

  defstruct ~w(
    ticker
    bids
    asks
    bid_count
    ask_count
    spread
    updated
  )a
end
