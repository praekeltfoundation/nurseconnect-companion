defmodule Companion.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration
  import Honeydew.EctoPollQueue.Migration

  def change do
    create table(:registrations) do
      add(:msisdn, :string)
      add(:registered_by, :string)
      add(:channel, :string)
      add(:facility_code, :string)
      add(:persal, :string)
      add(:sanc, :string)
      add(:timestamp, :utc_datetime)

      timestamps()
      honeydew_fields(:process_registration)
    end

    honeydew_indexes(:registrations, :process_registration)
  end
end
