defmodule Companion.CompanionWeb.Registration do
  @moduledoc """
  Schema for Registrations
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Honeydew.EctoPollQueue.Schema

  schema "registrations" do
    field(:channel, :string)
    field(:facility_code, :string)
    field(:msisdn, :string)
    field(:persal, :string)
    field(:registered_by, :string)
    field(:sanc, :string)
    field(:contact_id, :string)
    field(:timestamp, :utc_datetime)

    timestamps()

    honeydew_fields(:process_registration)
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [
      :msisdn,
      :registered_by,
      :channel,
      :facility_code,
      :persal,
      :sanc,
      :contact_id,
      :timestamp
    ])
    |> validate_required([:msisdn, :registered_by, :channel, :facility_code, :timestamp])
  end
end
