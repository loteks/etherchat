defmodule MnemonicSlugs.Wordlist do
  @moduledoc """
  Functions for generating random mnemonic words.
  """

  @doc """
  Returns a random word.

      iex> MnemonicSlugs.Wordlist.get_word
      "aurora"
  """
  @spec get_word() :: String.t
  def get_word do
    MnemonicSlugs.Wordlist.Words.list |> Enum.random
  end

  @doc """
  Returns `count` random words as a list.

      iex> MnemonicSlugs.Wordlist.get_words(10)
      ["cupid", "byte", "reverse", "cricket", "quota", "laptop", "segment",
       "navy", "touch", "swim"]
  """
  @spec get_words(num_words :: Integer.t) :: List.t
  def get_words(num_words) when is_integer(num_words) do
    MnemonicSlugs.Wordlist.Words.list |> Enum.take_random(num_words)
  end
end
