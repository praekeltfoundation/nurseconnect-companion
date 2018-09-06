defmodule Companion.Clients.WhatsappTest do
  use ExUnit.Case
  import Tesla.Mock
  alias CompanionWeb.Clients.Whatsapp

  @empty_json Poison.encode!(%{})
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
        url: "https://whatsapp/v1/users/login",
        headers: [{:authorization, "Basic dXNlcjpwYXNz"}, {"content-type", "application/json"}],
        body: @empty_json
      } ->
        json(%{
          users: [
            %{
              token: "testtoken",
              expires_after: "2018-09-11 12:48:55+00:00"
            }
          ]
        })

      %{
        method: :post,
        url: "https://whatsapp/v1/messages",
        headers: [
          {"authorization", "Bearer testtoken"},
          {"content-type", "application/json"}
        ],
        body: @hsm_request
      } ->
        json(%{
          messages: [%{id: "gBEGkYiEB1VXAglK1ZEqA1YKPrU"}]
        })
    end)

    :ok
  end

  test "login! gets token and expiry" do
    {token, expires} = Whatsapp.login!()
    assert token == "testtoken"
    assert expires == "2018-09-11 12:48:55+00:00"
  end

  test "send_hsm! makes a request to send the templated message" do
    %{body: body} =
      Whatsapp.login!()
      |> elem(0)
      |> Whatsapp.client()
      |> Whatsapp.send_hsm!("27820000000", "test message")

    assert body == %{"messages" => [%{"id" => "gBEGkYiEB1VXAglK1ZEqA1YKPrU"}]}
  end
end
