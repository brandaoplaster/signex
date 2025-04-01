defmodule Signex.Client.Responses.CommunicateEventsResponse do
  @moduledoc """
    Defines a structure for communication events responses in the Signex client.

    This module represents the response structure for events related to document
    signing communication, including document signed notifications, signature
    requests, and signature reminders.

    ## Fields
    - `document_signed`: Information about completed document signing
    - `signature_request`: Details of signature requests sent
    - `signature_reminder`: Information about signature reminders
  """

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
