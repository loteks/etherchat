defmodule ChatWeb.PageController do
  use ChatWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)
    room = MnemonicSlugs.generate_slug(3)
    redirect(conn, to: "/#{room}")
  end
end
