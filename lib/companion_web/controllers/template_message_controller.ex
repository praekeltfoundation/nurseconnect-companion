defmodule CompanionWeb.TemplateMessageController do
  use CompanionWeb, :controller

  action_fallback CompanionWeb.FallbackHSMController

  alias Companion.CompanionWeb

  def create(conn, %{"contact" => %{"urn" => urn}}) do
    with {:ok, address} <- get_address_from_urn(urn),
         {:ok, message} <- get_content_from_query_string(conn),
         {:ok, templatemessage} <-
           CompanionWeb.create_template_message(%{to: address, content: message}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", template_message_path(conn, :show, templatemessage))
      |> render("show.json", template_message: templatemessage)
    end
  end

  defp get_address_from_urn(urn) do
    case String.split(urn, ":") do
      [_, "+" <> address] -> {:ok, "+" <> address}
      [_, address] -> {:ok, "+" <> address}
      _ -> {:error, :bad_request, "Invalid WhatsApp URN: #{urn}"}
    end
  end

  defp get_content_from_query_string(conn) do
    conn = conn |> fetch_query_params()

    case conn.query_params["content"] do
      nil -> {:error, :bad_request, "Query string parameter 'content' is required"}
      "" -> {:error, :bad_request, "Query string parameter 'content' cannot be empty"}
      content -> {:ok, content}
    end
  end

  def show(conn, %{"id" => id}) do
    template_message = CompanionWeb.get_template_message!(id)
    render(conn, "show.json", template_message: template_message)
  end
end
