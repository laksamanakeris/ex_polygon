defmodule ExPolygon.Rest.ConditionMapping do
  @type api_key :: ExPolygon.Rest.HTTPClient.api_key()
  @type shared_error_reasons :: ExPolygon.Rest.HTTPClient.shared_error_reasons()

  @path "/v1/meta/conditions/:ticktype"

  # returns a map of conditions on a given type of action
  @spec query(String.t(), api_key) :: {:ok, map} | {:error, shared_error_reasons}
  def query(ticktype, api_key) do
    with {:ok, conditions} <-
           @path
           |> String.replace(":ticktype", ticktype)
           |> ExPolygon.Rest.HTTPClient.get(%{}, api_key) do
      {:ok, conditions}
    end
  end
end
