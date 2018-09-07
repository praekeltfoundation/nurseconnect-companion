defmodule CompanionWeb.HSMControllerTest do
  use CompanionWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias Companion.CompanionWeb.Application
  import Tesla.Mock

  @application %Application{name: "test", token: Ecto.UUID.generate()}
  @create_attrs %{
    contact: %{uuid: "b8225caf-cd55-47f8-8e2f-11206571bf1f", urn: "whatsapp:27820000000"}
  }
  @invalid_create_attrs %{
    contact: %{uuid: "b8225caf-cd55-47f8-8e2f-11206571bf1f", urn: "tel:+27820000000"}
  }
  @empty_json Poison.encode!(%{})
  @hsm_request Poison.encode!(%{
                 to: "27820000000",
                 type: "hsm",
                 hsm: %{
                   namespace: "hsm_namespace",
                   element_name: "hsm_element_name",
                   localizable_params: [%{default: "Test message"}]
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

  describe "create hsm" do
    test "renders hsm when data is valid", %{conn: conn, swagger_schema: schema} do
      conn =
        conn
        |> assign(:application, @application)
        |> put_req_header("x-message-content", "Test message")
        |> post(hsm_path(conn, :create), @create_attrs)
        |> validate_resp_schema(schema, "HSMResponse")

      assert %{"messages" => [%{"id" => "gBEGkYiEB1VXAglK1ZEqA1YKPrU"}]} =
               json_response(conn, 201)
    end

    test "renders error when x-message-content header is missing", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(hsm_path(conn, :create), @create_attrs)

      assert %{"error" => "X-Message-Content header must be supplied"} = json_response(conn, 400)
    end

    test "renders error when contact details are missing", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> put_req_header("x-message-content", "Test message")
        |> post(hsm_path(conn, :create), %{})

      assert %{"error" => "Missing contact URN"} = json_response(conn, 400)
    end

    test "renders error when contact URN is invalid", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> put_req_header("x-message-content", "Test message")
        |> post(hsm_path(conn, :create), @invalid_create_attrs)

      assert %{"error" => "Invalid WhatsApp URN: tel:+27820000000"} = json_response(conn, 400)
    end
  end
end
