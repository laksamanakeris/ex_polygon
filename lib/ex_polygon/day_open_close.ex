defmodule ExPolygon.DayOpenClose do
  @type t :: %ExPolygon.DayOpenClose{}

  defstruct ~w(
    status
    from
    symbol
    open
    high
    low
    close
    volume
    pre_market
    after_hours
  )a
end
