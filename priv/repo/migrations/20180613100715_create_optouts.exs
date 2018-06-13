defmodule Companion.Repo.Migrations.CreateOptouts do
  use Ecto.Migration

  def change do
    create table(:optouts) do
      add :contact_id, :uuid

      timestamps()
    end

  end
end
