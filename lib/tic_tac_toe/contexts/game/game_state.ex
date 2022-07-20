defmodule TicTacToe.Contexts.Game.State do
  alias TicTacToe.Contexts.Game.Movement
  alias TicTacToe.Contexts.Game.Player

  @type game_id :: Ecto.UUID.t()

  @type t :: %__MODULE__{
          id: game_id(),
          players: [Player.t()],
          movements: [Movement.t()],
          player_turn: Player.player_id(),
          finished?: boolean(),
          winner: Player.player_id() | nil
        }

  defstruct id: "",
            players: [],
            movements: [],
            player_turn: "",
            finished?: false,
            winner: nil

  @spec new(game_id(), [%{id: Player.player_id(), nickname: String.t()}]) :: t()
  def new(game_id, players) do
    players =
      for player <- players do
        Player.new(player)
      end

    player_first_turn = Enum.random(players)

    %__MODULE__{
      id: game_id,
      players: players,
      movements: [],
      player_turn: player_first_turn.id,
      finished?: false,
      winner: nil
    }
  end
end
