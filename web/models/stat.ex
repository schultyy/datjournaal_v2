defmodule Datjournaal.Stat do
  use Datjournaal.Web, :model

  schema "stats" do
    field :unique_identifier, :string
    field :authenticated, :boolean
    belongs_to :post, Datjournaal.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:unique_identifier])
    |> validate_required([:unique_identifier])
  end
end
