defmodule CompanionWeb.HSMController do
  use CompanionWeb, :controller
  use PhoenixSwagger

  action_fallback CompanionWeb.FallbackHSMController

  alias CompanionWeb.Clients.Whatsapp

  def swagger_definitions do
    %{
      HSMRequest:
        swagger_schema do
          title("HSMRequest")
          description("Schema for an HSM request")

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
      HSMMessage:
        swagger_schema do
          title("HSMMessage")
          description("Response schema for an HSM message")

          properties do
            id(:string, "ID of the sent message", format: :uuid)
          end

          example(%{
            id: "gBEGkYiEB1VXAglK1ZEqA1YKPrU"
          })
        end,
      HSMResponse:
        swagger_schema do
          title("HSM Response")
          description("Response schema for HSM creation")

          properties do
            messages(
              Schema.new do
                type(:array)
                items(Schema.ref(:HSMMessage))
              end
            )
          end
        end
    }
  end

  swagger_path(:create) do
    summary("Create HSM")
    description("Creates a new HSM")
    consumes("application/json")
    produces("application/json")

    parameter(
      "X-Message-Content",
      :header,
      :string,
      "Message content for the HSM",
      required: true
    )

    parameters do
      body(:body, Schema.ref(:HSMRequest), "The details of the HSM to be created")
    end

    response(
      201,
      "HSM created OK",
      Schema.ref(:HSMResponse)
    )
  end

  def create(conn, %{"contact" => %{"urn" => urn}}) do
    with {:ok, address} <- get_address_from_urn(urn),
         {:ok, message} <- get_message_from_header(conn) do
      response =
        ConCache.get_or_store(:whatsapp_token, :whatsapp_token, fn ->
          {token, expire} = Whatsapp.login!()

          seconds =
            Timex.Interval.new(
              from: Timex.now(),
              # We should expire 5 minutes before the token expires
              until: Timex.shift(Timex.parse!(expire, "{ISO:Extended}"), minutes: -5)
            )
            |> Timex.Interval.duration(:seconds)

          %ConCache.Item{value: token, ttl: :timer.seconds(seconds)}
        end)
        |> Whatsapp.client()
        |> Whatsapp.send_hsm!(address, message)

      conn
      |> put_status(:created)
      |> render("create.json", response: response.body)
    end
  end

  def create(_, _) do
    {:error, :bad_request, "Missing contact URN"}
  end

  defp get_address_from_urn("whatsapp:" <> address) do
    {:ok, address}
  end

  defp get_address_from_urn(urn) do
    {:error, :bad_request, "Invalid WhatsApp URN: #{urn}"}
  end

  defp get_message_from_header(%Plug.Conn{} = conn) do
    conn
    |> get_req_header("x-message-content")
    |> get_message_from_header()
  end

  defp get_message_from_header([message]) do
    {:ok, message}
  end

  defp get_message_from_header(_) do
    {:error, :bad_request, "X-Message-Content header must be supplied"}
  end
end
