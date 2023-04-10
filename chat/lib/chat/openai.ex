defmodule Chat.OpenAI do
  @default_config %{
    model: "gpt-3.5-turbo",
    api_key: "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",
    url: "https://api.openai.com/v1/chat/completions",
    max_tokens: 3500,
    system_message: %{
      role: "system",
      content:
        "you are a programming assistant helping developers write apps in elixir and phoenix."
    }
  }

  def callAPI(prompt, config \\ @default_config) do
    messages =
      [
        %{role: "user", content: prompt},
        config.system_message
      ]
      |> Enum.reverse()
      |> List.flatten()

    body = %{model: config.model, messages: messages, max_tokens: config.max_tokens}

    headers = [
      Authorization: "Bearer #{config.api_key}",
      "Content-Type": "Application/json; Charset=utf-8"
    ]

    response_body =
      Req.post!(config.url, headers: headers, json: body, receive_timeout: 500_000).body

    %{
      "choices" => [
        %{
          "message" => %{
            "content" => content
          }
        }
      ]
    } = response_body

    # [%{role: "assistant", content: content}, %{role: "user", content: prompt} | history]
    # |> Enum.reverse()

    content
  end
end
