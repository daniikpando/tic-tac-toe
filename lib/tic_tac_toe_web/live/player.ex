defmodule TicTacToeWeb.Live.Player do
  use TicTacToeWeb, :live_view

  alias TicTacToe.Services.Player.Tracker, as: TrackerService
  alias TicTacToeWeb.Forms.PlayerForm

  def mount(_, _, socket) do
    Process.monitor(self())

    player_changeset = PlayerForm.changeset(%{})
    session_id = Ecto.UUID.generate()

    socket
    |> assign(:changeset, player_changeset)
    |> assign(:searching_game?, false)
    |> assign(:session_id, session_id)
    |> then(&{:ok, &1})
  end

  def handle_event("validate", %{"party_form" => party_form}, socket) do
    changeset = PlayerForm.changeset(party_form, action: :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("submit", %{"party_form" => party_form}, socket) do
    session_id = socket.assigns.session_id
    changeset = PlayerForm.changeset(party_form, action: :validate)

    if changeset.valid? do
      %{changes: %{nickname: nickname}} = changeset

      data = %{nickname: nickname, pid: self()}

      TrackerService.subscribe(session_id, data)

      {:noreply,
       socket
       |> assign(:searching_game?, true)
       |> put_flash(:info, "Searching an oponent...")}
    else
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_info({:game_started, %{game_id: game_id}}, socket) do
    {:noreply, put_flash(socket, :info, "Redirected to game #{game_id}")}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, socket) do
    session_id = socket.assigns.session_id

    TrackerService.delete(self(), session_id)

    {:noreply, socket}
  end
end
