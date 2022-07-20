defmodule TicTacToe.Services.Player.MatchService do
  alias TicTacToe.Contexts.Game.State, as: GameState
  alias TicTacToe.Services.Player.TrackerService
  alias TicTacToe.Workers.Game.GameSupervisor

  @spec create_games_for_unmatch_players :: :ok
  def create_games_for_unmatch_players do
    unmatched_players = TrackerService.get_all()

    unmatched_players
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.chunk_every(2)
    |> Enum.each(fn
      [_, _] = selected_players ->
        game_id = Ecto.UUID.generate()

        players =
          Enum.map(selected_players, fn player_id ->
            TrackerService.get(player_id)
          end)

        :ok = create_game(game_id, players)

        for player <- players do
          %{pid: player_pid, id: player_id} = player
          send(player_pid, {:game_started, %{game_id: game_id}})
          :ok = TrackerService.delete(player_pid, player_id)
        end

      _ ->
        :ok
    end)
  end

  @spec create_game(GameState.game_id(), [map()]) :: :ok | {:error, :ignore | :invalid}
  defp create_game(game_id, [_, _] = players) do
    GameSupervisor.start_child(game_id, players)
  end
end
