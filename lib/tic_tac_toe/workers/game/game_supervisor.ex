defmodule TicTacToe.Workers.Game.GameSupervisor do
  require Logger
  use DynamicSupervisor

  alias TicTacToe.Workers.Game.GameServer

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(game_id, players) do
    on_start_child =
      DynamicSupervisor.start_child(__MODULE__, {GameServer, game_id: game_id, players: players})

    case on_start_child do
      {:ok, _} ->
        :ok

      :ignore ->
        Logger.error("Game not started #{game_id}, reason: #{:ignore}")

        {:error, :ignore}

      {:error, _} = error ->
        Logger.error("Game not started #{game_id}, reason: #{inspect(error)}")
        {:error, :invalid}
    end
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end
end
