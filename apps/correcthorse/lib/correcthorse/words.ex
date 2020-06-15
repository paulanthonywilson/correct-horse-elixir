defmodule Correcthorse.Words do
  @moduledoc """
  Gets random words from the wordlist
  """

  alias Correcthorse.Words.WordList

  def random_word() do
    WordList.random_word(:common_words)
  end
end
