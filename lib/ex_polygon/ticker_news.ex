defmodule ExPolygon.TickerNews do
  @type t :: %ExPolygon.TickerNews{}

  defstruct ~w(
    symbols
    title
    url
    source
    summary
    image
    timestamp
    keywords
  )a
end
