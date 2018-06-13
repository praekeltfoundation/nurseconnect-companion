defmodule CompanionWeb.ApiRootController do
  use CompanionWeb, :controller

  def index(conn, _params) do
    json(conn, %{})
  end
end
