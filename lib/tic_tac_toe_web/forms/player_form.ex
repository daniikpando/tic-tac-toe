defmodule TicTacToeWeb.Forms.PlayerForm do
  alias Ecto.Changeset

  @player_schema %{
    types: %{
      nickname: :string
    },
    fields: [
      :nickname
    ]
  }

  @doc """
  Returns a changeset to check if params are valid or not.
  """
  @spec changeset(map(), data: map(), action: atom() | nil) :: Changeset.t()
  def changeset(params, opts \\ []) do
    action = opts[:action]
    data = %{}

    {data, @player_schema.types}
    |> Changeset.cast(params, @player_schema.fields)
    |> Changeset.validate_required(@player_schema.fields)
    |> Changeset.validate_length(:nickname, min: 4)
    |> Map.put(:action, action)
  end
end
