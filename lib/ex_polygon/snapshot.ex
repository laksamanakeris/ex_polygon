defmodule ExPolygon.Snapshot do
  @type t :: %ExPolygon.Snapshot{}

  defstruct ~w(
    ticker
    day
    last_trade
    last_quote
    min
    prev_day
    todays_change
    todays_change_perc
    updated
  )a
end
