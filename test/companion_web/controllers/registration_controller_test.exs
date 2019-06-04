defmodule CompanionWeb.RegistrationControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb.Application

  @create_attrs %{
    channel: "some channel",
    facility_code: "some facility_code",
    msisdn: "some msisdn",
    registered_by: "some registered_by",
    timestamp: "2018-01-01T01:01:01.000000"
  }
  @invalid_attrs %{channel: nil, facility_code: nil, msisdn: nil, registered_by: nil}
  @application %Application{name: "test", token: Ecto.UUID.generate()}

  setup %{conn: conn} do
    conn =
      conn
      |> assign(:application, @application)
      |> put_req_header("accept", "application/json")

    {:ok, %{conn: conn}}
  end

  describe "create registration" do
    test "renders registration when data is valid", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create, Map.to_list(@create_attrs)))
      assert %{"id" => id, "timestamp" => created} = json_response(conn, 201)

      conn =
        build_conn()
        |> assign(:application, @application)
        |> get(registration_path(conn, :show, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "channel" => "some channel",
               "facility_code" => "some facility_code",
               "msisdn" => "some msisdn",
               "persal" => nil,
               "registered_by" => "some registered_by",
               "sanc" => nil,
               "timestamp" => created
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create, Map.to_list(@invalid_attrs)))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
