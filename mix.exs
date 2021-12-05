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
      {:credo, "~> 1.6", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"]
    ]
  end

  defp releases do
    [
      correcthorse_main: [
        version: version(),
        applications: [correcthorse: :permanent, correcthorse_web: :permanent],
        include_executables_for: [:unix]
      ]
    ]
  end

  defp version do
    file_first_line("#{__DIR__}/VERSION")
  end

  defp file_first_line(file_path) do
    file_path
    |> File.read!()
    |> String.split()
    |> hd()
  end
end
