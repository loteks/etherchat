defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(%{"room_id" => room_id}, _session, socket) do
    {:ok, assign(socket, room: room_id, prompt_id: nil, prompt_body: "")}
  end

  def handle_event("prompt", %{"prompt_body" => prompt_body}, socket) do
    # IO.inspect(prompt, label: "PROMPT")
    socket = assign(socket, prompt_id: UUID.uuid4(), prompt_body: prompt_body)
    # IO.inspect(socket, label: "SOCKET")
    {:noreply, socket}
  end

  def response(prompt_body) do
    Chat.OpenAI.callAPI(prompt_body)
  end

  def render(assigns) do
    ~H"""
    <h1>Question: <%= @prompt_body %></h1>
    <br />
    <pre><%= response(@prompt_body) %></pre>
    <br />
    <form phx-submit="prompt">
      <input
        type="text"
        name="prompt_body"
        placeholder="Ask GPT a question..."
        autofocus
        autocomplete="off"
      />
    </form>
    """
  end
end