defmodule Correcthorse.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: version(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["cmd mix setup"]
    ]
  end

  defp releases do
    [
      correcthorse_main: [
        version: version(),
        applications: [correcthorse: :permanent, correcthorse_web: :permanent]
      ]
    ]
  end

  defp version do
    "#{__DIR__}/VERSION"
    |> File.read!()
    |> String.split()
    |> hd()
  end
end
