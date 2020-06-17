defmodule Correcthorse.Debounce.Debouncer do
  @moduledoc """
  Debounce when receiving lots of messages from LiveView range updates.

  Not done with `phx-debounce` as we want to update the visual feedback
  on the number more smoothly
  """

  use GenServer

  defstruct receiver: nil, timeout: 0, last_message: nil

  @type t :: %__MODULE__{
          receiver: pid,
          timeout: timeout(),
          last_message: any()
        }

  @doc """
  Pass in the pid that receives events
  """
  @spec start_link(pid(), timeout()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(events_receiver, timeout) do
    GenServer.start_link(__MODULE__, {events_receiver, timeout})
  end

  def init({receiver, timeout}) do
    {:ok, %__MODULE__{receiver: receiver, timeout: timeout}}
  end

  @doc """
  Message that will rebound, if no other received in timeout.

  Message can not be `:timeout` because that is reserved for the actual timeout
  """
  @spec bounce(pid(), any()) :: any()
  def bounce(pid, message) when message != :timeout do
    send(pid, message)
  end

  @doc """
  Not received another message since timeout, so sent to receiver and reset
  """
  def handle_info(:timeout, s = %{receiver: receiver, last_message: last_message}) do
    send(receiver, last_message)
    {:noreply, %{s | last_message: nil}}
  end

  @doc """
  Receives message
  """
  def handle_info(message, s = %{timeout: timeout}) do
    {:noreply, %{s | last_message: message}, timeout}
  end
end
