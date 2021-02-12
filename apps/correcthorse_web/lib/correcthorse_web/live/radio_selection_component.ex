defmodule CorrecthorseWeb.RadioSelectionComponent do
  @moduledoc """
  Checkboxes for radio selection buttons

  Pass in

  * `values`: the possible values
  * `name`: the checkbox name
  * `current_value`: the currently checked value
  """
  use CorrecthorseWeb, :live_component

  def render(assigns) do
    ~L"""
    <%= for {value, id} <- @values do %>
    <input type="radio" id="<%= id %>" name="<%= @name%>" value="<%= value %>"
        <%= if @current_value == value, do: "checked" %>
    />
    <label for="%<=name %>"><%= id %></label>
    <% end %>
    """
  end
end
