defmodule TicTacToe.Contexts.Game.Player do
  @type player_id :: Ecto.UUID.t()

  @type t :: %__MODULE__{
          id: player_id(),
          nickname: String.t(),
          victory_count: non_neg_integer()
        }

  defstruct id: "", nickname: "", victory_count: 0

  @spec new(%{id: player_id(), nickname: String.t()}) :: t()
  def new(%{id: player_id, nickname: nickname}) do
    %__MODULE__{
      id: player_id,
      nickname: nickname
    }
  end
end
