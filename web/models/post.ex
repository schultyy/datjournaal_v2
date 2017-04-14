defmodule Datjournaal.Post do
  use Datjournaal.Web, :model

  schema "posts" do
    field :description, :string
    field :image, :string
    field :slug, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :image, :slug])
    |> validate_required([:description, :image, :slug])
  end
end
