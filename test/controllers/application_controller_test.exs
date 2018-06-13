defmodule Companion.ApplicationControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb.Application
  alias Companion.Repo

  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}
  @user %{email: "test@example.org", provider: "google"}

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> assign(:user, @user)
      |> get(application_path(conn, :index))

    assert html_response(conn, 200) =~ "Name"
  end

  test "renders form on index", %{conn: conn} do
    conn =
      conn
      |> assign(:user, @user)
      |> get(application_path(conn, :index))

    assert html_response(conn, 200) =~ "form"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn =
      conn
      |> assign(:user, @user)
      |> post(application_path(conn, :create), application: @valid_attrs)

    application = Repo.get_by!(Application, @valid_attrs)
    assert application.name == @valid_attrs.name
    assert redirected_to(conn) == application_path(conn, :index)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> assign(:user, @user)
      |> post(application_path(conn, :create), application: @invalid_attrs)

    assert html_response(conn, 200) =~ "Name"
  end

  test "deletes chosen resource", %{conn: conn} do
    application = Repo.insert!(%Application{})

    conn =
      conn
      |> assign(:user, @user)
      |> delete(application_path(conn, :delete, application))

    assert redirected_to(conn) == application_path(conn, :index)
    refute Repo.get(Application, application.id)
  end
end
