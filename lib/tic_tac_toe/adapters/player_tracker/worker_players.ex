defmodule TicTacToe.Adapters.PlayerTracker.WorkerPlayers do
  alias TicTacToe.Workers.UnmatchedPlayers

  @behaviour TicTacToe.Adapters.PlayerTracker.Spec

  def get_all do
    GenServer.call(UnmatchedPlayers, :get)
  end

  def delete(_pid, player_id) do
    GenServer.call(UnmatchedPlayers, {:delete, player_id})
  end

  def get(player_id) do
    state = get_all()

    Map.get(state, player_id)
  end

  def subscribe(player_id, %{nickname: _, pid: _} = data) do
    GenServer.cast(UnmatchedPlayers, {:join, {player_id, data}})
  end
end
