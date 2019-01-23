defmodule Companion.Jobs.SendTemplateMessage do
  @moduledoc """
  Submits the templated message to WhatsApp
  """
  import Companion.CompanionWeb
  alias Companion.CompanionWeb.TemplateMessage
  alias Companion.Repo
  alias CompanionWeb.Clients.Whatsapp

  def supervisor_config do
    [
      :send_template_message,
      schema: TemplateMessage,
      repo: Repo,
      stale_timeout: Application.get_env(:honeydew, :timeout),
      failure_mode:
        {Honeydew.FailureMode.Retry,
         [
           times: Application.get_env(:honeydew, :retries)
         ]},
      success_mode: Honeydew.SuccessMode.Log
    ]
  end

  def run(id) do
    with message = get_template_message!(id),
         {:ok, wa_id} <- Whatsapp.contact_check(message.to),
         {:ok, response} <- Whatsapp.send_hsm(wa_id, message.content),
         [whatsapp_message] <- response.body["messages"],
         {:ok, _} <- update_template_message(message, %{external_id: whatsapp_message["id"]}) do
      {:ok}
    else
      _ -> raise "failed"
    end
  end
end
