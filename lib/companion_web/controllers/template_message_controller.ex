defmodule CompanionWeb.TemplateMessageController do
  use CompanionWeb, :controller

  alias CompanionWeb.FallbackController

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.TemplateMessage

  action_fallback FallbackController

  def create(conn, template_message_params) do
    template_message_params =
      template_message_params
      |> Map.delete("external_id")

    with {:ok, %TemplateMessage{} = template_message} <-
           CompanionWeb.create_template_message(template_message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", template_message_path(conn, :show, template_message))
      |> render("show.json", template_message: template_message)
    end
  end

  def show(conn, %{"id" => id}) do
    template_message = CompanionWeb.get_template_message!(id)
    render(conn, "show.json", template_message: template_message)
  end
end
