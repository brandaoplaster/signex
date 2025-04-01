defmodule Signex.Client.Responses.SignerResponse do
  @moduledoc """
    Defines a structure for signer-related responses in the Signex client.

    This module represents the response structure for signer information,
    containing personal details, signing preferences, and related communication
    events for an individual involved in the signing process.

    ## Fields
    - `id`: Unique identifier of the signer
    - `name`: Full name of the signer
    - `birthday`: Signer's date of birth
    - `email`: Signer's email address
    - `phone_number`: Signer's phone number
    - `location_required_enabled`: Boolean indicating if location is required
    - `has_documentation`: Boolean indicating if signer has documentation
    - `documentation`: Documentation details provided by the signer
    - `refusable`: Boolean indicating if signer can refuse to sign
    - `group`: Group association of the signer
    - `communicate_events`: Related communication events (see `CommunicateEventsResponse`)
    - `created`: Timestamp of signer record creation
    - `modified`: Timestamp of last signer record modification
  """

  @behaviour Signex.Client.Responses.ResponseBehaviour

  alias Signex.Client.Responses.CommunicateEventsResponse

  defstruct [
    :id,
    :name,
    :birthday,
    :email,
    :phone_number,
    :location_required_enabled,
    :has_documentation,
    :documentation,
    :refusable,
    :group,
    :communicate_events,
    :created,
    :modified
  ]

  @spec to_struct(map()) :: %Signex.Client.Responses.SignerResponse{}
  @impl true
  def to_struct(%{"data" => %{"id" => id, "attributes" => attrs}}) do
    struct!(%__MODULE__{
      id: id,
      name: attrs["name"],
      birthday: attrs["birthday"],
      email: attrs["email"],
      phone_number: attrs["phone_number"],
      location_required_enabled: attrs["location_required_enabled"],
      has_documentation: attrs["has_documentation"],
      documentation: attrs["documentation"],
      refusable: attrs["refusable"],
      group: attrs["group"],
      communicate_events: CommunicateEventsResponse.to_struct(attrs["communicate_events"]),
      created: attrs["created"],
      modified: attrs["modified"]
    })
  end
end
