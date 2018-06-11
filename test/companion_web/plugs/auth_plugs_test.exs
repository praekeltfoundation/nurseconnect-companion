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
