defmodule ExPolygon.LastQuote do
  @type t :: %ExPolygon.LastQuote{}

  defstruct ~w(
    askprice
    asksize
    askexchange
    bidprice
    bidsize
    bidexchange
    timestamp
  )a
end
