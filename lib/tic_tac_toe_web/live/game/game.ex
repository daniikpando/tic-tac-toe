defmodule TicTacToeWeb.Live.Game do
  use TicTacToeWeb, :live_view

  def mount(%{"game_id" => game_id}, %{"player_id" => player_id}, socket) do
    socket
    |> assign(:game_id, game_id)
    |> assign(:player_id, player_id)
    |> then(&{:ok, &1})
  end
end
