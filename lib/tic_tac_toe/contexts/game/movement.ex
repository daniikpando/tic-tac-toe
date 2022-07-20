defmodule TicTacToe.Contexts.Game.Movement do
  alias TicTacToe.Contexts.Game.Player

  @type x_axis :: pos_integer()
  @type y_axis :: pos_integer()

  @type t :: %__MODULE__{
          player_id: Player.player_id(),
          x_axis: x_axis(),
          y_axis: y_axis()
        }

  defstruct player_id: "", x_axis: nil, y_axis: nil

  @spec new(Player.player_id(), x_axis(), y_axis()) :: t()
  def new(player_id, x_axis, y_axis) do
    %__MODULE__{
      player_id: player_id,
      x_axis: x_axis,
      y_axis: y_axis
    }
  end
end
