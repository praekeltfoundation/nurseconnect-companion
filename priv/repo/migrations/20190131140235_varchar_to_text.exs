defmodule Companion.Repo.Migrations.VarcharToText do
  use Ecto.Migration

  def change do
    alter table(:templatemessages) do
      modify :content, :text
    end
  end
end
