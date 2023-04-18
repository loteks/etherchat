defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(%{"room_id" => room_id}, _session, socket) do
    topic = "room:#{room_id}"

    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic)
    end

    {:ok, assign(socket, room: room_id, topic: topic, prompt: [], response: []),
     temporary_assigns: [prompt: [], response: []]}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "msg", prompt)
    Process.sleep(3000)

    Task.start(fn ->
      response = Chat.OpenAI.send(prompt)
      ChatWeb.Endpoint.broadcast(socket.assigns.topic, "msg", response)
    end)

    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    # IO.inspect(msg.payload, label: "HANDLE_INFO")
    {:noreply, assign(socket, prompt: msg.payload)}
  end

  def render(assigns) do
    ~H"""
    <div phx-update="append" id="msg">
    <md-block :for={prompt <- [@prompt]} id={UUID.uuid4()}><%= prompt %></md-block>
    <md-block :for={response <- [@response]} id={UUID.uuid4()}><%= response %></md-block></div>
    <br>
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
