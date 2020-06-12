defmodule CorrecthorseWeb.ReverseLive do
  @moduledoc """
  Live view to show something working. Reversed input. Rendered
  in tempalte file `reverse_live.html.ieex`
  """
  use CorrecthorseWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, input: "", output: "")
    {:ok, socket}
  end

  def handle_event("changed", %{"input" => input}, socket) do
    output = String.reverse(input)

    {:noreply, assign(socket, input: input, output: output)}
  end
end
