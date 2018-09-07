defmodule CompanionWeb.Clients.Whatsapp do
  @moduledoc """
  A client for the WhatsApp API. Only implements the endpoints that we require
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, Application.get_env(:companion, :whatsapp)[:url]
  plug Tesla.Middleware.JSON, engine: Poison

  @doc """
  Get the token and expiry for the configured WhatsApp user
  """
  def login! do
    config = Application.get_env(:companion, :whatsapp)

    %{body: %{"users" => [%{"token" => token, "expires_after" => expires} | _]}} =
      post!(
        "/v1/users/login",
        %{},
        headers: [authorization: "Basic " <> basic_auth(config[:username], config[:password])]
      )

    {token, expires}
  end

  defp basic_auth(username, password) do
    Base.encode64("#{username}:#{password}")
  end

  @doc """
  Build the client with a runtime token argument
  """
  def client(token) do
    Tesla.build_client([
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ])
  end

  @doc """
  Given the address and message, sends the HSM
  """
  def send_hsm!(client, to, message) do
    post!(client, "/v1/messages", %{
      to: to,
      type: "hsm",
      hsm: %{
        namespace: Application.get_env(:companion, :whatsapp)[:hsm_namespace],
        element_name: Application.get_env(:companion, :whatsapp)[:hsm_element_name],
        localizable_params: [%{default: message}]
      }
    })
  end
end
