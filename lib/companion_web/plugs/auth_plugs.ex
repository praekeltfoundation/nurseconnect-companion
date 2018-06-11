defmodule CompanionWeb.Plugs.RequireLoggedIn do
  @moduledoc """
  A plug that if there's no `user` in the session, redirects to the specified `url`
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(%{assigns: %{user: nil}} = conn, auth_url) do
    conn
    |> redirect(to: auth_url)
    |> halt
  end

  def call(%{assigns: %{user: _user}} = conn, _url) do
    conn
  end
end

defmodule CompanionWeb.Plugs.ExtractUserFromSession do
  @moduledoc """
  Extracts the user from the session and puts it on the conn
  """
  import Plug.Conn

  def init(default), do: default

  def call(%{assigns: %{user: _user}} = conn, _) do
    # If there's already a user, then don't overwrite
    conn
  end

  def call(conn, _) do
    assign(conn, :user, get_session(conn, :user))
  end
end
