defmodule Signex.Client.Responses.EnvelopeResponse do
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
