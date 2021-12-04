import Config

config :correcthorse_web,
  generators: [context_app: :correcthorse]

# Configures the endpoint
config :correcthorse_web, CorrecthorseWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CorrecthorseWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Correcthorse.PubSub,
  admin_user: "bob",
  admin_password: "password",
  live_view: [signing_salt: "1iAK2ksh"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/correcthorse_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
