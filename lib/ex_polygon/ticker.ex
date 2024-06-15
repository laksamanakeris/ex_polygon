defmodule ExPolygon.Ticker do
  defstruct ~w(
    ticker
    name
    market
    locale
    primary_exchange
    type
    active
    currency_name
    cik
    composite_figi
    share_class_figi
    last_updated_utc
  )a
end
