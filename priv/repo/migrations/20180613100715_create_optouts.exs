defmodule Companion.Repo.Migrations.CreateOptouts do
  use Ecto.Migration
  import Honeydew.EctoPollQueue.Migration

  def change do
    create table(:optouts) do
      add :contact_id, :uuid
      add :status, :integer

      timestamps()

      honeydew_fields(:process_opt_out)
    end

    honeydew_indexes(:optouts, :process_opt_out)
  end
end
