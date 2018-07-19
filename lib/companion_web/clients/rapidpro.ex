defmodule CompanionWeb.Clients.Rapidpro do
  @moduledoc """
  A client for the rapidpro API. Only implements the endpoints that we require
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, Application.get_env(:companion, :rapidpro)[:url]

  plug Tesla.Middleware.Headers, [
    {"authorization", "Token " <> Application.get_env(:companion, :rapidpro)[:token]}
  ]

  plug Tesla.Middleware.JSON, engine: Poison

  @doc """
  Given the string UUID of the contact, fetches that contact from Rapidpro
  """
  def get_contact(uuid) do
    response = get!("/api/v2/contacts.json", query: [uuid: uuid])
    %{"results" => [contact | _]} = response.body
    contact
  end
end
