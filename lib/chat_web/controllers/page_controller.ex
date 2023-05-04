defmodule ChatWeb.PageController do
  use ChatWeb, :controller

  @moduledoc """
  Use MnemonicSlugs to generate a new random readable page name with each visit to /
  """

  def home(conn, _params) do
    room = MnemonicSlugs.generate_slug(3)
    redirect(conn, to: "/#{room}")
  end
end
