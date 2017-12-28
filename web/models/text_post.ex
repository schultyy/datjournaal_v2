defmodule Datjournaal.TextPost do
  use Datjournaal.Web, :model

  schema "text_posts" do
    field :title, :string
    field :content, :string
    field :slug, :string
    belongs_to :user, Datjournaal.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content])
    |> validate_required([:title, :content])
    |> create_slug()
    |> assoc_constraint(:user)
  end

  defp create_slug(changeset) do
    put_change(changeset, :slug, UUID.uuid4(:hex))
  end
end
