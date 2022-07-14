defmodule TicTacToe.Workers.UnmatchedPlayers do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:delete, session_id}, _from, state) do
    new_state = Map.delete(state, session_id)

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:join, {session_id, data}}, state) do
    {:noreply, Map.put(state, session_id, data)}
  end
end
