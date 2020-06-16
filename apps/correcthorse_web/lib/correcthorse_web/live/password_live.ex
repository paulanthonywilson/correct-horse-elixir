defmodule CorrecthorseWeb.PasswordLive do
  @moduledoc false

  use CorrecthorseWeb, :live_view
  alias Correcthorse.Password

  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, assign_new_password(socket)}
    else
      {:ok, assign_password(socket, [])}
    end
  end

  def handle_event("generate-password", _, socket) do
    {:noreply, assign_new_password(socket)}
  end

  defp generated_password(wordlist) do
    Enum.join(wordlist, "-")
  end

  defp assign_new_password(socket) do
    assign_password(socket, Password.words(4, 26))
  end

  defp assign_password(socket, wordlist) do
    assign(socket, wordlist: wordlist, show_copied: false)
  end
end
