defmodule Signex.Structures.Envelope do
  @moduledoc """
  A module responsible for creating and validating envelopes.

  An envelope is a structure used to define a set of parameters required for generating and handling documents in a specific context. This module provides functionality to:

  - Create an envelope with given attributes.
  - Validate that all required fields are present.
  - Ensure the fields are of the correct types.
  - Validate the format of certain fields (e.g., `deadline_at`).
  - Check that the `remind_interval` field contains an allowed value.

  ## Types

    - `t()`: A struct representing the envelope with the following fields:
      - `:name` (String) - The name of the envelope.
      - `:locale` (String) - The locale of the envelope.
      - `:auto_close` (boolean) - Whether the envelope auto-closes.
      - `:remind_interval` (String) - The reminder interval for the envelope (e.g., "1", "2", "7").
      - `:block_after_refusal` (boolean) - Whether the envelope should block after refusal.
      - `:deadline_at` (String, optional) - The deadline for the envelope in the format `YYYY-MM-DDTHH:MM:SSZ`.
      - `:default_subject` (String | nil, optional) - The default subject for the envelope.
      - `:default_message` (String | nil, optional) - The default message for the envelope.

  ## Functions

    - `build(attrs)`: Receives a map with attributes and returns:
      - `{:ok, %Signex.Structures.Envelope{}}` if all attributes are valid.
      - `{:error, reason}` if any attribute is invalid, with the `reason` being a descriptive error message.

    - Private helper functions:
      - `validate_required(attrs)`: Validates that all required fields are present in the given attributes.
      - `validate_types(attrs)`: Validates that the attributes are of the correct types.
      - `validate_deadline_format(attrs)`: Validates that the `deadline_at` field, if present, is in the correct format (`YYYY-MM-DDTHH:MM:SSZ`).
      - `validate_remind_inverval(attrs)`: Validates that the `remind_interval` field is one of the allowed values (`"1"`, `"2"`, `"3"`, `"7"`, `"14"`).
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
  @valid_remind_intervals ["1", "2", "3", "7", "14"]

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
    with :ok <- validate_required(attrs),
         :ok <- validate_types(attrs),
         :ok <- validate_deadline_format(attrs),
         :ok <- validate_validate_remind_interval(attrs) do
      {:ok, struct(__MODULE__, attrs)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_required(attrs) do
    case @required_keys -- Map.keys(attrs) do
      [] -> :ok
      missing_keys -> {:error, "Missing required fields: #{inspect(missing_keys)}"}
    end
  end

  @spec validate_types(map()) :: :ok | {:error, String.t()}
  defp validate_types(attrs) do
    validates = %{
      name: &is_binary/1,
      deadline_at: &is_binary/1,
      locale: &is_binary/1,
      auto_close: &is_boolean/1,
      remind_interval: &is_binary/1,
      block_after_refusal: &is_boolean/1,
      default_subject: &(is_nil(&1) or is_binary(&1)),
      default_message: &(is_nil(&1) or is_binary(&1))
    }

    case Enum.find(validates, fn {key, validator} ->
           Map.has_key?(attrs, key) and not validator.(attrs[key])
         end) do
      nil -> :ok
      {invalid_key, _} -> {:error, "Invalid type for #{invalid_key}"}
    end
  end

  @spec validate_deadline_format(map()) :: :ok | {:error, String.t()}
  defp validate_deadline_format(%{deadline_at: deadline_at}) do
    case Regex.match?(~r/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/, deadline_at) do
      true -> :ok
      false -> {:error, "Invalid deadline_at format, expected (YYYY-MM-DDTHH:MM:SSZ)"}
    end
  end

  @spec validate_validate_remind_interval(map()) :: :ok | {:error, String.t()}
  defp validate_validate_remind_interval(%{remind_interval: remind_interval}) do
    case remind_interval in @valid_remind_intervals do
      true ->
        :ok

      false ->
        invalid_values = @valid_remind_intervals |> Enum.join(", ")
        {:error, "Invalid remind_interval, Allowed values: #{invalid_values}"}
    end
  end
end
