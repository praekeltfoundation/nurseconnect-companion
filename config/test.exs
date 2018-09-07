use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :companion, CompanionWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :companion, Companion.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "companion_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [hd: "example.org"]}
  ]

# Use Tesla mock adapter
config :tesla, adapter: Tesla.Mock
config :tesla, Tesla.Mock, json_engine: Poison

# Rapidpro config
config :companion, :rapidpro,
  url: "http://rapidpro",
  token: "rapidprotoken"

# Jembi config
config :companion, :openhim,
  url: "http://openhim",
  username: "user",
  password: "pass"

# Whatsapp config
config :companion, :whatsapp,
  url: "https://whatsapp",
  username: "user",
  password: "pass",
  hsm_namespace: "hsm_namespace",
  hsm_element_name: "hsm_element_name"
