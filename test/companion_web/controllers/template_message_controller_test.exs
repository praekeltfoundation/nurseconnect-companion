defmodule CompanionWeb.TemplateMessageControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.Application

  @application %Application{name: "test", token: Ecto.UUID.generate()}
  @create_attrs %{content: "some content", to: "some to", external_id: "some external_id"}
  @invalid_attrs %{content: nil, external_id: nil, to: nil}

  def fixture(:template_message) do
    {:ok, template_message} = CompanionWeb.create_template_message(@create_attrs)
    template_message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create template_message" do
    test "renders template_message when data is valid", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(template_message_path(conn, :create), @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)

      conn =
        build_conn()
        |> assign(:application, @application)
        |> get(template_message_path(conn, :show, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "content" => "some content",
               "external_id" => nil,
               "to" => "some to"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(template_message_path(conn, :create), @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
