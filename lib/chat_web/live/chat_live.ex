defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(%{"room_id" => room_id}, _session, socket) do
    {:ok, assign(socket, room: room_id, prompt: "", response: "", history: [])}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    IO.inspect(prompt, label: "PROMPT")
    response = Chat.OpenAI.send(prompt)
    new_history = [prompt, response | socket.assigns.history]

    socket =
      assign(socket,
        prompt: prompt,
        response: response,
        history: new_history
      )

    IO.inspect(socket, label: "SOCKET")
    {:noreply, socket}
  end

  # NOTE : make "question" and "response" into users...

  def render(assigns) do
    ~H"""
    <pre :for={msg <- @history}><%= msg %></pre>
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
