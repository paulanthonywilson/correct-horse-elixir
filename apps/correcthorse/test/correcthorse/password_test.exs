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
