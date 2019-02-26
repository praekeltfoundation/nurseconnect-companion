defmodule Companion.Jobs.SendTemplateMessageTests do
  use Companion.DataCase

  import Companion.CompanionWeb
  alias Companion.Jobs.SendTemplateMessage
  import Tesla.Mock

  @hsm_request Poison.encode!(%{
                 to: "27820000000",
                 type: "hsm",
                 hsm: %{
                   namespace: "hsm_namespace",
                   element_name: "hsm_element_name",
                   localizable_params: [%{default: "Test message"}]
                 }
               })
  @contact_request Poison.encode!(%{
                     contacts: ["+27820000000"],
                     blocking: "wait"
                   })

  setup do
    mock(fn
      %{
        method: :post,
        url: "https://whatsapp/v1/messages",
        headers: [
          {"content-type", "application/json"},
          {"authorization", "Bearer token"}
        ],
        body: @hsm_request
      } ->
        json(%{
          messages: [%{id: "gBEGkYiEB1VXAglK1ZEqA1YKPrU"}]
        })

      %{
        method: :post,
        url: "https://whatsapp/v1/contacts",
        headers: [
          {"content-type", "application/json"},
          {"authorization", "Bearer token"}
        ],
        body: @contact_request
      } ->
        json(%{
          contacts: [%{wa_id: "27820000000"}]
        })
    end)

    :ok
  end

  test "Sends the templated message" do
    {:ok, message} =
      create_template_message(%{
        template: "hsm_element_name",
        to: "+27820000000",
        variables: ["Test message"]
      })

    SendTemplateMessage.run(message.id)
    message = get_template_message!(message.id)
    assert message.external_id == "gBEGkYiEB1VXAglK1ZEqA1YKPrU"
  end
end
