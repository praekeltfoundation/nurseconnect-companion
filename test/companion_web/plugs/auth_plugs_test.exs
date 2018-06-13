defmodule CompanionWeb.Plugs.RequireLoggedInTest do
  use CompanionWeb.ConnCase
  alias CompanionWeb.Plugs

  @user %{email: "test@example.org", provider: "google"}

  test "user is redirected when user is not assigned" do
    conn =
      build_conn()
      |> assign(:user, nil)
      |> Plugs.RequireLoggedIn.call("/auth/login")

    assert redirected_to(conn) == "/auth/login"
  end

  test "user is not redirected when user is assigned" do
    conn =
      build_conn()
      |> assign(:user, @user)
      |> Plugs.RequireLoggedIn.call("/auth/login")

    assert conn.status !== 302
  end
end

defmodule CompanionWeb.Plugs.ExtractUserFromSessionTest do
  use CompanionWeb.ConnCase
  alias CompanionWeb.Plugs

  @user %{email: "test@example.org", provider: "google"}

  def session_conn do
    opts =
      Plug.Session.init(
        store: :cookie,
        key: "foobar",
        encryption_salt: "encrypted cookie salt",
        signing_salt: "signing salt",
        log: false,
        encrypt: false
      )

    build_conn()
    |> Plug.Session.call(opts)
    |> fetch_session()
  end

  test "user assigned to conn" do
    conn =
      session_conn()
      |> put_session(:user, @user)
      |> Plugs.ExtractUserFromSession.call(nil)

    assert conn.assigns() == %{user: @user}
  end

  test "user already exists in conn not overridden" do
    conn =
      session_conn()
      |> assign(:user, %{test: "user"})
      |> put_session(:user, @user)
      |> Plugs.ExtractUserFromSession.call(nil)

    assert conn.assigns() == %{user: %{test: "user"}}
  end
end

defmodule CompanionWeb.Plugs.ExtractApplicationFromHeaderTests do
  use CompanionWeb.ConnCase
  alias CompanionWeb.Plugs
  import Companion.CompanionWeb

  test "application assigned to conn", %{conn: conn} do
    {:ok, application} = create_application(%{name: "test"})

    conn =
      conn
      |> put_req_header("authorization", "Token #{application.token}")
      |> Plugs.ExtractApplicationFromHeader.call(nil)

    assert conn.assigns() == %{application: application}
  end

  test "invalid token means no application assigned to conn", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Token bad-token")
      |> Plugs.ExtractApplicationFromHeader.call(nil)

    assert conn.assigns() == %{application: nil}
  end

  test "missing header means no application assigned to conn", %{conn: conn} do
    conn =
      conn
      |> Plugs.ExtractApplicationFromHeader.call(nil)

    assert conn.assigns() == %{application: nil}
  end

  test "invalid header means no application assigned to conn", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "whoops token")
      |> Plugs.ExtractApplicationFromHeader.call(nil)

    assert conn.assigns() == %{application: nil}
  end

  test "token not in database means no application assigned to conn", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Token #{Ecto.UUID.generate()}")
      |> Plugs.ExtractApplicationFromHeader.call(nil)

    assert conn.assigns() == %{application: nil}
  end
end

defmodule CompanionWeb.Plugs.RequireApplicationTest do
  use CompanionWeb.ConnCase
  alias Companion.CompanionWeb.Application
  alias CompanionWeb.Plugs

  @application %Application{name: "test", token: Ecto.UUID.generate()}

  test "unauthorized returned when application is not assigned", %{conn: conn} do
    conn =
      conn
      |> assign(:application, nil)
      |> Plugs.RequireApplication.call(nil)

    assert conn.status == 401
    assert conn.halted
  end

  test "status not changed when application is assigned", %{conn: conn} do
    conn =
      conn
      |> assign(:application, @application)
      |> Plugs.RequireApplication.call(nil)

    assert conn.status != 401
    refute conn.halted
  end
end
