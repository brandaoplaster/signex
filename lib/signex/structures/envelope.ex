defmodule Signex.Structures.Envelope do
  @enforce_keys [:name, :locale, :auto_close, :remind_interval, :block_after_refusal]
  defstruct [
    :name,
    :locale,
    :auto_close,
    :remind_interval,
    :block_after_refusal,
    :default_subject,
    :default_message
  ]

  def build(attrs) do
    {:ok, struct(__MODULE__, attrs)}
  end
end
