defmodule Companion.CompanionWeb.TemplateMessage do
  @moduledoc """
  Schema for WhatsApp Templated Messages
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Honeydew.EctoPollQueue.Schema

  schema "templatemessages" do
    field(:content, :string)
    field(:external_id, :string)
    field(:to, :string)

    timestamps()

    honeydew_fields(:send_template_message)
  end

  @doc false
  def changeset(template_message, attrs) do
    template_message
    |> cast(attrs, [:to, :content, :external_id])
    |> validate_required([:to, :content])
  end
end
