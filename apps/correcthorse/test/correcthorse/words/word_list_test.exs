defmodule Correcthorse.Words.WordListText do
  use ExUnit.Case

  alias Correcthorse.Words.WordList

  setup do
    {:ok, pid} = WordList.start_link({reference(), ["hello\n", "matey", "boy"]})

    # make sure handle_continue is called
    :sys.get_status(pid)
    :ok
  end


  test "size" do
    assert WordList.size(reference()) == 3
  end

  test "word_at" do
    assert WordList.word_at(reference(), 0) == {:ok, "hello"}
    assert WordList.word_at(reference(), 1) == {:ok, "matey"}
    assert WordList.word_at(reference(), 2) == {:ok, "boy"}
    assert WordList.word_at(reference(), 3) == {:error, :invalid_index}
  end

  test "random word" do
    assert WordList.random_word(reference()) in ["hello", "matey", "boy"]
  end

  defp reference do
    self()
    |> inspect()
    |> String.to_atom()
  end
end
