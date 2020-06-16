defmodule Correcthorse.Password do
  @words (case Mix.env() do
            :test -> StubWords
            _ -> Correcthorse.Words.WordsImpl
          end)
  def words(minimum_words, minimum_length) do
    do_words([], 0, {minimum_words, minimum_length})
  end

  defp do_words(wordlist, size, {minimum_words, minimum_length})
       when length(wordlist) >= minimum_words and size >= minimum_length do
    wordlist
  end

  defp do_words(wordlist, size, constraints) do
    new_wordlist = [@words.random_word() | wordlist]
    new_size = calculate_size(size, new_wordlist)
    do_words(new_wordlist, new_size, constraints)
  end

  defp calculate_size(0, [new_word | []]), do: String.length(new_word)

  defp calculate_size(previous_size, [new_word | _]) do
    previous_size + String.length(new_word) + 1
  end
end
