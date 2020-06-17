defmodule CorrecthorseWeb.Router do
  use CorrecthorseWeb, :router

  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

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

    live "/reverse", ReverseLive
    live "/", PasswordLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CorrecthorseWeb do
  #   pipe_through :api
  # end

  # LiveDashboard with basic auth

  pipeline :admins_only do
    plug :basic_auth,
      username: Application.get_env(:correcthorse_web, CorrecthorseWeb.Endpoint)[:admin_user],
      password: Application.get_env(:correcthorse_web, CorrecthorseWeb.Endpoint)[:admin_password]
  end

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", metrics: CorrecthorseWeb.Telemetry
  end
end
