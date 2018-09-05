# Start the repo and endpoint required for tests
import Supervisor.Spec

children = [
  supervisor(Companion.Repo, []),
  supervisor(CompanionWeb.Endpoint, [])
]

opts = [strategy: :one_for_one, name: Companion.Supervisor]
Supervisor.start_link(children, opts)
# Ensure that the application has started
Application.ensure_all_started(:companion)
Application.ensure_all_started(:timex)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Companion.Repo, :manual)
