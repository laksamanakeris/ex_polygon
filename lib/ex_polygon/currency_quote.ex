defmodule ExPolygon.CurrencyQuote do
  @type t :: %ExPolygon.CurrencyQuote{}

  defstruct ~w(
    ask
    bid
    exchange
    timestamp
  )a
end
