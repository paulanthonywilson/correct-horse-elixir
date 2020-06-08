defmodule Correcthorse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Correcthorse.PubSub}
      # Start a worker by calling: Correcthorse.Worker.start_link(arg)
      # {Correcthorse.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Correcthorse.Supervisor)
  end
end
