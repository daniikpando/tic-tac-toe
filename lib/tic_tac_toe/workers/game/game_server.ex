defmodule TicTacToe.Workers.Game.GameServer do
  use GenServer

  alias TicTacToe.Contexts.Game.State
  alias TicTacToe.Services.Game.GameService

  def child_spec(opts) do
    game_id = Keyword.fetch!(opts, :game_id)

    %{
      id: topic(game_id),
      start: {__MODULE__, :start_link, [opts]},
      restart: :transient,
      shutdown: 5_000
    }
  end

  def start_link(opts) do
    game_id = Keyword.fetch!(opts, :game_id)

    GenServer.start_link(__MODULE__, opts, name: via_tuple(game_id))
  end

  @impl true
  def init(opts) do
    game_id = Keyword.fetch!(opts, :game_id)
    [%{id: _}, %{id: _}] = players = Keyword.fetch!(opts, :players)

    {:ok, State.new(game_id, players)}
  end

  @impl true
  def handle_call({:check, player_id}, _from, game) do
    {:reply, GameService.rate_limit(game, player_id), game}
  end

  @impl true
  def handle_call({:get_player, player_id}, _from, game) do
    {:reply, GameService.get_player(game, player_id), game}
  end

  def via_tuple(game_id) do
    {:global, topic(game_id)}
  end

  def topic(game_id), do: "game_state:#{game_id}"
end
