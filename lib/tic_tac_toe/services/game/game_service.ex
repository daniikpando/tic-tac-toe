defmodule TicTacToe.Services.Game.GameService do
  @moduledoc """
  Business logic for tic tac toe

  `Tic Tac Toe` board points (x_axis, y_axis)

  ```
          |        |
   (1, 1) | (1, 2) | (1, 3)
  ---------------------------
   (2, 1) | (2, 2) | (2, 3)
  ---------------------------
   (3, 1) | (3, 2) | (3, 3)
          |        |
  ```
  """

  alias TicTacToe.Contexts.Game.Movement
  alias TicTacToe.Contexts.Game.Player
  alias TicTacToe.Contexts.Game.State, as: GameState

  @type path :: {Movement.x_axis(), Movement.y_axis()}
  @opaque winner_paths :: [MapSet.t(path())]

  @winner_paths [
    # X axis winner paths
    MapSet.new([{1, 1}, {2, 1}, {3, 1}]),
    MapSet.new([{1, 2}, {2, 2}, {3, 2}]),
    MapSet.new([{1, 3}, {2, 3}, {3, 3}]),

    # Y axis winner paths
    MapSet.new([{1, 1}, {1, 2}, {1, 3}]),
    MapSet.new([{2, 1}, {2, 2}, {2, 3}]),
    MapSet.new([{3, 1}, {3, 2}, {3, 3}]),

    # Diagonal winner paths
    MapSet.new([{1, 1}, {2, 2}, {3, 3}]),
    MapSet.new([{3, 1}, {2, 2}, {1, 3}])
  ]

  @doc """
  Adds a `Movement` to `GameState` and returns an updated `GameState`.

  Examples:

      iex> %GameState{}
      ...> |> GameService.add_movement(%Movement{x_axis: 1, y_axis: 1})
      ...> |> GameService.add_movement(%Movement{x_axis: 1, y_axis: 2})
      ...> |> GameService.add_movement(%Movement{x_axis: 1, y_axis: 3})
      %GameState{movements: [%Movement{x_axis: 1, y_axis: 3}, %Movement{x_axis: 1, y_axis: 2}, %Movement{x_axis: 1, y_axis: 1}]}

  """
  @spec add_movement(GameState.t(), Movement.t()) :: GameState.t()
  def add_movement(%GameState{} = game, %Movement{} = movement) do
    %GameState{game | movements: [movement | game.movements]}
  end

  @doc """
  Returns if a player wins a game.

  Examples:

      iex> player_1 = Ecto.UUID.generate()
      iex> player_2 = Ecto.UUID.generate()
      iex> game = %GameState{players: [player_1, player_2]}
      ...> |> GameService.add_movement(%Movement{x_axis: 1, y_axis: 1, player_id: player_1})
      ...> |> GameService.add_movement(%Movement{x_axis: 1, y_axis: 2, player_id: player_1})
      ...> |> GameService.add_movement(%Movement{x_axis: 1, y_axis: 3, player_id: player_1})
      ...> |> GameService.add_movement(%Movement{x_axis: 2, y_axis: 3, player_id: player_2})
      ...> |> GameService.add_movement(%Movement{x_axis: 2, y_axis: 2, player_id: player_2})
      iex> match?(%GameState{winner: ^player_1}, GameService.winner?(game, player_1))
      true
      iex> match?(%GameState{winner: ^player_2}, GameService.winner?(game, player_2))
      false

  """
  @spec winner?(GameState.t(), Player.player_id()) :: GameState.t()
  def winner?(%GameState{} = game, player_id) do
    player_movements =
      game.movements
      |> Enum.filter(fn movement -> movement.player_id == player_id end)
      |> Enum.map(fn movement -> {movement.x_axis, movement.y_axis} end)
      |> MapSet.new()

    got_winner? =
      Enum.any?(@winner_paths, fn movement ->
        MapSet.subset?(movement, player_movements)
      end)

    if got_winner? do
      %GameState{game | winner: player_id}
    else
      game
    end
  end

  @spec get_winner_paths() :: winner_paths()
  def get_winner_paths, do: @winner_paths

  @doc """
  Checks if player can access to a game

  Example:

      iex> player_1 = %Player{id: Ecto.UUID.generate()}
      iex> player_2 = %Player{id: Ecto.UUID.generate()}
      iex> game = %GameState{players: [player_1, player_2]}
      iex> GameService.rate_limit(game, player_1.id)
      true
      iex> GameService.rate_limit(game, player_2.id)
      true
      iex> GameService.rate_limit(game, Ecto.UUID.generate())
      false

  """
  @spec rate_limit(GameState.t(), Player.player_id()) :: boolean()
  def rate_limit(%GameState{} = game, player_id) do
    player = Enum.find(game.players, fn player -> player.id == player_id end)

    match?(%Player{}, player)
  end

  @spec get_player(GameState.t(), Player.player_id()) :: Player.t()
  def get_player(%GameState{} = game, player_id) do
    %Player{} = Enum.find(game.players, fn player -> player.id == player_id end)
  end
end
