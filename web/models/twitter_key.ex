defmodule Datjournaal.TwitterKey do
  use Datjournaal.Web, :model

  schema "twitterkeys" do
    field :name, :string
    field :screen_name, :string
    field :access_token, :string
    field :access_token_secret, :string
    belongs_to :user, Datjournaal.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :screen_name, :access_token, :access_token_secret])
    |> validate_required([:name, :screen_name, :access_token, :access_token_secret])
  end
end
