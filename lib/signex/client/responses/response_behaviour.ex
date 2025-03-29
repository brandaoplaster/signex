defmodule Signex.Client.Responses.ResponseBehaviour do
  @moduledoc """
    Behaviour that defines the interface for response modules.

    This behaviour is intended to be implemented by modules that need to transform
    a map (typically a parsed JSON response) into a specific struct. Modules that
    implement this behaviour must define the `to_struct/1` callback to handle
    the conversion logic.

    Example:

      defmodule Signex.Client.Response.EnvelopeResponse do
        @behaviour Signex.Client.Serializers.ResponseBehaviour

        defstruct [:id, :status, :created_at]

        @impl true
        def to_struct(response) do
          struct!(%__MODULE__{}, response)
        end
      end

  """

  @callback to_struct(map()) :: struct()
end
