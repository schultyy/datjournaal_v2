defmodule Datjournaal.Repo do
  use Ecto.Repo, otp_app: :datjournaal
  use Scrivener, page_size: 1
end
