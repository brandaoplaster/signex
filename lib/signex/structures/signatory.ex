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
    validate_required(attrs)
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
end
