defmodule Datjournaal.Image do
  use Arc.Definition
  use Arc.Ecto.Definition

  def __storage, do: Arc.Storage.Local

  @versions [:original, :thumb]

  def validate({file, _}) do
    ext_name = Path.extname(file.file_name) |> String.downcase
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(ext_name)
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 600x600^ -gravity center -auto-orient -extent 600x600 -format png", :png}
  end

  def transform(:original, _) do
    # {:convert, "-strip -auto-orient -format png", :png}
    # We keep this line because of compability reasons to dat journaal v1
    {:convert, "-strip -auto-orient -format jpg", :jpg}
  end

  def filename(version, {file, _}), do: "#{version}-#{file.file_name}"
  # We keep the above version because of compability reasons
  # def filename(version, {file, _}) do
  #   ext_name = Path.extname(file.file_name)
  #   "#{version}-#{Path.basename(file.file_name, ext_name)}"
  # end

  def storage_dir(_version, {_file, _scope}) do
    Application.get_env(:datjournaal, Datjournaal.Endpoint)[:uploads_dir]
  end
end
