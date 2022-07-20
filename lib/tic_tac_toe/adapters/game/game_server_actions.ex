defmodule TicTacToe.Adapters.Game.GameServerActions do
  alias TicTacToe.Contexts.Game.State, as: GameState
  alias TicTacToe.Contexts.Game.Player
  alias TicTacToe.Workers.Game.GameServer

  @behaviour TicTacToe.Adapters.Game.Spec

  @spec rate_limit(GameState.game_id(), Player.player_id()) :: boolean()
  def rate_limit(game_id, player_id) do
    GenServer.call(GameServer.via_tuple(game_id), {:check, player_id})
  end

  @spec get_player(GameState.game_id(), Player.player_id()) :: boolean()
  def get_player(game_id, player_id) do
    GenServer.call(GameServer.via_tuple(game_id), {:get_player, player_id})
  end

  @spec get_pid(GameState.game_id()) :: pid() | nil
  def get_pid(game_id) do
    GenServer.whereis(GameServer.via_tuple(game_id))
  end
end
