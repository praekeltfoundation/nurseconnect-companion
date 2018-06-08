defmodule CompanionWeb.AuthController do
  use CompanionWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = %{email: auth.info.email, provider: auth.provider}

    conn
    |> put_flash(:info, "Successfully signed in!")
    |> put_session(:user, user)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Sign in failed")
    |> redirect(to: "/")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end
end
