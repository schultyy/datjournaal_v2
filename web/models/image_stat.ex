defmodule Datjournaal.ImageStat do
  use Datjournaal.Web, :model

  alias Datjournaal.Stats

  schema "image_stats" do
    field :unique_identifier, :string
    field :authenticated, :boolean
    belongs_to :image_post, Datjournaal.ImagePost
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:unique_identifier, :authenticated, :image_post_id])
    |> validate_required([:unique_identifier, :authenticated])
    |> Stats.unique_ip_address
  end
end
