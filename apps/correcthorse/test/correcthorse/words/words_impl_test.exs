defmodule Correcthorse.WordsImplTest do
  use ExUnit.Case
  alias Correcthorse.Words.{WordList, WordsImpl}

  test "common words loaded" do
    assert WordList.size(:common_words) == 4981
  end

  test "random word" do
    Enum.each((1..1_000), fn _ ->
      assert WordsImpl.random_word() =~ ~r/^[a-z]+$/
    end)
  end
end
