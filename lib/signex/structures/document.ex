defmodule Signex.Structures.Document do
  @moduledoc """
  Defines a structure for representing a document with a filename and base64-encoded content.

  This module provides a `Document` struct with two required fields: `filename` and `content_base64`,
  both represented as strings. It includes a `build/1` function to safely construct a `Document`
  struct from a map of attributes, enforcing the presence of required fields and validating their types.

  ## Struct Fields
  - `filename`: A string representing the name of the document.
  - `content_base64`: A string containing the base64-encoded content of the document.

  ## Usage
      iex> Signex.Structures.Document.build(%{filename: "example.pdf", content_base64: "SGVsbG8gV29ybGQ="})
      {:ok, %Signex.Structures.Document{filename: "example.pdf", content_base64: "SGVsbG8gV29ybGQ="}}

      iex> Signex.Structures.Document.build(%{filename: "example.pdf"})
      {:error, "Missing required fields: [:content_base64]"}
  """

  @enforce_keys [:filename, :content_base64]
  defstruct [:filename, :content_base64]

  @required_keys @enforce_keys

  @type t :: %__MODULE__{
          filename: String.t(),
          content_base64: String.t()
        }

  @spec build(map()) :: {:ok, t()} | {:error, String.t()}
  def build(attrs) do
    with :ok <- check_required(attrs),
         :ok <- check_types(attrs) do
      {:ok, struct(__MODULE__, attrs)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec check_required(map()) :: :ok | {:error, String.t()}
  defp check_required(attrs) do
    missing = @required_keys -- Map.keys(attrs)

    case missing do
      [] -> :ok
      keys -> {:error, "Missing required fields: #{inspect(keys)}"}
    end
  end

  @spec check_types(map()) :: :ok | {:error, String.t()}
  defp check_types(attrs) do
    with {:ok, _} <- validate_field(attrs, :filename, &is_binary/1),
         {:ok, _} <- validate_field(attrs, :content_base64, &is_binary/1) do
      :ok
    end
  end

  @spec validate_field(map(), atom(), (any() -> boolean())) :: {:ok, any()} | {:error, String.t()}
  defp validate_field(attrs, key, validator) do
    value = Map.get(attrs, key)

    case validator.(value) do
      true -> {:ok, value}
      false -> {:error, "invalid type for #{key}"}
    end
  end
end
