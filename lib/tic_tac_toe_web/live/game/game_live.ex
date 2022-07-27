defmodule TicTacToeWeb.Live.GameLive do
  use TicTacToeWeb, :live_view
  alias TicTacToe.Adapters.Game.GameServerActions

  def mount(%{"game_id" => game_id}, %{"player_id" => player_id}, socket) do
    with {:ok, _game_pid} <- find_game(game_id),
         :ok <- check_player(game_id, player_id),
         {:ok, {current_player, oponent_player}} <- get_players(game_id, player_id),
         :ok <- subscribe_to_game(game_id) do
      socket
      |> assign(:game_id, game_id)
      |> assign(:current_player, current_player)
      |> assign(:oponent_player, oponent_player)
      |> assign(:current_player_icon, "x")
      |> assign(:oponent_player_icon, "o")
      |> assign(:player_id, player_id)
      |> assign_board_positions()
      |> then(&{:ok, &1})
    end
  end

  def handle_event("selected_point", %{"x_axis" => x_axis, "y_axis" => y_axis}, socket) do
    player_id = socket.assigns.player_id
    game_id = socket.assigns.game_id
    x_axis = String.to_integer(x_axis)
    y_axis = String.to_integer(y_axis)

    Phoenix.PubSub.broadcast!(
      TicTacToe.PubSub,
      "game:#{game_id}",
      {:selected_point, %{player_id: player_id, x_axis: x_axis, y_axis: y_axis}}
    )

    {:noreply, socket}
  end

  def handle_info(
        {:selected_point, %{player_id: player_id, x_axis: x_axis, y_axis: y_axis}},
        socket
      ) do
    current_player_id = socket.assigns.player_id

    board_positions =
      Enum.map(socket.assigns.board_positions, fn
        %{point: {^x_axis, ^y_axis}} = data ->
          icon =
            if current_player_id == player_id do
              socket.assigns.current_player_icon
            else
              socket.assigns.oponent_player_icon
            end

          Map.put(data, :icon, icon)

        data ->
          data
      end)

    {:noreply, assign(socket, :board_positions, board_positions)}
  end

  defp find_game(game_id) do
    case GameServerActions.get_pid(game_id) do
      game_pid when is_pid(game_pid) ->
        {:ok, game_pid}

      nil ->
        {:error, :not_found}
    end
  end

  defp assign_board_positions(socket) do
    board_positions =
      for x <- 1..3, y <- 1..3 do
        %{
          point: {x, y},
          icon: nil
        }
      end

    assign(socket, :board_positions, board_positions)
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

  defp get_players(game_id, player_id) do
    players = GameServerActions.get_players(game_id)

    current_player = Enum.find(players, fn player -> player.id == player_id end)
    oponent_player = Enum.find(players, fn player -> player.id != player_id end)

    {:ok, {current_player, oponent_player}}
  end

  defp subscribe_to_game(game_id) do
    Phoenix.PubSub.subscribe(TicTacToe.PubSub, "game:#{game_id}")
  end
end
