defmodule Correcthorse.PasswordTest do
  use ExUnit.Case

  alias Correcthorse.Password

  describe "words" do
    setup do
      StubWords.start(["oh", "me", "extra"])
      :ok
    end

    test "minimum words when mimimum length is met" do
      assert Password.words(2, 3) == ["me", "oh"]
    end

    test "extra word is added when mimimum length is not met" do
      assert Password.words(2, 5) == ["extra", "me", "oh"]
    end

    test "no more than the 50 minimum words" do
      StubWords.set_wordlist(Enum.map(0..500, &String.Chars.to_string/1))
      assert length(Password.words(500, 1)) == 50
    end

    test "no more than the 250 minimum characters" do
      StubWords.set_wordlist(Enum.map(0..500, fn i -> "#{Integer.mod(i, 10)}" end))
      wordlist = Password.words(2, 500)
      character_length = Enum.reduce(wordlist, 0, fn w, acc -> acc + String.length(w) end)
      assert 250 == character_length
    end
  end

  describe "words_to_password" do
    test "joins with the separator" do
      assert Password.to_password(["hello", "there"], "-", []) == "hello-there"
      assert Password.to_password(["hello", "there"], "*", []) == "hello*there"
    end

    test "appends" do
      assert Password.to_password(["hello", "there"], "-", append: ["!", "?"]) == "hello-there!?"
    end

    test "capitalise first word" do
      assert Password.to_password(["hello", "there"], "-", capitalise: :first) == "Hello-there"
    end

    test "capitalise all words" do
      assert Password.to_password(["hello", "there"], "-", capitalise: :each_word) ==
               "Hello-There"
    end
  end

end
