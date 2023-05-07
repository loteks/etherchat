defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  @moduledoc """
  Module provides a LiveView interface to ChatGPT with PubSub to share live chats.
  """

  @doc """
  Use new random page generated in page_controller to initiate liveview mount.
  Each page is a chat with a prompt and response.
  """

  @impl true
  def mount(%{"chat" => chat}, _session, socket) do
    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(chat)
    end

    {:ok, assign(socket, chat: chat, loading: false, prompt: [], response: []), temporary_assigns: [prompt: [], response: []]}
  end

  @doc """
  Receive a prompt, send Task to OpenAI for response then share both via PubSub.
  Handle refresh event to generate new random page on demand.
  """

  @impl true
  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    ChatWeb.Endpoint.broadcast(socket.assigns.chat, "new_prompt", prompt)

    Task.Supervisor.start_child(ChatWeb.TaskSupervisor, fn ->
      response = Chat.OpenAI.send(prompt)
      ChatWeb.Endpoint.broadcast(socket.assigns.chat, "new_response", response)
    end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    {:noreply, push_navigate(socket, to: "/", replace: true)}
  end

  @impl true
  def handle_info(%{event: "new_prompt"} = msg, socket) do
    {:noreply, assign(socket, loading: true, prompt: "🧑‍💻 #{msg.payload}")}
  end

  @impl true
  def handle_info(%{event: "new_response"} = msg, socket) do
    {:noreply, assign(socket, loading: false, response: "🤖 #{msg.payload}")}
  end

  @doc """
  Find the full URL we are on.
  """

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, uri: URI.parse(uri))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div phx-update="append" id="chat">
      <md-block :for={prompt <- [@prompt]} class="mt-5 mb-5 block" id={UUID.uuid4()}>
        <%= prompt %>
      </md-block>
      <md-block :for={response <- [@response]} class="mt-5 mb-5 block" id={UUID.uuid4()}>
        <%= response %>
      </md-block>
    </div>
    <form phx-submit="prompt">
      <input type="text" name="prompt" class="input input-bordered input-lg w-full" autofocus autocomplete="off" />
    </form>
    <progress :if={@loading} class="progress progress-info w-56"></progress>
    <br />
    <p class="text-xl">Share this chat <em><%= @uri %></em></p>
    <br />
    <p class="text-lg"><button class="btn-link" phx-click="refresh">Create</button> a new chat</p>
    """
  end
end
