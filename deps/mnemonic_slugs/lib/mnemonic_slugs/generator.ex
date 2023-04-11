defmodule MnemonicSlugs.Generator do
  @moduledoc """
  Functions to generate mnemonic slugs by joining carefully selected words with
  a separator, currently `-` (a dash).
  """

  @separator "-"

  @doc """
  Returns a default length (two word) slug.

      iex> MnemonicSlugs.Generator.generate_slug
      "aurora-bermuda"
  """
  @spec generate_slug() :: String.t
  def generate_slug, do: generate_slug(2)

  @doc """
  Returns a slug `count` words long.

      iex> MnemonicSlugs.Generator.generate_slug(10)
      "karate-textile-jungle-patrol-veteran-clone-nerve-stone-soviet-sting"
  """
  @spec generate_slug(count :: Integer.t) :: String.t
  def generate_slug(count) do
    MnemonicSlugs.Wordlist.get_words(count) |> Enum.join(@separator)
  end
end
