defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(%{"room_id" => room_id}, _session, socket) do
    {:ok, assign(socket, room: room_id, prompt: "", response: "", history: []),
     temporary_assigns: [history: []]}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    IO.inspect(prompt, label: "PROMPT")

    response = Chat.OpenAI.send(prompt)
    IO.inspect(response, label: "RESPONSE")

    history = [prompt, response]
    IO.inspect(history, label: "HISTORY")

    socket = assign(socket, prompt: prompt, response: response, history: history)
    IO.inspect(socket, label: "SOCKET")

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div phx-update="append" id="msg">
    <pre :for={msg <- @history} id={"msg-#{msg}"}><%= msg %></pre></div>
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
