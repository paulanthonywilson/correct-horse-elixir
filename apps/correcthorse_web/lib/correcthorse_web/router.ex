defmodule CorrecthorseWeb.Router do
  use CorrecthorseWeb, :router

  alias Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CorrecthorseWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CorrecthorseWeb do
    pipe_through :browser

    live "/", PasswordLive
  end

  pipeline :admins_only do
    plug :b_auth
  end

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", metrics: CorrecthorseWeb.Telemetry
  end

  defp b_auth(conn, _opts) do
    config = Application.fetch_env!(:correcthorse_web, CorrecthorseWeb.Endpoint)

    BasicAuth.basic_auth(conn,
      username: Keyword.fetch!(config, :admin_user),
      password: Keyword.fetch!(config, :admin_password)
    )
  end
end
