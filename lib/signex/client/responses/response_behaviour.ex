defmodule Signex.Client.Responses.ResponseBehaviour do
  @callback to_struct(map()) :: struct()
end
