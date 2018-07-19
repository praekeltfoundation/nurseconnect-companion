defmodule Companion.Application do
  @moduledoc false
  use Application
  alias Companion.Jobs

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Companion.Repo, []),
      # Start the endpoint when the application starts
      supervisor(CompanionWeb.Endpoint, []),
      # Jobs
      {Honeydew.EctoPollQueue, Jobs.ProcessOptOut.supervisor_config()},
      {Honeydew.Workers, [:process_opt_out, Jobs.ProcessOptOut]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Companion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CompanionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
