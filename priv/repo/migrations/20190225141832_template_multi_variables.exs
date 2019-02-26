defmodule Companion.Repo.Migrations.TemplateMultiVariables do
  use Ecto.Migration

  def change do
    alter table(:templatemessages) do
      remove :content
      add :template, :text
      add :variables, {:array, :text}
    end
  end
end
