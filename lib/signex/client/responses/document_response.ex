defmodule Signex.Client.Responses.DocumentResponse do
  @behaviour Signex.Client.Responses.ResponseBehaviour

  defstruct [
    :id,
    :status,
    :filename,
    :created,
    :modified
  ]

  @spec to_struct(map()) :: %Signex.Client.Responses.DocumentResponse{}
  @impl true
  def to_struct(%{"data" => %{"id" => id, "attributes" => attrs}}) do
    struct!(%__MODULE__{
      id: id,
      filename: attrs["filename"],
      status: attrs["status"],
      created: attrs["created"],
      modified: attrs["modified"]
    })
  end
end
