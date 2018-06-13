defmodule CompanionWeb.OptOutControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb.Application

  @application %Application{name: "test", token: Ecto.UUID.generate()}
  @user %{email: "test@example.org", provider: "google"}
  @create_attrs %{contact: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{contact: nil}

  describe "index" do
    test "lists all optouts", %{conn: conn} do
      conn =
        conn
        |> assign(:user, @user)
        |> get(opt_out_path(conn, :index))

      assert html_response(conn, 200) =~ "Contact"
    end
  end

  describe "create opt_out" do
    test "renders opt_out when data is valid", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(opt_out_path(conn, :create), @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)

      conn =
        build_conn()
        |> assign(:application, @application)
        |> get(opt_out_path(conn, :show, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "contact_id" => "7488a646-e31f-11e4-aace-600308960662"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> assign(:application, @application)
        |> post(opt_out_path(conn, :create), @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
