defmodule Companion.Jobs.SendTemplateMessage do
  @moduledoc """
  Submits the templated message to WhatsApp
  """
  import Companion.CompanionWeb
  alias CompanionWeb.Clients.Whatsapp

  def run(id) do
    with message = get_template_message!(id),
         {:ok, wa_id} <- Whatsapp.contact_check(message.to),
         {:ok, response} <- Whatsapp.send_hsm(wa_id, message.content) do
      [whatsapp_message] = response.body["messages"]
      update_template_message(message, %{external_id: whatsapp_message["id"]})
    end
  end
end
