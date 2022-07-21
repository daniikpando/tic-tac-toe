defmodule TicTacToe.Adapters.Game.Spec do
  alias TicTacToe.Contexts.Game.State, as: GameState
  alias TicTacToe.Contexts.Game.Player

  @doc """
  Checks if player can play in the a given game.
  """
  @callback rate_limit(GameState.game_id(), Player.player_id()) :: boolean()

  @doc """
  Gets the pid of the game.
  """
  @callback get_pid(GameState.game_id()) :: pid() | nil

  @doc """
  Gets a player of a game.
  """
  @callback get_player(GameState.game_id(), Player.player_id()) :: Player.t()

  @doc """
  Gets players of a game.
  """
  @callback get_players(GameState.game_id()) :: [Player.t()]
end
