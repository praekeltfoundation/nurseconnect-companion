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
    end)

    :ok
  end

  test "send_hsm makes a request to send the templated message" do
    {:ok, %{body: body}} = Whatsapp.send_hsm("27820000000", "test message")

    assert body == %{"messages" => [%{"id" => "gBEGkYiEB1VXAglK1ZEqA1YKPrU"}]}
  end
end
