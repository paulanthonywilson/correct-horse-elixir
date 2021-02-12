defmodule CorrecthorseWeb.AppendCheckboxComponent do
  @moduledoc """
  The checkbox for appending characters
  """
  use CorrecthorseWeb, :live_component

  def render(assigns) do
    ~L"""
    <input type="checkbox"
    id="append<%= @append %>"
    value = "<%= @append %>"
    name= "append[]"
    <%= if @checked, do: "checked" %>
    />
    <label for="append<%= @append %>"><%= @append %></label>
    """
  end
end
