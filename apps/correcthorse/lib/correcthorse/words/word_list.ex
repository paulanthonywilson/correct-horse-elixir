defmodule Correcthorse.Words.WordList do
  @moduledoc """
  Represents a word list, providing fast concurrent lookups by index.

  ETS tables under the hood, naturally.
  """

  use GenServer

  @type word_list_ref :: atom()

  @spec start_link({word_list_ref(), Stream.t() | Enum.t()}) :: {:error, any} | {:ok, pid}
  def start_link(opts = {_reference, _words}) do
    GenServer.start_link(__MODULE__, opts)
  end

  @spec size(word_list_ref()) :: pos_integer()
  def size(reference) do
    :ets.info(reference, :size)
  end

  @spec word_at(word_list_ref(), pos_integer()) :: {:error, :invalid_index} | {:ok, String.t()}
  def word_at(reference, index) do
    case :ets.lookup(reference, index) do
      [{^index, word}] -> {:ok, word}
      _ -> {:error, :invalid_index}
    end
  end

  @spec random_word(word_list_ref()) :: String.t()
  def random_word(reference) do
    size = size(reference)
    index = :rand.uniform(size) - 1
    {:ok, word} = word_at(reference, index)
    word
  end

  def init({reference, words}) do
    table = :ets.new(reference, [:named_table, :set, read_concurrency: true])
    {:ok, {table, words}, {:continue, :add_words}}
  end

  def handle_continue(:add_words, {table, words}) do
    words
    |> Stream.with_index()
    |> Enum.each(fn {w, i} -> :ets.insert(table, {i, w}) end)

    {:noreply, {}}
  end
end
