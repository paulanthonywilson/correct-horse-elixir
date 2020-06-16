defmodule StubWords do
  @behaviour Correcthorse.Words
  @agent_name __MODULE__

  def agent_name, do: @agent_name

  def random_word do
    Agent.get_and_update(agent_name(), fn [h | t] -> {h, t} end)
  end

  def set_wordlist(words) do
    Agent.update(agent_name(), fn _ -> words end)
  end
end
