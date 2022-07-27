defmodule TicTacToeWeb.Live.PlayerLive do
  use TicTacToeWeb, :live_view

  alias TicTacToe.Services.Player.TrackerService
  alias TicTacToeWeb.Forms.PlayerForm

  def mount(_, %{"player_id" => player_id}, socket) do
    Process.monitor(self())

    player_changeset = PlayerForm.changeset(%{})

    socket
    |> assign(:changeset, player_changeset)
    |> assign(:searching_game?, false)
    |> assign(:player_id, player_id)
    |> then(&{:ok, &1})
  end

  def handle_event("validate", %{"player_form" => player_form}, socket) do
    changeset = PlayerForm.changeset(player_form, action: :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("submit", %{"player_form" => player_form}, socket) do
    player_id = socket.assigns.player_id
    changeset = PlayerForm.changeset(player_form, action: :validate)

    if changeset.valid? do
      %{changes: %{nickname: nickname}} = changeset

      data = %{id: player_id, nickname: nickname, pid: self()}

      TrackerService.subscribe(player_id, data)

      {:noreply,
       socket
       |> assign(:searching_game?, true)
       |> put_flash(:info, "Searching an oponent...")}
    else
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_info({:game_started, %{game_id: game_id}}, socket) do
    {:noreply, redirect(socket, to: Routes.game_path(socket, :game, game_id))}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, socket) do
    player_id = socket.assigns.player_id

    TrackerService.delete(self(), player_id)

    {:noreply, socket}
  end

  @spec get_button_label(searching_game? :: boolean()) :: String.t()
  defp get_button_label(searching_game?) do
    if searching_game? do
      "Searching an oponent"
    else
      "Search for a game"
    end
  end
end
