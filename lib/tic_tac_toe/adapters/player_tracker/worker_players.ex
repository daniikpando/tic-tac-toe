defmodule TicTacToe.Adapters.PlayerTracker.WorkerPlayers do
  alias TicTacToe.Adapters.PlayerTracker.Spec
  alias TicTacToe.Workers.Player.UnmatchedPlayers

  @behaviour TicTacToe.Adapters.PlayerTracker.Spec

  @spec get_all() :: Spec.players()
  def get_all do
    GenServer.call(UnmatchedPlayers, :get)
  end

  @spec delete(Spec.player_pid(), Spec.player_id()) :: :ok
  def delete(_pid, player_id) do
    GenServer.call(UnmatchedPlayers, {:delete, player_id})
  end

  @spec get(Spec.player_id()) :: Spec.player_data()
  def get(player_id) do
    state = get_all()

    Map.get(state, player_id)
  end

  @spec subscribe(Spec.player_id(), Spec.player_data()) :: :ok
  def subscribe(player_id, %{nickname: _, pid: _} = data) do
    GenServer.cast(UnmatchedPlayers, {:join, {player_id, data}})
  end
end
