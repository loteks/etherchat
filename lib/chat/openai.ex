defmodule Chat.OpenAI do
  use GenServer

  @moduledoc """
  Module implements GenServer interface to ExOpenAI library to save msg state.

  Requires OPENAI_API_KEY and OPENAI_ORGANIZATION_KEY in Environment.

  gpt-3.5-turbo is default. To select gpt-4 comment out gpt = "gpt-3.5-turbo"
  and uncomment gpt = "gpt-4" below, then restart app to reset genserver.
  """

  @impl true
  def init(_opts) do
    {:ok, []}
  end

  defp new_msg(m) do
    %ExOpenAI.Components.ChatCompletionRequestMessage{
      content: m,
      role: :user,
      name: "user"
    }
  end

  @impl true
  def handle_call({:msg, m}, _from, msgs) do
    gpt = "gpt-3.5-turbo"
    # gpt = "gpt-4"

    with msgs <- msgs ++ [new_msg(m)] do
      case ExOpenAI.Chat.create_chat_completion(msgs, gpt) do
        {:ok, res} ->
          first = List.first(res.choices)
          {:reply, first.message.content, msgs ++ [first.message]}

        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: :gptserver)
  end

  def send(msg) do
    GenServer.call(:gptserver, {:msg, msg}, 50_000)
  end
end
