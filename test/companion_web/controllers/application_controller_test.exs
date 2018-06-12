defmodule CompanionWeb.ApplicationControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb

  @user %{email: "test@example.org", provider: "google"}
  @create_attrs %{name: "some name"}

  def fixture(:application) do
    {:ok, application} = CompanionWeb.create_application(@create_attrs)
    application
  end

  describe "index" do
    test "lists all applications", %{conn: conn} do
      conn =
        conn
        |> assign(:user, @user)
        |> get(application_path(conn, :index))

      assert html_response(conn, 200) =~ "Name"
    end
  end

  describe "create application" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        conn
        |> assign(:user, @user)
        |> post(application_path(conn, :create), application: @create_attrs)

      assert redirected_to(conn) == application_path(conn, :index)
    end
  end

  describe "delete application" do
    setup [:create_application]

    test "deletes chosen application", %{conn: conn, application: application} do
      conn =
        conn
        |> assign(:user, @user)
        |> delete(application_path(conn, :delete, application))

      assert redirected_to(conn) == application_path(conn, :index)
    end
  end

  defp create_application(_) do
    application = fixture(:application)
    {:ok, application: application}
  end
end
