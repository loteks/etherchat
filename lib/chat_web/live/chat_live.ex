defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(%{"room_id" => room_id}, _session, socket) do
    {:ok, assign(socket, room: room_id, prompt: "", response: "")}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    # IO.inspect(prompt, label: "PROMPT")
    socket = assign(socket, prompt: prompt, response: Chat.OpenAI.send(prompt))
    # IO.inspect(socket, label: "SOCKET")
    {:noreply, socket}
  end

  # NOTE : make "question" and "response" into users...

  def render(assigns) do
    ~H"""
    <br />
    <h2>Question: <%= @prompt %></h2>
    <br />
    <h2>Response: <%= @response %></h2>
    <br />
    <form phx-submit="prompt">
      <input
        type="text"
        name="prompt"
        placeholder="Ask GPT a question..."
        autofocus
        autocomplete="off"
      />
    </form>
    """
  end
end
