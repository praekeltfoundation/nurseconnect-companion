defmodule Companion.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :name, :string
      add :token, :uuid

      timestamps()
    end

  end
end
