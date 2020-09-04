defmodule ExPolygon.CryptoExchange do
  @type t :: %ExPolygon.CryptoExchange{}

  defstruct ~w(
    id
    type
    market
    name
    url
  )a
end
