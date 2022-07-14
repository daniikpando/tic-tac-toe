defmodule TicTacToe.Variables do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  def track_with_presence? do
    Application.fetch_env!(:tic_tac_toe, :track_with_presence)
  end

  def player_tracker_module do
    if track_with_presence?() do
      TicTacToe.Adapters.PlayerTracker.PresencePlayers
    else
      TicTacToe.Adapters.PlayerTracker.WorkerPlayers
    end
  end
end
