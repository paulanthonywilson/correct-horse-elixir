defmodule Correcthorse.Words.WordsImpl do
  @moduledoc """
  Gets random words from the wordlist
  """

  @behaviour Correcthorse.Words

  alias Correcthorse.Words.WordList


  @spec random_word :: String.t
  def random_word() do
    WordList.random_word(:common_words)
  end
end
