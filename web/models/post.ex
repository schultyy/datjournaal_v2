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
    |> cast(params, [:description])
    |> cast_attachments(params, [:image])
    |> validate_required([:image])
    |> create_slug
  end

  defp create_slug(changeset) do
    put_change(changeset, :slug, UUID.uuid4(:hex))
  end
end
