defmodule Companion.CompanionWeb.Application do
  @moduledoc """
  Schema for Applications, which controls access to the API
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "applications" do
    field(:name, :string)
    field(:token, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_change(:token, Ecto.UUID.generate())
  end
end
