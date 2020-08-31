defmodule ExPolygon.StocksV2NBBO do
  @type t :: %ExPolygon.StocksV2NBBO{}

  defstruct ~w(
    T
    t
    y
    f
    q
    c
    i
    p
    x
    s
    P
    X
    S
    z
  )a
end
