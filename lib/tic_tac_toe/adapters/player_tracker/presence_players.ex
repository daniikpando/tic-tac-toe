defmodule TicTacToe.Adapters.PlayerTracker.PresencePlayers do
  alias TicTacToeWeb.Presence

  @behaviour TicTacToe.Adapters.PlayerTracker.Spec

  @topic "search_match"

  def get_all do
    Presence.list(@topic)
  end

  def delete(pid, session_id) do
    :ok = Presence.untrack(pid, @topic, session_id)
  end

  def get(session_id) do
    @topic
    |> Presence.get_by_key(session_id)
    |> Map.fetch!(:metas)
    |> hd()
  end

  def subscribe(session_id, data) do
    {:ok, _} = Presence.track(self(), @topic, session_id, data)

    :ok
  end
end
