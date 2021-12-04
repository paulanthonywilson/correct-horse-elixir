import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :correcthorse_web, CorrecthorseWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "H1zJF2tmBZe+eYax4sFPfMs43VIpQli6i6xubd5dZigj9beJbvx23PlYI86E4RC4",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :correcthorse, Correcthorse.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
