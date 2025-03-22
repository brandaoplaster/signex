defmodule Signex.Structures.Signatory do
  @moduledoc """

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

  def build(attrs) do
    with :ok <- validate_types(attrs),
         :ok <- validate_required(attrs) do
      {:ok, struct(__MODULE__, attrs)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

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

  defp present?(attrs, key), do: Map.has_key?(attrs, key)

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

  defp validate_date(%Date{}), do: true
  defp validate_date(_), do: false
end
