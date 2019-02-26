defmodule CompanionWeb.TemplateMessageControllerTest do
  use CompanionWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.Application

  @application %Application{name: "test", token: Ecto.UUID.generate()}
  @create_attrs %{
    contact: %{urn: "whatsapp:27820000000"}
  }
  @invalid_attrs %{
    contact: %{urn: "+27820000000"}
  }

  def fixture(:template_message) do
    {:ok, template_message} = CompanionWeb.create_template_message(@create_attrs)
    template_message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create template_message" do
    test "renders template_message when data is valid", %{conn: conn, swagger_schema: schema} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(
          template_message_path(
            conn,
            :create,
            template: "some template",
            variable: ["some", "variables"]
          ),
          @create_attrs
        )
        |> validate_resp_schema(schema, "TemplateMessageResponse")

      assert %{"id" => id} = json_response(conn, 201)

      conn =
        build_conn()
        |> assign(:application, @application)
        |> get(template_message_path(conn, :show, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "template" => "some template",
               "variables" => ["some", "variables"],
               "external_id" => nil,
               "to" => "+27820000000"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(template_message_path(conn, :create), @invalid_attrs)

      assert json_response(conn, 400) == %{"error" => "Invalid WhatsApp URN: +27820000000"}
    end

    test "renders errors when content is missing", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(template_message_path(conn, :create), @create_attrs)

      assert json_response(conn, 400) == %{
               "error" => "Query string parameter 'template' is required"
             }
    end
  end
end
