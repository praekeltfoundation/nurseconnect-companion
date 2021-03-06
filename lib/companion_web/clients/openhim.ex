defmodule CompanionWeb.Clients.OpenHIM do
  @moduledoc """
  A client for the OpenHIM API. Only implements the endpoints that we require
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, Application.get_env(:companion, :openhim)[:url]

  plug Tesla.Middleware.BasicAuth,
    username: Application.get_env(:companion, :openhim)[:username],
    password: Application.get_env(:companion, :openhim)[:password]

  plug Tesla.Middleware.Headers, [
    {"user-agent", "nurseconnect-companion"}
  ]

  plug Tesla.Middleware.JSON, engine: Poison
  plug Tesla.Middleware.Logger

  @doc """
  Given the optout with the following data:

  mha: integer
  swt: integer
  type: integer, 8
  cmsisdn: string, msisdn
  dmsisdn: string, msisdn
  rmsisdn: string, msisdn, optional
  faccode: string, facility code
  id: string, '{identifier}^^^{country}^{type}'
  dob: string, date, optional
  optoutreason, integer, optional
  encdate, string, date

  Sends the optout to the OpenHIM API
  """
  def create_nurseconnect_optout(optout) do
    post!("ws/rest/v1/nc/optout", optout)
  end

  @doc """
  Given the registration with the following data:

  mha: integer
  swt: integer
  type: integer
  cmsisdn: string, msisdn
  dmsisdn: string, msisdn
  rmsisdn: string, msisdn, optional
  faccode: string, facility code
  id: string, '{identifier}^^^{country}^{type}'
  dob: string, date, optional
  persal: string, optional
  sanc: string, optional
  encdate, string, date

  Sends the optout to the OpenHIM API
  """
  def submit_nurseconnect_registration(registration) do
    post!("ws/rest/v1/nc/subscription", registration)
  end
end
