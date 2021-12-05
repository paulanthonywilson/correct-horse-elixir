import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  [secret_key_base, live_view_salt, admin_user, admin_password, host] =
    Enum.map(
      ["SECRET_KEY_BASE", "LIVE_VIEW_SALT", "ADMIN_USER", "ADMIN_PASSWORD", "HOST"],
      fn key ->
        System.get_env(key) ||
          raise """
          environment variable #{key} is missing.
          You can generate one by calling: mix phx.gen.secret
          """
      end
    )

  app_name = System.get_env("FLY_APP_NAME") || raise "FLY_APP_NAME not available"

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  config :correcthorse_web, CorrecthorseWeb.Endpoint,
    # url: [host: host, scheme: "https", port: 443],
    url: [host: host, port: 80],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base,
    live_view: [signing_salt: live_view_salt],
    admin_password: admin_password,
    admin_user: admin_user,
    server: true

  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :correcthorse, Correcthorse.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
