defmodule CorrecthorseWeb.PasswordLive do
  @moduledoc false

  use CorrecthorseWeb, :live_view
  alias Correcthorse.Password

  @default_min_words 4
  @min_min_words 2
  @max_min_words 50

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        min_words: @default_min_words,
        min_chars: min_chars_from_min_words(@default_min_words),
        separator: "-",
        capitalise: :none,
        append_digit: false,
        password: ""
      )

    if connected?(socket) do
      {:ok, assign_new_password(socket)}
    else
      {:ok, assign_password(socket, [])}
    end
  end

  def handle_event("generate-password", _, socket) do
    {:noreply, assign_new_password(socket)}
  end

  def handle_event(
        "password-generation-details-changed",
        %{"min-words" => min_words, "min-chars" => min_chars, "_target" => target},
        socket
      ) do
    min_words = String.to_integer(min_words)

    min_chars =
      case target do
        ["min-words"] -> min_chars_from_min_words(min_words)
        _ -> String.to_integer(min_chars)
      end

    socket = assign(socket, min_words: min_words, min_chars: min_chars)
    {:noreply, assign_new_password(socket)}
  end

  def handle_event("password-decoration-details-changed", _, socket) do
    {:noreply, socket}
  end

  defp generated_password(wordlist) do
    Enum.join(wordlist, "-")
  end

  defp assign_new_password(socket) do
    %{min_words: min_words, min_chars: min_chars} = socket.assigns

    assign_password(
      socket,
      Password.words(min_words, min_chars)
    )
  end

  defp assign_password(socket, wordlist) do
    assign(socket, wordlist: wordlist, password: generated_password(wordlist), show_copied: false)
  end

  defp separators do
    [{"", "none"}, {"-", "dash"}, {"1", "1"}, {" ", "space"}]
  end

  defp capitalisations do
    [{:none, "None"}, {:first, "First char"}, {:each_word, "Each word"}]
  end

  defp radio_selection(assigns \\ {}, name, current_value, values) do
    ~L"""
    <%= for {value, id} <- values do %>
    <input type="radio" id="<%=id %>" name="<%= name%>" value="<%= value %>"
        <%= if current_value == value, do: "checked" %>
    />
    <label for="%<=name %>"><%= id %></label>
    <% end %>
    """
  end

  defp min_chars_from_min_words(min_words), do: min_words * 7

  defp max_min_words, do: @max_min_words
  defp min_min_words, do: @min_min_words

  defp min_min_chars, do: min_chars_from_min_words(min_min_words())
  defp max_min_chars, do: min_chars_from_min_words(max_min_words())
end
