defmodule Correcthorse.PasswordTest do
  use ExUnit.Case

  alias Correcthorse.Password


  setup do
    Agent.start_link(fn -> [] end, name: StubWords.agent_name())
    StubWords.set_wordlist(["oh", "me", "extra"])
    :ok
  end


  test "minimum words when mimimum size is met" do
    assert Password.words(2, 3) == ["me", "oh"]
  end


  test "extra words when mimimum size is not met" do
    assert Password.words(2, 6) == ["extra", "me", "oh"]
  end

  test "minimum word size assumes a single separator character will be added between words" do
    assert Password.words(2, 5) == ["me", "oh"]
  end

  test "minimum word size edgecase for minimum length of 1" do
    assert Password.words(1, 2) == ["oh"]
    assert Password.words(1, 3) == ["extra", "me"]
  end

  test "minimum word size edgecase for minimum length > 2" do
    StubWords.set_wordlist(["oh", "me", "my", "extra"])
    assert Password.words(3, 9) == ["extra", "my", "me", "oh"]
  end

  # test "wrong" do
  #   StubWords.set_wordlist(["gray", "phenomenon", "boy", "respect", "extra"])
  #   assert Password.words(4, 28) == ["extra", "respect", "boy", "phenomenon", "gray"]
  # end
end
