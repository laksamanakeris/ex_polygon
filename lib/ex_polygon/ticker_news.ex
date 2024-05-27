defmodule ExPolygon.TickerNews do
  @type t :: %ExPolygon.TickerNews{}

  defstruct ~w(
    count
    next_url
    request_id
    results
    status
  )a
end
