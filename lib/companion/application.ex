defmodule Companion.Application do
  @moduledoc false
  use Application
  alias Companion.Jobs

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Metrics
    CompanionWeb.PhoenixInstrumenter.setup()
    CompanionWeb.PipelineInstrumenter.setup()
    CompanionWeb.RepoInstrumenter.setup()
    CompanionWeb.MetricsPlugExporter.setup()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Companion.Repo, []),
      # Start the endpoint when the application starts
      supervisor(CompanionWeb.Endpoint, []),
      # Jobs
      {Honeydew.EctoPollQueue, Jobs.ProcessOptOut.supervisor_config()},
      {Honeydew.Workers, [:process_opt_out, Jobs.ProcessOptOut]},
      {Honeydew.EctoPollQueue, Jobs.SendTemplateMessage.supervisor_config()},
      {Honeydew.Workers, [:send_template_message, Jobs.SendTemplateMessage]},
      {Honeydew.EctoPollQueue, Jobs.ProcessRegistration.supervisor_config()},
      {Honeydew.Workers, [:process_registration, Jobs.ProcessRegistration]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Companion.Supervisor]

    :ok = :error_logger.add_report_handler(Sentry.Logger)

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CompanionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
