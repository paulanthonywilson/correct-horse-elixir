defmodule Correcthorse.PasswordTest do
  use ExUnit.Case

  alias Correcthorse.Password


  setup do
    Agent.start_link(fn -> [] end, name: StubWords.agent_name())
    StubWords.set_wordlist(["oh", "me", "extra"])
    :ok
  end


  test "minimum words when mimimum length is met" do
    assert Password.words(2, 3) == ["me", "oh"]
  end


  test "extra word is added when mimimum length is not met" do
    assert Password.words(2, 5) == ["extra", "me", "oh"]
  end
end
