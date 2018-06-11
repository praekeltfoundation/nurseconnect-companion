defmodule CompanionWeb.Plugs.RequireLoggedIn do
  @moduledoc """
  A plug that if there's no `user` in the session, redirects to the specified `url`
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, url) do
    case get_session(conn, :user) do
      nil ->
        conn
        |> redirect(to: url)
        |> halt

      _ ->
        conn
    end
  end
end
