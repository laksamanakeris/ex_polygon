defmodule ExPolygon.CurrencyConversion do
  @type t :: %ExPolygon.CurrencyConversion{}

  # The actual output is slightly different from the doc
  defstruct ~w(
    from
    to
    initial_amount
    converted
    last
    symbol
  )a
end
