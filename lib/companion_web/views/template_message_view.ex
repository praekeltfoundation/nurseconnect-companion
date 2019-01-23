defmodule CompanionWeb.TemplateMessageView do
  use CompanionWeb, :view
  alias CompanionWeb.TemplateMessageView

  def render("show.json", %{template_message: template_message}) do
    render_one(template_message, TemplateMessageView, "template_message.json")
  end

  def render("template_message.json", %{template_message: template_message}) do
    %{
      id: template_message.id,
      to: template_message.to,
      content: template_message.content,
      external_id: template_message.external_id
    }
  end
end
