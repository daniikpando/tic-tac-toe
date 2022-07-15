defmodule TicTacToe.Adapters.PlayerTracker.PresencePlayers do
  alias TicTacToeWeb.Presence

  @behaviour TicTacToe.Adapters.PlayerTracker.Spec

  @topic "search_match"

  def get_all do
    Presence.list(@topic)
  end

  def delete(pid, player_id) do
    :ok = Presence.untrack(pid, @topic, player_id)
  end

  def get(player_id) do
    @topic
    |> Presence.get_by_key(player_id)
    |> Map.fetch!(:metas)
    |> hd()
  end

  def subscribe(player_id, data) do
    {:ok, _} = Presence.track(self(), @topic, player_id, data)

    :ok
  end
end
