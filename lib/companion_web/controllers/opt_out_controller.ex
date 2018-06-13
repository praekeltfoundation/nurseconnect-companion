defmodule CompanionWeb.OptOutController do
  use CompanionWeb, :controller

  action_fallback CompanionWeb.FallbackController

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.OptOut
  alias Companion.Repo

  def index(conn, params) do
    {optouts, kerosene} =
      OptOut
      |> OptOut.order_newest_first()
      |> Repo.paginate(params)

    render(conn, "index.html", optouts: optouts, kerosene: kerosene)
  end

  def create(conn, %{"contact" => contact_id}) do
    with {:ok, %OptOut{} = opt_out} <- CompanionWeb.create_opt_out(%{contact_id: contact_id}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", opt_out_path(conn, :show, opt_out))
      |> render("show.json", opt_out: opt_out)
    end
  end

  def show(conn, %{"id" => id}) do
    opt_out = CompanionWeb.get_opt_out!(id)
    render(conn, "show.json", opt_out: opt_out)
  end
end
