defmodule StubWords do
  @moduledoc """
  Stubs out `Correcthorse.Words` for testing. Sets a list of words that will be returned,
  in order.
  """

  @behaviour Correcthorse.Words
  @agent_name __MODULE__

  def agent_name, do: @agent_name

  def start(wordlist \\ []) do
    Agent.start_link(fn -> [] end, name: StubWords.agent_name())
    StubWords.set_wordlist(wordlist)
  end

  def random_word do
    Agent.get_and_update(agent_name(), fn [h | t] -> {h, t} end)
  end

  def set_wordlist(words) do
    Agent.update(agent_name(), fn _ -> words end)
  end
end
