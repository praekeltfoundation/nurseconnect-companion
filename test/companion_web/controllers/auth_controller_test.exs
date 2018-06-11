defmodule CompanionWeb.AuthControllerTest do
  use CompanionWeb.ConnCase

  @ueberauth_auth %{
    credentials: %{token: "aifoejwaofjaowj34"},
    info: %{email: "test@example.org", urls: %{website: "example.org"}},
    provider: :google
  }

  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get(conn, "/auth/google")
    assert redirected_to(conn, 302)
  end

  test "creates user from Google information", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/google/callback")

    assert get_flash(conn, :info) == "Successfully signed in!"

    assert get_session(conn, :user) == %{
             email: @ueberauth_auth.info.email,
             provider: :google
           }
  end

  test "doesn't log use in if Google auth fails", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_failure, %{})
      |> get("/auth/google/callback")

    assert get_flash(conn, :error) == "Sign in failed"

    assert get_session(conn, :user) == nil
  end

  test "doesn't log user in if incorrect domain", %{conn: conn} do
    # Domain is set to example.org in test config
    auth = %{@ueberauth_auth | info: %{email: "test@bad.com", urls: %{website: "bad.com"}}}

    conn =
      conn
      |> assign(:ueberauth_auth, auth)
      |> get("/auth/google/callback")

    assert get_flash(conn, :error) == "Sign in failed. Invalid domain"

    assert get_session(conn, :user) == nil
  end

  test "Login page contains link to login with Google auth", %{conn: conn} do
    conn =
      conn
      |> get("/auth/login")

    assert html_response(conn, 200) =~ "Sign in with Google"
  end
end
