defmodule CompanionWeb.OptOutController do
  use CompanionWeb, :controller
  use PhoenixSwagger

  action_fallback CompanionWeb.FallbackController

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.OptOut
  alias Companion.Repo

  def swagger_definitions do
    %{
      OptOutRequest:
        swagger_schema do
          title("OptOutRequest")
          description("Schema for an opt out")

          properties do
            contact(
              Schema.new do
                properties do
                  uuid(:string, "UUID of the contact that requested the opt out",
                    required: true,
                    format: :uuid
                  )
                end
              end
            )
          end

          example(%{
            contact: %{
              uuid: "cdffd588-dc29-469d-b2ac-3a0c2d5d8609"
            }
          })
        end,
      OptOutResponse:
        swagger_schema do
          title("OptOutResponse")
          description("Response schema for a single opt out")

          properties do
            id(:integer, "Unique ID of the Opt Out")
            contact_id(:string, "UUID of the contact that requested the opt out", format: :uuid)
          end

          example(%{
            id: "2",
            contact_id: "cdffd588-dc29-469d-b2ac-3a0c2d5d8609"
          })
        end
    }
  end

  def index(conn, params) do
    {optouts, kerosene} =
      OptOut
      |> OptOut.order_newest_first()
      |> Repo.paginate(params)

    render(conn, "index.html", optouts: optouts, kerosene: kerosene)
  end

  swagger_path(:create) do
    summary("Create opt out")
    description("Creates a new opt out")
    consumes("application/json")
    produces("application/json")

    parameters do
      body(:body, Schema.ref(:OptOutRequest), "The details of the opt out to be created")
    end

    response(
      201,
      "Opt Out created OK",
      Schema.ref(:OptOutResponse)
    )
  end

  def create(conn, %{"contact" => %{"uuid" => contact_id}}) do
    with {:ok, %OptOut{} = opt_out} <- CompanionWeb.create_opt_out(%{contact_id: contact_id}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", opt_out_path(conn, :show, opt_out))
      |> render("show.json", opt_out: opt_out)
    end
  end

  swagger_path(:show) do
    summary("Show opt out")
    description("Shows opt out by ID")
    produces("application/json")
    parameter(:id, :path, :integer, "Opt Out ID", required: true, example: 123)

    response(
      201,
      "Opt Out created OK",
      Schema.ref(:OptOutResponse)
    )
  end

  def show(conn, %{"id" => id}) do
    opt_out = CompanionWeb.get_opt_out!(id)
    render(conn, "show.json", opt_out: opt_out)
  end
end
