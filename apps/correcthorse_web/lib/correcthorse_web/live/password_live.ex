defmodule CorrecthorseWeb.PasswordLive do
  @moduledoc false

  use CorrecthorseWeb, :live_view
  alias Correcthorse.Password

  def mount(_params, _session, socket) do
    {:ok, assign_new_password(socket)}
  end


  def handle_event("generate-password", _, socket) do
    {:noreply, assign_new_password(socket)}
  end


  defp generated_password(wordlist) do
    Enum.join(wordlist, "-")
  end

  defp assign_new_password(socket) do
    assign(socket, wordlist: Password.words(4,26), show_copied: false)
  end
end
