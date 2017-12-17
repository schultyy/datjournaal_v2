defmodule Datjournaal.User do
  use Datjournaal.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false
    has_many :posts, Datjournaal.ImagePost
    has_one :twitterkey, Datjournaal.TwitterKey
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password, :is_admin])
    |> validate_required([:email, :name, :password, :is_admin])
    |> validate_length(:password, min: 6)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
