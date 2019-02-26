defmodule Companion.Clients.WhatsappTest do
  use ExUnit.Case
  import Tesla.Mock
  alias CompanionWeb.Clients.Whatsapp

  @hsm_request Poison.encode!(%{
                 to: "27820000000",
                 type: "hsm",
                 hsm: %{
                   namespace: "hsm_namespace",
                   element_name: "hsm_element_name",
                   localizable_params: [%{default: "test message"}]
                 }
               })
  @contact_check_request Poison.encode!(%{
                           blocking: "wait",
                           contacts: ["27820000000"]
                         })
  @missing_contact_check_request Poison.encode!(%{
                                   blocking: "wait",
                                   contacts: ["27820000001"]
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
        body: @contact_check_request
      } ->
        json(%{
          contacts: [%{wa_id: "27820000000"}]
        })

      %{
        method: :post,
        url: "https://whatsapp/v1/contacts",
        headers: [
          {"content-type", "application/json"},
          {"authorization", "Bearer token"}
        ],
        body: @missing_contact_check_request
      } ->
        json(%{
          contacts: []
        })
    end)

    :ok
  end

  test "send_hsm makes a request to send the templated message" do
    {:ok, %{body: body}} = Whatsapp.send_hsm("27820000000", "hsm_element_name", ["test message"])

    assert body == %{"messages" => [%{"id" => "gBEGkYiEB1VXAglK1ZEqA1YKPrU"}]}
  end

  test "contact_check gets the wa_id of the contact" do
    {:ok, wa_id} = Whatsapp.contact_check("27820000000")

    assert wa_id == "27820000000"
  end

  test "contact_check missing contact returns error" do
    {:error, 404, msg} = Whatsapp.contact_check("27820000001")

    assert msg == "Cannot find WhatsApp contact"
  end
end
