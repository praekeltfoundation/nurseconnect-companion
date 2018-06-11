defmodule CompanionWeb.AuthController do
  use CompanionWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = %{email: auth.info.email, provider: auth.provider}
    {_, strategy_config} = Application.get_env(:ueberauth, Ueberauth)[:providers][:google]

    conn
    |> attempt_login(user, auth.info.urls[:website] == strategy_config[:hd])
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Sign in failed")
    |> redirect(to: "/")
  end

  defp attempt_login(conn, user, true) do
    conn
    |> put_flash(:info, "Successfully signed in!")
    |> put_session(:user, user)
  end

  defp attempt_login(conn, _user, false) do
    conn
    |> put_flash(:error, "Sign in failed. Invalid domain")
  end

  def login(conn, _params) do
    render(conn, "login.html", user: get_session(conn, :user))
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Successfully logged out")
    |> redirect(to: "/")
  end
end
