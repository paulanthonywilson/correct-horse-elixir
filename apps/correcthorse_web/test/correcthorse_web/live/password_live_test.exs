defmodule CorrecthorseWeb.PasswordLiveTest do
  use CorrecthorseWeb.ConnCase

  import Phoenix.LiveViewTest

  setup do
    StubWords.start(["danny", "sunshine", "little", "matey", "hello"])
    :ok
  end

  test "passwords", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, "generate-password", %{}) =~ "hello-matey"
  end
end
