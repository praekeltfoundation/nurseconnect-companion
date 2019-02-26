defmodule Companion.CompanionWeb.TemplateMessage do
  @moduledoc """
  Schema for WhatsApp Templated Messages
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Honeydew.EctoPollQueue.Schema

  schema "templatemessages" do
    field(:external_id, :string)
    field(:to, :string)
    field(:template, :string)
    field(:variables, {:array, :string})

    timestamps()

    honeydew_fields(:send_template_message)
  end

  @doc false
  def changeset(template_message, attrs) do
    template_message
    |> cast(attrs, [:to, :external_id, :template, :variables])
    |> validate_required([:to, :template, :variables])
  end
end
