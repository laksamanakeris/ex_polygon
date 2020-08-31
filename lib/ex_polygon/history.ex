defmodule ExPolygon.History do
  @type t :: %ExPolygon.History{}

  defstruct ~w(
    results_count
    map
    db_latency
    success
    ticker
    results
  )a
end
