use Mix.Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :correcthorse_web, CorrecthorseWeb.Endpoint,
  url: [host: "beta.correcthorsebatterystaple.com", port: 443, scheme: "https"],
  http: [port: 4001],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: secret_key_base,
  server: true

# import_config "prod.secret.exs"
