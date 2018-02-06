defmodule Datjournaal.Tweet do
  def to_url(post) do
    "http://datjournaal.de/#{post.slug}"
  end

  def to_tweet(url, nil), do: to_tweet(url, "")
  def to_tweet(url, original_text) do
    max_text_length = 140 - String.length(url) - dotlength - String.length(prefix)
    sliced_text = if String.length(original_text) > max_text_length do
      String.slice(original_text, 0, max_text_length) <> "..."
    else
      original_text
    end

    Enum.join([prefix <> sliced_text, url], "\n")
  end
  def to_tweet(url, "", location) do
    location = location_prefix <> " " <> location
    Enum.join([prefix <> location, url], "\n")
  end
  def to_tweet(url, original_text, nil), do: to_tweet(url, original_text)
  def to_tweet(url, nil, location), do: to_tweet(url, "", location)
  def to_tweet(url, original_text, location) do
    max_text_length = 140 - String.length(url) - String.length(location) - location_prefix_length - dotlength - String.length(prefix)
    sliced_text = if String.length(original_text) > max_text_length do
      String.slice(original_text, 0, max_text_length) <> "..."
    else
      original_text
    end

    location = location_prefix <> " " <> location
    Enum.join([prefix <> sliced_text, location, url], "\n")
  end

  defp location_prefix_length do
    (location_prefix |> String.length) + 2
  end

  defp dotlength do
    #Dot length is four at the end to have enough space for three dots and a line break
    4
  end

  defp location_prefix do
    "@"
  end

  defp prefix do
    "📸 "
  end
end
