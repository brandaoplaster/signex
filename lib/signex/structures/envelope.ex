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
         :ok <- validate_remind_inverval(attrs) do
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

  defp validate_deadline_format(%{deadline_at: deadline_at}) do
    case Regex.match?(~r/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/, deadline_at) do
      true -> :ok
      false -> {:error, "Invalid deadline_at format, expected (YYYY-MM-DDTHH:MM:SSZ)"}
    end
  end

  defp validate_remind_inverval(%{remind_interval: remind_interval}) do
    case remind_interval in @valid_remind_intervals do
      true ->
        :ok

      false ->
        invalid_values = @valid_remind_intervals |> Enum.join(", ")
        {:error, "Invalid remind_interval, Allowed values: #{invalid_values}"}
    end
  end

  defp validate_required(attrs) do
    case Enum.all?(@required_keys, &Map.has_key?(attrs, &1)) do
      true -> :ok
      false -> {:error, "Missing required fields: #{inspect(@required_keys -- Map.keys(attrs))}"}
    end
  end
end
