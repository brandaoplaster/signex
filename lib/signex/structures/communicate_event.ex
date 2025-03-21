defmodule Signex.Structures.CommunicateEvent do
  @moduledoc """

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

  def build(attrs) do
    attrs
    |> validate_signature_request()
    |> validate_signature_reminder()
    |> validate_document_signed()
    |> build_struct()
  end

  defp validate_signature_request(attrs) do
    case Keyword.get(attrs, :signature_request, @default) in @signature_request_options do
      true -> {:ok, attrs}
      false -> {:error, "Invalid value for signature_request"}
    end
  end

  defp validate_signature_reminder({:ok, attrs}) do
    case Keyword.get(attrs, :signature_reminder, @default) in @signature_reminder_options do
      true -> {:ok, attrs}
      false -> {:error, "Invalid value for signature_reminder"}
    end
  end

  defp validate_signature_reminder({:error, _} = error), do: error

  defp validate_document_signed({:ok, attrs}) do
    case Keyword.get(attrs, :document_signed, @default) in @document_signed_options do
      true -> {:ok, attrs}
      false -> {:error, "Invalid value for document_signed"}
    end
  end

  defp validate_document_signed({:error, _} = error), do: error

  defp build_struct({:ok, attrs}) do
    {:ok, struct(__MODULE__, attrs)}
  end

  defp build_struct({:error, _} = error), do: error
end
