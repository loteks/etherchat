defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(%{"room_id" => room_id}, _session, socket) do
    topic = "room:#{room_id}"

    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic)
    end

    {:ok, assign(socket, room: room_id, topic: topic, prompt: "", response: "", history: []),
     temporary_assigns: [history: []]}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    # IO.inspect(prompt, label: "PROMPT")

    response = Chat.OpenAI.send(prompt)
    # IO.inspect(response, label: "RESPONSE")

    history = ["Question: #{prompt}", "Response: #{response}"]
    # IO.inspect(history, label: "HISTORY")

    socket = assign(socket, prompt: prompt, response: response, history: history)
    # IO.inspect(socket, label: "SOCKET")

    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-chat", history)

    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg.payload, label: "HANDLE_INFO")
    # {:noreply, assign(socket, history: msg.payload)}
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div phx-update="append" id="msg">
    <p :for={msg <- @history} id={UUID.uuid4()}><%= msg %></p></div>
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
    <br>
    <h1>You are chatting with GPT in the <em><%= @room %></em> room</h1>
    """
  end
end
