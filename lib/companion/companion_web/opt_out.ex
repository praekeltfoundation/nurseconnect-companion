defmodule Companion.CompanionWeb.OptOut do
  @moduledoc """
  Schema for OptOuts, which are created from hooks from rapidpro
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "optouts" do
    field(:contact_id, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(opt_out, attrs) do
    opt_out
    |> cast(attrs, [:contact_id])
    |> validate_required([:contact_id])
  end

  def order_newest_first(query) do
    from(
      optout in query,
      order_by: [desc: optout.inserted_at]
    )
  end
end
