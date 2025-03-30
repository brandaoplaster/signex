defmodule Signex.Client.Responses.SignerResponse do
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
