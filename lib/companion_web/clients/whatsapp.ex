defmodule CompanionWeb.Clients.Whatsapp do
  @moduledoc """
  A client for the WhatsApp API. Only implements the endpoints that we require
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, Application.get_env(:companion, :whatsapp)[:url]
  plug Tesla.Middleware.JSON, engine: Poison

  plug Tesla.Middleware.Headers, [
    {"authorization", "Bearer " <> Application.get_env(:companion, :whatsapp)[:token]}
  ]

  plug Tesla.Middleware.Logger

  @doc """
  Given the address and message, sends the HSM
  """
  def send_hsm(to, message) do
    post("/v1/messages", %{
      to: to,
      type: "hsm",
      hsm: %{
        namespace: Application.get_env(:companion, :whatsapp)[:hsm_namespace],
        element_name: Application.get_env(:companion, :whatsapp)[:hsm_element_name],
        localizable_params: [%{default: message}]
      }
    })
    |> raise_for_status()
  end

  defp raise_for_status({:ok, response}) do
    case response.status do
      status when status in 200..299 ->
        {:ok, response}

      status ->
        {:error, status, response.body}
    end
  end

  defp raise_for_status({:error, error}), do: {:error, :client_error, error}
end
