defmodule TicTacToe.Adapters.PlayerTracker.Spec do
  @type player_id :: Ecto.UUID.t()
  @type player_pid :: pid()

  @type player_data :: %{
          nickname: String.t(),
          pid: player_pid()
        }

  @type players :: %{
          player_id() => player_data()
        }

  @doc """
  Gets all connected players waiting for a game.
  """
  @callback get_all() :: players()

  @doc """
  Subscribes a new player to wait for a new game with another player.
  """
  @callback subscribe(player_id, player_data()) :: :ok

  @doc """
  Gets player data by a player_id.
  """
  @callback get(player_id()) :: player_data()

  @doc """
  Unsubscribe a player from the wait list.
  """
  @callback delete(player_pid(), player_id()) :: :ok
end
