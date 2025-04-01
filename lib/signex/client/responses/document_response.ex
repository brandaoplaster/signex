defmodule Signex.Client.Responses.DocumentResponse do
  @moduledoc """
    Defines a structure for document-related responses in the Signex client.

    This module represents the response structure for document operations,
    containing essential metadata about a document such as its identifier,
    status, and timestamps.

    ## Fields
    - `id`: Unique identifier of the document
    - `status`: Current status of the document
    - `filename`: Name of the document file
    - `created`: Timestamp of document creation
    - `modified`: Timestamp of last document modification
  """

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
