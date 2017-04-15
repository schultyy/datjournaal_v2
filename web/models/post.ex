defmodule Datjournaal.Post do
  use Datjournaal.Web, :model
  use Arc.Ecto.Schema

  schema "posts" do
    field :description, :string
    field :image, Datjournaal.Image.Type
    field :slug, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :slug])
    |> cast_attachments(params, [:image])
    |> validate_required([:description, :image, :slug])
  end
end
