# Etherchat

Web interface to ChatGPT API implemented in Phoenix LiveView

Capstone Project for Dockyard Academy

## Features

- Inspired by Etherpad, app generates random pages for private chats without user accounts.

- Phoenix PubSub implements real-time sharing to be used as a tool in pair programming.

- Responses from ChatGPT are rendered in Markdown with syntax highlighting.

## Config

Requires OPENAI_API_KEY and OPENAI_ORGANIZATION_KEY environment variables to be set.

Uses gpt-3.5-turbo by default, change to gpt-4 by uncommenting in lib/chat/openai.ex


## Usage

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
