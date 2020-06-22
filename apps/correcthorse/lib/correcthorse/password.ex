defmodule Correcthorse.Password do
  @moduledoc """
  Generates lists of random words with `words/2` that can be used to make
  a password with `to_password/3`.
  """

  @max_minimum_words 50

  @words (case Mix.env() do
            :test -> StubWords
            _ -> Correcthorse.Words.WordsImpl
          end)

  @doc """
  List of (random) words that can be used to make a password with `to_password/3`
  """
  @spec words(pos_integer(), pos_integer()) :: list(String.t())
  def words(minimum_words, minimum_chars) do
    do_words([], 0, restrict_minimum_sizes(minimum_words, minimum_chars))
  end

  defp restrict_minimum_sizes(minimum_words, minimum_chars) do
    {min(max_minimum_words(), minimum_words), min(max_minimum_chars(), minimum_chars)}
  end

  @spec max_minimum_words :: 50
  def max_minimum_words, do: @max_minimum_words

  @spec max_minimum_chars :: 250
  def max_minimum_chars, do: min_chars_from_min_words(max_minimum_words())

  @spec min_chars_from_min_words(pos_integer()) :: pos_integer()
  def min_chars_from_min_words(min_words), do: min_words * 5

  @doc """
  Turn a list of words into a password.pos_integer()
  * wordlist - the list of words
  * separator - string used to separate the words
  * options. Keyword list of options, which may incliude:
    * `captalise: :each_word` - capitalise every word
    * `capitalise: first` - capitalise the first word
    * `append: append` - add `String.Chars.to_string(append)` to the end of the password
  """
  @spec to_password(list(String.t()), String.t(), list({atom, any})) :: String.t()
  def to_password(wordlist, separator, options) do
    wordlist
    |> decorate(options)
    |> Enum.join(separator)
  end

  defp decorate(wordlist, []), do: wordlist

  defp decorate(wordlist, [{:capitalise, :each_word} | rest]) do
    wordlist
    |> Enum.map(&String.capitalize/1)
    |> decorate(rest)
  end

  defp decorate(wordlist, [{:capitalise, :first} | rest]) do
    wordlist
    |> List.update_at(0, &String.capitalize/1)
    |> decorate(rest)
  end

  defp decorate(wordlist, [{:append, append} | rest]) do
    wordlist
    |> List.update_at(-1, fn word -> "#{word}#{append}" end)
    |> decorate(rest)
  end

  defp decorate(wordlist, [_ | rest]), do: decorate(wordlist, rest)

  defp do_words(wordlist, char_count, {minimum_words, minimum_chars})
       when length(wordlist) >= minimum_words and char_count >= minimum_chars do
    wordlist
  end

  defp do_words(wordlist, char_count, constraints) do
    new_wordlist = [@words.random_word() | wordlist]
    new_char_count = calculate_size(char_count, new_wordlist)
    do_words(new_wordlist, new_char_count, constraints)
  end

  defp calculate_size(previous_char_count, [new_word | _]) do
    previous_char_count + String.length(new_word)
  end
end
