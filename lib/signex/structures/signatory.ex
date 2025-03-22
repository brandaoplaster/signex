defmodule Signex.Structures.Signatory do
  @moduledoc """
  Structure representing a signatory in a signing process.

  This module defines the `Signatory` structure with mandatory and optional fields,
  along with functions for validation and instance construction. It is designed to
  ensure that signatory data is consistent in terms of required field presence and
  expected data types.

  ## Required Fields
  - `:name` - The signatory's name (String).
  - `:email` - The signatory's email address (String).
  - `:phone_number` - The signatory's phone number (String).

  ## Optional Fields
  - `:birthday` - Date of birth (Date).
  - `:has_document` - Document indicator (String).
  - `:documentation` - Document data (String).
  - `:refusable` - Whether the signatory can refuse (boolean).
  - `:group` - Signatory group (integer).
  - `:location_required_enabled` - Whether location is required (boolean).

  ## Usage
  The main function `build/1` creates a `Signatory` instance from a map of attributes,
  validating required fields and data types.

  ### Example
      iex> Signex.Structures.Signatory.build(%{
      ...>   name: "John Smith",
      ...>   email: "john@example.com",
      ...>   phone_number: "+5511999999999",
      ...>   birthday: ~D[1990-01-01],
      ...>   refusable: false
      ...> })
      {:ok, %Signex.Structures.Signatory{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        birthday: ~D[1990-01-01],
        refusable: false
      }}

      iex> Signex.Structures.Signatory.build(%{name: "John"})
      {:error, "Missing required fields: [\"email\", \"phone_number\"]"}

  """

  @enforce_keys [:name, :email, :phone_number]
  defstruct [
    :name,
    :email,
    :phone_number,
    :birthday,
    :has_document,
    :documentation,
    :refusable,
    :group,
    :location_required_enabled
  ]

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          phone_number: String.t(),
          birthday: Date.t(),
          has_document: String.t(),
          documentation: String.t(),
          refusable: boolean(),
          group: integer(),
          location_required_enabled: boolean()
        }

  @spec build(map()) :: {:ok, t()} | {:error, term()}
  def build(attrs) do
    with :ok <- validate_types(attrs),
         :ok <- validate_required(attrs) do
      {:ok, struct(__MODULE__, attrs)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec validate_required(map()) :: :ok | {:error, String.t()}
  defp validate_required(attrs) do
    missing =
      @enforce_keys
      |> Enum.reject(&present?(attrs, &1))
      |> Enum.map(&to_string/1)

    case missing do
      [] -> :ok
      missing_keys -> {:error, "Missing required fields: #{inspect(missing_keys)}"}
    end
  end

  @spec present?(map(), atom()) :: boolean()
  defp present?(attrs, key), do: Map.has_key?(attrs, key)

  @spec validate_types(map()) :: :ok | {:error, {:invalid_types, [{atom(), String.t()}]}}
  defp validate_types(attrs) do
    validations = [
      {:name, &is_binary/1, "must be a string"},
      {:email, &is_binary/1, "must be a string"},
      {:phone_number, &is_binary/1, "must be a string"},
      {:birthday, &validate_date/1, "must be a valid date"},
      {:has_document, &is_binary/1, "must be a string"},
      {:documentation, &is_binary/1, "must be a string"},
      {:refusable, &is_boolean/1, "must be a boolean"},
      {:group, &is_integer/1, "must be an integer"},
      {:location_required_enabled, &is_boolean/1, "must be a boolean"}
    ]

    errors =
      Enum.reduce(validations, [], fn {key, validator, message}, acc ->
        value = Map.get(attrs, key)

        if value != nil and not validator.(value) do
          [{key, message} | acc]
        else
          acc
        end
      end)

    case errors do
      [] -> :ok
      errors -> {:error, {:invalid_types, Enum.reverse(errors)}}
    end
  end

  @spec validate_date(term()) :: boolean()
  defp validate_date(%Date{}), do: true
  defp validate_date(_), do: false
end
