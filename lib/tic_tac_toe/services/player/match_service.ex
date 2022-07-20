defmodule TicTacToe.Services.Player.MatchService do
  alias TicTacToe.Services.Player.TrackerService

  @spec create_games_for_unmatch_players :: :ok
  def create_games_for_unmatch_players do
    unmatched_players = TrackerService.get_all()

    unmatched_players
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.chunk_every(2)
    |> Enum.each(fn
      [_, _] = selected_players ->
        game_id = Ecto.UUID.generate()

        for player <- selected_players do
          %{pid: player_pid} = TrackerService.get(player)

          send(player_pid, {:game_started, %{game_id: game_id}})

          :ok = TrackerService.delete(player_pid, player)
        end

      _ ->
        :ok
    end)
  end
end
