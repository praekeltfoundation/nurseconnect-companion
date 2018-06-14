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
  pubsub: [name: Companion.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Config Google OAuth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [hd: System.get_env("GOOGLE_DOMAIN")]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Config pagination
config :kerosene,
  theme: :bootstrap4

# Config swagger
config :companion, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: CompanionWeb.Router,
      endpoint: CompanionWeb.Endpoint
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
