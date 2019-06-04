defmodule Companion.Jobs.ProcessRegistration do
  @moduledoc """
  Does the processing required for registration hooks from Rapidpro.

  Submits the registration to Jembi
  """
  import Companion.CompanionWeb
  use Honeydew.Progress
  alias Companion.CompanionWeb.Registration
  alias Companion.Repo
  alias CompanionWeb.Clients.OpenHIM

  @mha_praekelt 1
  @swt_sms 1
  @swt_whatsapp 7
  @type_nurse_registration 7

  def supervisor_config do
    [
      :process_registration,
      schema: Registration,
      repo: Repo,
      stale_timeout: Application.get_env(:honeydew, :timeout),
      failure_mode:
        {Honeydew.FailureMode.Retry,
         [
           times: Application.get_env(:honeydew, :retries)
         ]},
      success_mode: Honeydew.SuccessMode.Log
    ]
  end

  defp swt_from_channel("WhatsApp") do
    @swt_whatsapp
  end

  defp swt_from_channel(_) do
    @swt_sms
  end

  defp id_from_msisdn(msisdn) do
    "+" <> msisdn = msisdn
    msisdn <> "^^^ZAF^TEL"
  end

  defp openhim_registration_from_registration(registration) do
    %{
      mha: @mha_praekelt,
      swt: swt_from_channel(registration.channel),
      type: @type_nurse_registration,
      dmsisdn: registration.registered_by,
      cmsisdn: registration.msisdn,
      rmsisdn: nil,
      faccode: registration.facility_code,
      id: id_from_msisdn(registration.msisdn),
      dob: nil,
      persal: registration.persal,
      sanc: registration.sanc,
      encdate:
        registration.timestamp
        |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")
    }
  end

  def run(id) do
    _ =
      id
      |> get_registration!()
      |> openhim_registration_from_registration()
      |> OpenHIM.submit_nurseconnect_registration()
  end
end
