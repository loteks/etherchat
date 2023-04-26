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

    Task.Supervisor.start_child(ChatWeb.TaskSupervisor, fn ->
      response = Chat.OpenAI.send(prompt)
      ChatWeb.Endpoint.broadcast(socket.assigns.topic, "msg", response)
    end)

    {:noreply, socket}
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, push_navigate(socket, to: "/", replace: true)}
  end

  def handle_info(%{event: "msg"} = msg, socket) do
    {:noreply, assign(socket, prompt: msg.payload)}
  end

  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, uri: URI.parse(uri))}
  end

  def render(assigns) do
    ~H"""
    <div phx-update="append" id="msg">
    <md-block :for={prompt <- [@prompt]} id={UUID.uuid4()}><%= prompt %></md-block></div>
    <div phx-update="append" id="msg">
    <md-block :for={response <- [@response]} id={UUID.uuid4()}><%= response %></md-block></div>
    <br>
    <form phx-submit="prompt">
      <input
        type="text"
        name="prompt"
        placeholder="Ask Neubot a question..."
        class="input input-bordered input-lg w-full"
        autofocus
        autocomplete="off"
      />
    </form>
    <br>
    <p class="text-xl">You are chatting with Neubot at <em><%= @uri %></em></p>
    <br>
    <p class="text-lg">
    <button
      class="btn-link"
      phx-click="refresh">Generate</button> a new private chat page</p>
    """
  end
end
