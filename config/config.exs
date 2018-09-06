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

# Task / Honeydew config
config :honeydew,
  timeout: String.to_integer(System.get_env("TASK_TIMEOUT") || "300"),
  retries: String.to_integer(System.get_env("TASK_RETRIES") || "10")

# Rapidpro config
config :companion, :rapidpro,
  url: System.get_env("RAPIDPRO_URL") || "http://rapidpro",
  token: System.get_env("RAPIDPRO_TOKEN") || "rapidprotoken"

# Jembi config
config :companion, :openhim,
  url: System.get_env("OPENHIM_URL") || "http://openhim",
  username: System.get_env("OPENHIM_USERNAME") || "user",
  password: System.get_env("OPENHIM_PASSWORD") || "pass"

# Whatsapp config
config :companion, :whatsapp,
  url: System.get_env("WHATSAPP_URL") || "https://whatsapp",
  username: System.get_env("WHATSAPP_USERNAME") || "user",
  password: System.get_env("WHATSAPP_PASSWORD") || "pass",
  hsm_namespace: System.get_env("WHATSAPP_HSM_NAMESPACE") || "hsm_namespace",
  hsm_element_name: System.get_env("WHATSAPP_HSM_ELEMENT_NAME") || "hsm_element_name"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
