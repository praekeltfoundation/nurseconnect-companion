defmodule CompanionWeb.AuthControllerTest do
  use CompanionWeb.ConnCase

  @ueberauth_auth %{credentials: %{token: "aifoejwaofjaowj34"},
                    info: %{email: "test@example.org"},
                    provider: :google}

  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "/auth/google"
    assert redirected_to(conn, 302)
  end

  test "creates user from Google information", %{conn: conn} do
    conn = conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/google/callback")

    assert get_flash(conn, :info) == "Successfully signed in!"
    assert get_session(conn, :user) == %{
      token: @ueberauth_auth.credentials.token,
      email: @ueberauth_auth.info.email,
      provider: :google
    }
  end
end
