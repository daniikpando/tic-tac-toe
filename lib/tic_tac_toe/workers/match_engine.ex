defmodule TicTacToe.Workers.MatchEngine do
  use GenServer

  require Logger
  alias TicTacToe.Services.Player.Tracker

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    sessions = Tracker.get_all()

    sessions
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.chunk_every(2)
    |> Enum.each(fn
      [_, _] = selected_sessions ->
        game_id = Ecto.UUID.generate()

        for session <- selected_sessions do
          %{pid: pid} = Tracker.get(session)

          send(pid, {:game_started, %{game_id: game_id}})

          :ok = Tracker.delete(pid, session)
        end

      _ ->
        :ok
    end)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.seconds(2))
  end
end
