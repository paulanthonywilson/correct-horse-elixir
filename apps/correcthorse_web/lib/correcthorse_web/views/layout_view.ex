defmodule CorrecthorseWeb.LayoutView do
  use CorrecthorseWeb, :view

  @liveview_nav :dev == Mix.env()

  def liveview_nav?, do: @liveview_nav
end
