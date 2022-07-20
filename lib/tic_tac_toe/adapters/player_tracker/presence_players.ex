defmodule TicTacToe.Adapters.PlayerTracker.PresencePlayers do
  alias TicTacToeWeb.Presence
  alias TicTacToe.Adapters.PlayerTracker.Spec

  @behaviour TicTacToe.Adapters.PlayerTracker.Spec

  @topic "search_match"

  @spec get_all() :: Spec.players()
  def get_all do
    Presence.list(@topic)
  end

  @spec delete(Spec.player_pid(), Spec.player_id()) :: :ok
  def delete(pid, player_id) do
    :ok = Presence.untrack(pid, @topic, player_id)
  end

  @spec get(Spec.player_id()) :: Spec.player_data()
  def get(player_id) do
    @topic
    |> Presence.get_by_key(player_id)
    |> Map.fetch!(:metas)
    |> hd()
  end

  @spec subscribe(Spec.player_id(), Spec.player_data()) :: :ok
  def subscribe(player_id, data) do
    {:ok, _} = Presence.track(self(), @topic, player_id, data)

    :ok
  end
end
