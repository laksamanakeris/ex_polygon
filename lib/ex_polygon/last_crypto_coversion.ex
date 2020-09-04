defmodule ExPolygon.LastCryptoConversion do
  @type t :: %ExPolygon.LastCryptoConversion{}

  # The actual output is slightly different from the doc
  defstruct ~w(
    symbol
    last
    last_average
  )a
end
