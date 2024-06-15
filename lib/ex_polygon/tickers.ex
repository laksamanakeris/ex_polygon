defmodule ExPolygon.Tickers do
  @type t :: %ExPolygon.Tickers{}

  defstruct ~w(count request_id next_url status results)a
end
