# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :companion,
  ecto_repos: [Companion.Repo]

# Configures the endpoint
config :companion, CompanionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bgoJnmzD5D2uoa7L/vkKykeAV24Tcujdhf8m6HegWiPxidtUJpXpJ4jnlqcqPCwC",
  render_errors: [view: CompanionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Companion.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
