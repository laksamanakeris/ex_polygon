defmodule ExPolygon.TickerDetailV3 do
  @type t :: %ExPolygon.TickerDetailV3{}

  defstruct ~w(
    active
    address
    branding
    cik
    composite_figi
    currency_name
    description
    homepage_url
    list_date
    locale
    market
    market_cap
    name
    phone_number
    primary_exchange
    round_lot
    share_class_figi
    share_class_shares_outstanding
    sic_code
    sic_description
    ticker
    ticker_root
    total_employees
    type
    weighted_shares_outstanding
  )a
end
