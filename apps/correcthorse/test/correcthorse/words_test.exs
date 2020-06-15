defmodule Correcthorse.WordsTest do
  use ExUnit.Case
  alias Correcthorse.Words
  alias Correcthorse.Words.WordList

  test "common words loaded" do
    assert WordList.size(:common_words) == 4981
  end

  test "random word" do
    Enum.each((1..1_000), fn _ ->
      assert Words.random_word() =~ ~r/^[a-z]+$/
    end)
  end
end
