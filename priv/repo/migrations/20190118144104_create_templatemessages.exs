defmodule Companion.Repo.Migrations.CreateTemplatemessages do
  use Ecto.Migration
  import Honeydew.EctoPollQueue.Migration

  def change do
    create table(:templatemessages) do
      add :to, :string
      add :content, :string
      add :external_id, :string

      timestamps()
      honeydew_fields(:send_template_message)
    end

    honeydew_indexes(:templatemessages, :send_template_message)
  end
end
