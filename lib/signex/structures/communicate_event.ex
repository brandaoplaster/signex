defmodule Signex.Structures.CommunicateEvent do
  @moduledoc """
  Defines a structure and validation logic for communication events related to signature requests.

  This module provides a struct `t()` to represent communication preferences for signature-related events,
  including requesting a signature, sending reminders, and notifying about signed documents.
  It validates communication channels against predefined options and builds the struct from a map of attributes.

  ## Structure Fields
  - `:signature_request` - Channel for requesting signatures (options: "sms", "email", "whatsapp").
  - `:signature_reminder` - Channel for sending reminders (options: "email", "whatsapp").
  - `:document_signed` - Channel for notifying about signed documents (options: "email", "whatsapp").

  ## Default Value
  The default communication channel is `"email"` when a value is not provided.

  ## Usage
  The primary function is `build/1`, which takes a map of attributes and returns either:
  - `{:ok, %Signex.Structures.CommunicateEvent{}}` on successful validation and struct creation.
  - `{:error, reason}` if validation fails.

  ### Example
      iex> Signex.Structures.CommunicateEvent.build(%{
      ...>   signature_request: "whatsapp",
      ...>   signature_reminder: "email",
      ...>   document_signed: "whatsapp"
      ...> })
      {:ok, %Signex.Structures.CommunicateEvent{
        signature_request: "whatsapp",
        signature_reminder: "email",
        document_signed: "whatsapp"
      }}

      iex> Signex.Structures.CommunicateEvent.build(%{signature_request: "invalid"})
      {:error, "Invalid value for signature_request"}
  """

  @enforce_keys [:signature_request, :document_signed, :signature_reminder]
  defstruct [:signature_request, :document_signed, :signature_reminder]

  @type t :: %__MODULE__{
          signature_request: String.t() | nil,
          signature_reminder: String.t() | nil,
          document_signed: String.t() | nil
        }

  @default "email"
  @signature_request_options ["sms", "email", "whatsapp"]
  @signature_reminder_options ["email", "whatsapp"]
  @document_signed_options ["email", "whatsapp"]

  @spec build(map()) :: {:ok, t()} | {:error, String.t()}
  def build(attrs) do
    attrs
    |> validate_signature_request()
    |> validate_signature_reminder()
    |> validate_document_signed()
    |> build_struct()
  end

  @spec validate_signature_request(map()) :: {:ok, map()} | {:error, String.t()}
  defp validate_signature_request(attrs) do
    case Map.get(attrs, :signature_request, @default) in @signature_request_options do
      true -> {:ok, attrs}
      false -> {:error, "Invalid value for signature_request"}
    end
  end

  @spec validate_signature_reminder({:ok, map()} | {:error, String.t()}) ::
          {:ok, map()} | {:error, String.t()}
  defp validate_signature_reminder({:ok, attrs}) do
    case Map.get(attrs, :signature_reminder, @default) in @signature_reminder_options do
      true -> {:ok, attrs}
      false -> {:error, "Invalid value for signature_reminder"}
    end
  end

  defp validate_signature_reminder({:error, _} = error), do: error

  @spec validate_document_signed({:ok, map()} | {:error, String.t()}) ::
          {:ok, map()} | {:error, String.t()}
  defp validate_document_signed({:ok, attrs}) do
    case Map.get(attrs, :document_signed, @default) in @document_signed_options do
      true -> {:ok, attrs}
      false -> {:error, "Invalid value for document_signed"}
    end
  end

  defp validate_document_signed({:error, _} = error), do: error

  @spec build_struct({:ok, map()} | {:error, String.t()}) :: {:ok, t()} | {:error, String.t()}
  defp build_struct({:ok, attrs}) do
    {:ok, struct(__MODULE__, attrs)}
  end

  defp build_struct({:error, _} = error), do: error
end
