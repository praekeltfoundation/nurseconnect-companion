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

defmodule CompanionWeb.Plugs.ExtractApplicationFromHeader do
  @moduledoc """
  Extracts the token from the headers and looks up the application for the token and assigns it
  to `application`.
  """
  import Plug.Conn
  import Companion.CompanionWeb

  def init(default), do: default

  def call(%{assigns: %{application: _application}} = conn, _) do
    # If there's already a user, then don't overwrite
    conn
  end

  def call(conn, _) do
    application =
      conn
      |> get_req_header("authorization")
      |> fetch_token_from_header
      |> get_application

    assign(conn, :application, application)
  end

  defp fetch_token_from_header([]) do
    :no_token
  end

  defp fetch_token_from_header([token | _]) do
    case String.split(token) do
      ["Token", value] -> value
      _ -> :no_token
    end
  end

  defp get_application(:no_token) do
    nil
  end

  defp get_application(token) do
    get_application_by_token(token)
  end
end

defmodule CompanionWeb.Plugs.RequireApplication do
  @moduledoc """
  A plug that if there's no `application` in the session, returns a 401 Unauthorized
  """
  import Plug.Conn

  def init(default), do: default

  def call(%{assigns: %{application: nil}} = conn, _) do
    conn
    |> send_resp(:unauthorized, "")
    |> halt
  end

  def call(%{assigns: %{application: _application}} = conn, _) do
    conn
  end
end
