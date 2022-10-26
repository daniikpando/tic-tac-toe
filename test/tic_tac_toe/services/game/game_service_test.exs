defmodule TicTacToe.Services.Game.GameServiceTest do
  use ExUnit.Case

  alias TicTacToe.Contexts.Game.Movement
  alias TicTacToe.Contexts.Game.Player
  alias TicTacToe.Contexts.Game.State, as: GameState
  alias TicTacToe.Services.Game.GameService
  doctest TicTacToe.Services.Game.GameService
end
