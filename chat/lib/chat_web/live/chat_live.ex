defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, assign(socket, room: Map.get(params, "room_id"), prompt: "")}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    # IO.inspect(prompt, label: "PROMPT")
    socket = assign(socket, prompt: prompt)
    # IO.inspect(socket, label: "SOCKET")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>You are chatting with GPT in the <%= @room %> room</h1>
    <br />
    <p><%= @prompt %></p>
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
