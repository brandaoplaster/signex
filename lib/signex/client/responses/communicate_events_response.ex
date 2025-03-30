defmodule Signex.Client.Responses.CommunicateEventsResponse do
  @behaviour Signex.Client.Responses.ResponseBehaviour

  defstruct [
    :document_signed,
    :signature_request,
    :signature_reminder
  ]

  @spec to_struct(map()) :: %Signex.Client.Responses.CommunicateEventsResponse{}
  @impl true
  def to_struct(attrs) when is_map(attrs) do
    struct!(%__MODULE__{
      document_signed: attrs["document_signed"],
      signature_request: attrs["signature_request"],
      signature_reminder: attrs["signature_reminder"]
    })
  end
end
