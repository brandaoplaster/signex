defmodule Signex.Structures.Document do
  @moduledoc """

  """
  @enforce_keys [:filename, :content_base64]
  defstruct [:filename, :content_base64]

  @type t :: %__MODULE__{
          filename: String.t(),
          content_base64: String.t()
        }


  def build(attrs) do
    {:ok, struct(__MODULE__, attrs)}
  end
end
