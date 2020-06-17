defmodule CorrecthorseWeb.PasswordLive do
  @moduledoc false

  use CorrecthorseWeb, :live_view

  alias Correcthorse.Password
  alias Correcthorse.Debounce.Debouncer

  @default_min_words 4
  @min_min_words 2
  @max_min_words 50

  def mount(_params, _session, socket) do
    {:ok, debouncer} = Debouncer.start_link(self(), 500)

    socket =
      assign(socket,
        min_words: @default_min_words,
        min_chars: min_chars_from_min_words(@default_min_words),
        separator: "-",
        capitalise: :none,
        append: [],
        password: "",
        wordlist: [],
        _debouncer: debouncer
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

  def handle_event("password-generation-details-changed", params, socket) do
    %{_debouncer: debouncer} = socket.assigns
    Debouncer.bounce(debouncer, :generate_new_password)
    {min_words, min_chars} = extract_min_words_chars(params)
    {:noreply, assign(socket, min_words: min_words, min_chars: min_chars)}
  end

  def handle_event(
        "password-decoration-details-changed",
        %{
          "separator" => separator,
          "capitalise" => capitalise,
          "append" => append
        },
        socket
      ) do
    capitalise = String.to_existing_atom(capitalise)
    %{wordlist: wordlist} = socket.assigns
    password = generated_password(wordlist, separator, append, capitalise)

    {:noreply,
     assign(socket,
       separator: separator,
       capitalise: capitalise,
       append: append,
       password: password
     )}
  end

  def handle_info(:generate_new_password, socket) do
    {:noreply, assign_new_password(socket)}
  end

  defp extract_min_words_chars(%{
         "min-words" => min_words,
         "min-chars" => min_chars,
         "_target" => target
       }) do
    min_words = String.to_integer(min_words)

    min_chars =
      case target do
        ["min-words"] -> min_chars_from_min_words(min_words)
        _ -> String.to_integer(min_chars)
      end

    {min_words, min_chars}
  end

  defp generated_password(wordlist, socket) do
    %{separator: separator, append: append, capitalise: capitalise} = socket.assigns
    generated_password(wordlist, separator, append, capitalise)
  end

  defp generated_password(wordlist, separator, append, capitalise) do
    Password.to_password(wordlist, separator, append: append, capitalise: capitalise)
  end

  defp assign_new_password(socket) do
    %{min_words: min_words, min_chars: min_chars} = socket.assigns

    assign_password(
      socket,
      Password.words(min_words, min_chars)
    )
  end

  defp assign_password(socket, wordlist) do
    assign(socket,
      wordlist: wordlist,
      password: generated_password(wordlist, socket),
      show_copied: false
    )
  end

  defp separators do
    [{"", "none"}, {"-", "dash"}, {"1", "1"}, {" ", "space"}]
  end

  defp capitalisations do
    [{:none, "None"}, {:first, "First word"}, {:each_word, "Each word"}]
  end

  defp radio_selection(name, current_value, values) do
    assigns = %{}

    ~L"""
    <%= for {value, id} <- values do %>
    <input type="radio" id="<%=id %>" name="<%= name%>" value="<%= value %>"
        <%= if current_value == value, do: "checked" %>
    />
    <label for="%<=name %>"><%= id %></label>
    <% end %>
    """
  end

  defp append_checkbox(append, checked) do
    assigns = %{}

    ~L"""
    <input type="checkbox"
    id="append<%= append %>"
    value = "<%= append %>"
    name= "append[]"
    <%= if checked, do: "checked" %>
    />
    <label for="append<%= append %>"><%= append %></label>
    """
  end

  defp min_chars_from_min_words(min_words), do: min_words * 5

  defp max_min_words, do: @max_min_words
  defp min_min_words, do: @min_min_words

  defp min_min_chars, do: min_chars_from_min_words(min_min_words())
  defp max_min_chars, do: min_chars_from_min_words(max_min_words())
end
