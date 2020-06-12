defmodule CorrecthorseWeb.ReverseLiveTest do
  use CorrecthorseWeb.ConnCase

  import Phoenix.LiveViewTest

  test "reverses", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_change(view, :changed, %{input: "yetam olleH"}) =~ "Hello matey"

  end
end
