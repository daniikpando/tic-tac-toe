defmodule TicTacToeWeb.Middlewares.SessionToken do
  import Plug.Conn

  alias TicTacToe.Variables

  @namespace "session"
  @salt Variables.get_salt()

  def generate(conn, _opts) do
    player_id = Ecto.UUID.generate()
    expiration_seconds = 86400

    token = Phoenix.Token.sign(@salt, @namespace, player_id, max_age: expiration_seconds)

    conn
    |> put_session(:token, token)
    |> put_session(:player_id, player_id)
  end

  def verify(conn, _opts) do
    token = get_session(conn, :token)
    player_id = get_session(conn, :player_id)

    case token do
      nil ->
        conn
        |> put_status(:not_found)
        |> halt()

      token when is_binary(token) ->
        check(conn, token, player_id)
    end
  end

  defp check(conn, token, player_id) do
    verified = Phoenix.Token.verify(@salt, @namespace, token)

    case verified do
      {:ok, ^player_id} ->
        conn

      {:error, _} ->
        conn
        |> put_status(:not_found)
        |> halt()
    end
  end
end
