defmodule TicTacToe.Services.Player.Tracker do
  alias TicTacToe.Variables

  @module Variables.player_tracker_module()

  def get_all do
    @module.get_all()
  end

  def delete(pid, key) do
    @module.delete(pid, key)
  end

  def get(key) do
    @module.get(key)
  end

  def subscribe(player_id, data) do
    @module.subscribe(player_id, data)
  end
end
