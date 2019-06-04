defmodule CompanionWeb.RegistrationController do
  use CompanionWeb, :controller
  use PhoenixSwagger

  alias CompanionWeb.FallbackController

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.Registration

  action_fallback FallbackController

  def swagger_definitions do
    %{
      RegistrationRequest:
        swagger_schema do
          title("RegistrationRequest")
          description("Schema for a registration")

          properties do
            channel(:string, "Registration channel. SMS or WhatsApp")
            facility_code(:string, "Code for facility where registration took place")
            msisdn(:string, "MSISDN of person registered")
            registered_by(:string, "MSISDN of person who performed the registration")
            persal(:string, "Persal code of person registered", required: false)
            sanc(:string, "SANC code of person registered", required: false)

            timestamp(:timestamp, "UTC timestamp of when the registration occurred",
              format: :utc_datetime
            )
          end

          example(%{
            channel: "WhatsApp",
            facility_code: "123456",
            msisdn: "+27820001001",
            registered_by: "+27820001002",
            timestamp: "2018-01-01T01:01:01"
          })
        end
    }
  end

  swagger_path(:create) do
    summary("Create registration")
    description("Creates a new registration")
    consumes("application/json")
    produces("application/json")

    parameters do
      body(
        :body,
        Schema.ref(:RegistrationRequest),
        "The details of the registration to be created"
      )
    end

    response(
      201,
      "Registration created OK",
      Schema.ref(:RegistrationRequest)
    )
  end

  def create(conn, %{}) do
    conn = conn |> fetch_query_params()

    with {:ok, %Registration{} = registration} <-
           CompanionWeb.create_registration(conn.query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", registration_path(conn, :show, registration))
      |> render("show.json", registration: registration)
    end
  end

  def show(conn, %{"id" => id}) do
    registration = CompanionWeb.get_registration!(id)
    render(conn, "show.json", registration: registration)
  end
end
