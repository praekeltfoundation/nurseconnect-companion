defmodule CompanionWeb.AuthController do
  use CompanionWeb, :controller
  plug Ueberauth

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = %{token: auth.credentials.token, email: auth.info.email, provider: auth.provider}
    conn
    |> put_flash(:info, "Successfully signed in!")
    |> put_session(:user, user)
    |> redirect(to: "/")
  end
end
