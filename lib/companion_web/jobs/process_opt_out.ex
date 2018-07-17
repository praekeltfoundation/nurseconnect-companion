defmodule Companion.Jobs.ProcessOptOut do
  @moduledoc """
  Does the processing required for opt out hooks from Rapidpro.

  Submits the opt out to Jembi
  """
  import Companion.CompanionWeb
  use Honeydew.Progress
  alias Companion.CompanionWeb.OptOut
  alias Companion.Repo
  alias CompanionWeb.Clients.OpenHIM
  alias CompanionWeb.Clients.Rapidpro

  @mha_praekelt 1
  @swt_sms 1
  @type_nurse_optout 8
  @reason_unknown 6

  def supervisor_config do
    [
      :process_opt_out,
      schema: OptOut,
      repo: Repo,
      stale_timeout: Application.get_env(:honeydew, :timeout),
      failure_mode:
        {Honeydew.FailureMode.Retry,
         [
           times: Application.get_env(:honeydew, :retries),
           finally: {Companion.Jobs.ProcessOptOut.Failure, []}
         ]},
      success_mode: Honeydew.SuccessMode.Log
    ]
  end

  defp extract_number_from_urn(urn) do
    [_, number] = String.split(urn, ":")
    number
  end

  defp urn_to_identifier(urn) do
    msisdn = String.replace(extract_number_from_urn(urn), "+", "")
    msisdn <> "^^^ZAF^TEL"
  end

  defp openhim_optout_from_contact(contact) do
    %{
      "urns" => [nurse_urn | _],
      "fields" => %{
        "opt_out_date" => opt_out_date,
        "registered_by" => device_msisdn,
        "facility_code" => facility_code
      }
    } = contact

    %{
      mha: @mha_praekelt,
      swt: @swt_sms,
      type: @type_nurse_optout,
      cmsisdn: extract_number_from_urn(nurse_urn),
      dmsisdn: device_msisdn,
      faccode: facility_code,
      id: urn_to_identifier(nurse_urn),
      optoutreason: @reason_unknown,
      encdate:
        Timex.format!(Timex.parse!(opt_out_date, "{ISO:Extended}"), "{YYYY}{0M}{0D}{h24}{m}{s}")
    }
  end

  def run(id) do
    optout = get_opt_out!(id)

    contact = Rapidpro.get_contact(optout.contact_id)
    _ = OpenHIM.create_nurseconnect_optout(openhim_optout_from_contact(contact))

    set_optout_status(id, :complete)
  end
end

defmodule Companion.Jobs.ProcessOptOut.Failure do
  @moduledoc """
  Handles failures from the process opt out task. Sets the status of the opt out to error
  """
  import Companion.CompanionWeb
  alias Honeydew.Job

  @behaviour Honeydew.FailureMode

  def validate_args!([]), do: :ok

  def validate_args!(args),
    do:
      raise(
        ArgumentError,
        "You provided arguments (#{inspect(args)}) to the Process Optout failure mode, it only accepts an empty list"
      )

  def handle_failure(%Job{task: {:run, [id]}} = _job, _reason, _args) do
    set_optout_status(id, :error)
  end
end
