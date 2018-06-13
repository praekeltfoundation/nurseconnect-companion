defmodule CompanionWeb.OptOutView do
  use CompanionWeb, :view
  alias CompanionWeb.OptOutView
  import Kerosene.HTML

  def render("show.json", %{opt_out: opt_out}) do
    render_one(opt_out, OptOutView, "opt_out.json")
  end

  def render("opt_out.json", %{opt_out: opt_out}) do
    %{id: opt_out.id, contact_id: opt_out.contact_id}
  end

  def format_timestamp(timestamp) do
    Timex.format!(timestamp, "{relative}", :relative)
  end
end
