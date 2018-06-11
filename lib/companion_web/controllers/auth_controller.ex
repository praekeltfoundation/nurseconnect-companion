defmodule CompanionWeb.AuthController do
  use CompanionWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = %{email: auth.info.email, provider: auth.provider}
    {_, strategy_config} = Application.get_env(:ueberauth, Ueberauth)[:providers][:google]

    if auth.info.urls[:website] == strategy_config[:hd] do
      conn
      |> put_flash(:info, "Successfully signed in!")
      |> put_session(:user, user)
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "Sign in failed. Invalid domain")
      |> redirect(to: "/")
    end
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
