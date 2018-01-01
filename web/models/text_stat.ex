defmodule Datjournaal.TextStat do
  use Datjournaal.Web, :model

  alias Datjournaal.Stats

  schema "text_stats" do
    field :unique_identifier, :string
    field :authenticated, :boolean, default: false
    belongs_to :text_post, Datjournaal.TextPost

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:unique_identifier, :authenticated, :text_post_id])
    |> validate_required([:unique_identifier, :authenticated])
    |> Stats.unique_ip_address
  end
end
