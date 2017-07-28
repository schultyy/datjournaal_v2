defmodule Datjournaal.User do
  use Datjournaal.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false
    has_many :posts, Datjournaal.Post
    has_one :twitterkey, Datjournaal.TwitterKey
    timestamps()
  end

  def change_password_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(password), ~w())
    |> validate_old_password(params["old_password"])
    |> validate_length(:password, min: 5)
    |> generate_encrypted_password
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

  defp validate_old_password(changeset, old_password) do
    user = changeset.data
    case Comeonin.Bcrypt.checkpw(old_password, user.password_hash) do
      true -> changeset
      false ->  changeset |> add_error(:password, "Old password does not match")
    end
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
