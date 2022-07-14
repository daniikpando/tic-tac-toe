defmodule TicTacToe.Adapters.PlayerTracker.Spec do
  @type player_session :: Ecto.UUID.t()
  @type live_view_pid :: pid()

  @type player_data :: %{
          nickname: String.t(),
          pid: live_view_pid()
        }

  @type players :: %{
          player_session() => player_data()
        }

  @callback get_all() :: players()

  @callback subscribe(player_session, player_data()) :: :ok

  @callback get(player_session()) :: player_data()

  @callback delete(live_view_pid(), player_session()) :: :ok
end
