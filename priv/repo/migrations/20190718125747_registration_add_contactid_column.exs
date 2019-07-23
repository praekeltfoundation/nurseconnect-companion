defmodule Companion.Repo.Migrations.RegistrationAddContactidColumn do
  use Ecto.Migration

  def change do
    alter table(:registrations) do
      add :contact_id, :string
    end
  end
end
