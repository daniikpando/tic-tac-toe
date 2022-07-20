defmodule TicTacToeWeb.Live.Game do
  use TicTacToeWeb, :live_view
  alias TicTacToe.Adapters.Game.GameServerActions

  def mount(%{"game_id" => game_id}, %{"player_id" => player_id}, socket) do
    with {:ok, _game_pid} <- find_game(game_id),
         :ok <- check_player(game_id, player_id),
         {:ok, player} <- get_player(game_id, player_id),
         :ok <- subscribe_to_game(game_id) do
      socket
      |> assign(:game_id, game_id)
      |> assign(:player, player)
      |> assign(:player_id, player_id)
      |> then(&{:ok, &1})
    end
  end

  defp find_game(game_id) do
    case GameServerActions.get_pid(game_id) do
      game_pid when is_pid(game_pid) ->
        {:ok, game_pid}

      nil ->
        {:error, :not_found}
    end
  end

  defp check_player(game_id, player_id) do
    valid_to_play? = GameServerActions.rate_limit(game_id, player_id)

    case valid_to_play? do
      true ->
        :ok

      _ ->
        {:error, :not_valid}
    end
  end

  defp get_player(game_id, player_id) do
    player = GameServerActions.get_player(game_id, player_id)

    {:ok, player}
  end

  defp subscribe_to_game(game_id) do
    Phoenix.PubSub.subscribe(TicTacToe.PubSub, "game:#{game_id}")
  end
end
