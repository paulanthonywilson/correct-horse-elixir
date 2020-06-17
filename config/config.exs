# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

config :correcthorse_web,
  generators: [context_app: :correcthorse]

# Configures the endpoint
config :correcthorse_web, CorrecthorseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DeTB7k6raPEaQ/Jmntl4x9dVp8tPOE+g3FCCz1YEo+Nm1LAMHroWeWAAcf10AlUD",
  render_errors: [view: CorrecthorseWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Correcthorse.PubSub,
  live_view: [signing_salt: "wVaMq5f5"],
  admin_user: "bob",
  admin_password: "password"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
