defmodule Chat.OpenAI do
  use GenServer

  Application.put_env(:ex_openai, :api_key, "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")
  Application.put_env(:ex_openai, :http_options, recv_timeout: 50_000)

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
    with msgs <- msgs ++ [new_msg(m)] do
      case ExOpenAI.Chat.create_chat_completion(msgs, "gpt-3.5-turbo") do
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
