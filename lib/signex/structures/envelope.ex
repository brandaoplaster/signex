defmodule Signex.Structures.Envelope do
  @moduledoc """

  """

  @enforce_keys [:name, :locale, :auto_close, :remind_interval, :block_after_refusal]
  defstruct [
    :name,
    :locale,
    :auto_close,
    :remind_interval,
    :block_after_refusal,
    :deadline_at,
    :default_subject,
    :default_message
  ]

  @required_keys @enforce_keys

  @type t :: %__MODULE__{
          name: String.t(),
          deadline_at: String.t(),
          locale: String.t(),
          auto_close: boolean(),
          remind_interval: String.t(),
          block_after_refusal: boolean(),
          default_subject: String.t() | nil,
          default_message: String.t() | nil
        }

  @spec build(map()) :: {:ok, t()} | {:error, String.t()}
  def build(attrs) do
    with :ok <- validate_required(attrs) do
      {:ok, struct(__MODULE__, attrs)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_required(attrs) do
    case Enum.all?(@required_keys, &Map.has_key?(attrs, &1)) do
      true -> :ok
      false -> {:error, "Missing required fields: #{inspect(@required_keys -- Map.keys(attrs))}"}
    end
  end
end
