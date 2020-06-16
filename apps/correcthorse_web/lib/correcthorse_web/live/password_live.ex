defmodule CorrecthorseWeb.PasswordLive do
  @moduledoc false

  use CorrecthorseWeb, :live_view
  alias Correcthorse.Password

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       wordlist: []
     )}
  end


  def handle_event("generate-password", _, socket) do
    wordlist = Password.words(4, 26)
    {:noreply, assign(socket, wordlist: wordlist)}
  end


  defp generated_password(wordlist) do
    Enum.join(wordlist, "-")
  end
end
