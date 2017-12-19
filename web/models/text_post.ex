defmodule Datjournaal.TextPost do
  use Datjournaal.Web, :model

  schema "text_posts" do
    field :title, :string
    field :content, :string
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
  end
end
