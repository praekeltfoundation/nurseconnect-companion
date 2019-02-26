defmodule CompanionWeb.TemplateMessageController do
  use CompanionWeb, :controller
  use PhoenixSwagger

  action_fallback CompanionWeb.FallbackHSMController

  alias Companion.CompanionWeb

  def swagger_definitions do
    %{
      TemplateMessageRequest:
        swagger_schema do
          title("TemplateMessageRequest")
          description("Schema for a template message request")

          properties do
            contact(
              Schema.new do
                properties do
                  urn(
                    :string,
                    "URN of the contact. Must be of type whatsapp",
                    required: true,
                    format: :urn
                  )
                end
              end
            )
          end

          example(%{
            contact: %{
              urn: "whatsapp:27820000000"
            }
          })
        end,
      TemplateMessageResponse:
        swagger_schema do
          title("TemplateMessage")
          description("Response schema for a template message")

          properties do
            id(:integer, "ID of the sent message", format: :integer)
            to(:string, "The to address that the message will be sent to", format: :string)
            template(:string, "The template to use for the message", format: :string)
            variables(:array, "The list of variables to fill into the template", format: :array)

            external_id(
              :string,
              "The ID of the message on the external system",
              format: :string,
              nullable: true
            )
          end

          example(%{
            to: "+27820000000",
            id: 11,
            external_id: "gBEGkYiEB1VXAglK1ZEqA1YKPrU",
            template: "template_name",
            variables: ["variable1", "variable2"]
          })
        end
    }
  end

  swagger_path(:create) do
    summary("Create templated message")
    description("Creates a new templated message")
    consumes("application/json")
    produces("application/json")

    parameter(
      "template",
      :query,
      :string,
      "Which template to use for this message",
      required: true
    )

    parameter(
      "variable[]",
      :query,
      :string,
      "Each instance adds another variable to insert into the template",
      required: false
    )

    parameters do
      body(
        :body,
        Schema.ref(:TemplateMessageRequest),
        "The details of the template to be created"
      )
    end

    response(
      201,
      "Template message created OK",
      Schema.ref(:TemplateMessageResponse)
    )
  end

  def create(conn, %{"contact" => %{"urn" => urn}}) do
    with {:ok, address} <- get_address_from_urn(urn),
         {:ok, variables} <- get_variables_from_query_string(conn),
         {:ok, template} <- get_template_from_query_string(conn),
         {:ok, templatemessage} <-
           CompanionWeb.create_template_message(%{
             to: address,
             template: template,
             variables: variables
           }) do
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

  defp get_template_from_query_string(conn) do
    conn = conn |> fetch_query_params()

    case conn.query_params["template"] do
      nil -> {:error, :bad_request, "Query string parameter 'template' is required"}
      "" -> {:error, :bad_request, "Query string parameter 'template' cannot be empty"}
      content -> {:ok, content}
    end
  end

  defp get_variables_from_query_string(conn) do
    conn = conn |> fetch_query_params()

    case conn.query_params["variable"] do
      nil -> {:ok, []}
      "" -> {:ok, []}
      [h | t] -> {:ok, [h | t]}
      content -> {:ok, [content]}
    end
  end

  def show(conn, %{"id" => id}) do
    template_message = CompanionWeb.get_template_message!(id)
    render(conn, "show.json", template_message: template_message)
  end
end
