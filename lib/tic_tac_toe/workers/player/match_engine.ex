defmodule TicTacToe.Workers.Player.MatchEngine do
  use GenServer

  alias TicTacToe.Services.Player.MatchService

  # * Maybe could be useful to implement with partition supervisor to not generate bottlenecks.

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
    :ok = MatchService.create_games_for_unmatch_players()

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.seconds(2))
  end
end
