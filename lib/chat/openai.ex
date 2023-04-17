defmodule Chat.OpenAI do
  use GenServer

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
    gpt3 = "gpt-3.5-turbo"
    # gpt4 = "gpt-4"

    with msgs <- msgs ++ [new_msg(m)] do
      case ExOpenAI.Chat.create_chat_completion(msgs, gpt3) do
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
    GenServer.call(:gptserver, {:msg, msg}, 50000)
  end
end
