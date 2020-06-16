defmodule Correcthorse.Words do
  @moduledoc """
  Behaviour for returning a word at random
  """

  @callback random_word :: String.t
end
