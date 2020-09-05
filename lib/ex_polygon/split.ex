defmodule ExPolygon.Split do
  @type t :: %ExPolygon.Split{}

  defstruct ~w(ticker ex_date payment_date record_date declared_date ratio tofactor forfactor)a
end
