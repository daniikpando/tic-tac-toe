defmodule TicTacToe.Adapters.PlayerTracker.WorkerPlayers do
  alias TicTacToe.Workers.UnmatchedPlayers

  @behaviour TicTacToe.Adapters.PlayerTracker.Spec

  def get_all do
    GenServer.call(UnmatchedPlayers, :get)
  end

  def delete(_pid, session_id) do
    GenServer.call(UnmatchedPlayers, {:delete, session_id})
  end

  def get(session_id) do
    state = get_all()

    Map.get(state, session_id)
  end

  def subscribe(session_id, %{nickname: _, pid: _} = data) do
    GenServer.cast(UnmatchedPlayers, {:join, {session_id, data}})
  end
end
