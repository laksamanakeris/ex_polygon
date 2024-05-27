defmodule ExPolygon.TickerNewsResult do
  @type t :: %ExPolygon.TickerNewsResult{}

  defstruct ~w(
    amp_url
    article_url
    author
    description
    id
    image_url
    keywords
    published_utc
    publisher
    tickers
    title
  )a
end
