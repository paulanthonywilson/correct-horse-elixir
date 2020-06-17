defmodule Correcthorse.Debounce.DebouncerTest do
  use ExUnit.Case
  alias Correcthorse.Debounce.Debouncer

  test "debounce sends the last message, when received within timestamp" do
    {:ok, pid} = Debouncer.start_link(self(), 10)

    Debouncer.bounce(pid, :first)
    Debouncer.bounce(pid, :second)
    Debouncer.bounce(pid, :third)
    Debouncer.bounce(pid, :last)

    assert_receive :last
    refute_receive _
  end

  test "not a one-shot" do
    {:ok, pid} = Debouncer.start_link(self(), 10)
    Debouncer.bounce(pid, :first)
    assert_receive :first

    Debouncer.bounce(pid, :second)
    assert_receive :second

    refute_receive _
  end
end
