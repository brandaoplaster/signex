defmodule Signex.Client.Responses.EnvelopeResponse do
  @moduledoc """
    Defines a structure for envelope-related responses in the Signex client.

    This module represents the response structure for envelope operations,
    containing metadata and configuration details about a signing envelope,
    including its status, deadlines, and behavior settings.

    ## Fields
    - `id`: Unique identifier of the envelope
    - `name`: Name of the envelope
    - `status`: Current status of the envelope
    - `deadline_at`: Deadline timestamp for the envelope
    - `locale`: Language/region setting for the envelope
    - `auto_close`: Boolean indicating if the envelope auto-closes
    - `rubric_enabled`: Boolean indicating if rubric is enabled
    - `remind_interval`: Interval for sending reminders
    - `block_after_refusal`: Boolean indicating if envelope blocks after refusal
    - `default_message`: Default message associated with the envelope
    - `created`: Timestamp of envelope creation
    - `modified`: Timestamp of last envelope modification
  """

  @behaviour Signex.Client.Responses.ResponseBehaviour

  defstruct [
    :id,
    :name,
    :status,
    :deadline_at,
    :locale,
    :auto_close,
    :rubric_enabled,
    :remind_interval,
    :block_after_refusal,
    :default_message,
    :created,
    :modified
  ]

  @spec to_struct(map()) :: %Signex.Client.Responses.EnvelopeResponse{}
  @impl true
  def to_struct(%{"data" => %{"id" => id, "attributes" => attrs}}) do
    struct!(%__MODULE__{
      id: id,
      name: attrs["name"],
      status: attrs["status"],
      deadline_at: attrs["deadline_at"],
      locale: attrs["locale"],
      auto_close: attrs["auto_close"],
      rubric_enabled: attrs["rubric_enabled"],
      remind_interval: attrs["remind_interval"],
      block_after_refusal: attrs["block_after_refusal"],
      default_message: attrs["default_message"],
      created: attrs["created"],
      modified: attrs["modified"]
    })
  end
end
