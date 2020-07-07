use Mix.Config

[secret_key_base, live_view_salt, admin_user, admin_password] =
  Enum.map(["SECRET_KEY_BASE", "LIVE_VIEW_SALT", "ADMIN_USER", "ADMIN_PASSWORD"], fn key ->
    System.get_env(key) ||
      raise """
      environment variable #{key} is missing.
      You can generate one by calling: mix phx.gen.secret
      """
  end)

config :correcthorse_web, CorrecthorseWeb.Endpoint,
  url: [host: "correcthorsebatterystaple.com", scheme: "https"],
  http: [port: 4001],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: secret_key_base,
  live_view: [signing_salt: live_view_salt],
  admin_password: admin_password,
  admin_user: admin_user,
  server: true,
  check_origin: [
    "https://*.correcthorsebatterystaple.com"
  ]

# import_config "prod.secret.exs"
