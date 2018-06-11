defmodule CompanionWeb.PageController do
  use CompanionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", user: get_session(conn, :user))
  end
end
