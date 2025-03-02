# PSAISuite

Simple, unified interface to multiple Generative AI providers.

`PSAISuite` makes it easy for developers to use multiple LLM through a standardized interface. Using an interface similar to OpenAI's, `PSAISuite` makes it easy to interact with the most popular LLMs and compare the results. It is a thin wrapper around the LLM endpoint, and allows creators to seamlessly swap out and test responses from different LLM providers without changing their code. Today, the library is primarily focussed on chat completions. I will expand it cover more use cases in near future.

Currently supported providers are - OpenAI, Anthropic, Google, DeepSeek, xAI

## In Action

![alt text](assets/InvokeCompletion.png)

## Installation
You can install the module from the PowerShell Gallery.

```powershell
Install-Module PSAISuite
```

## Setup
To get started, you will need API Keys for the providers you intend to use.

The API Keys need to be be set as environment variables.

Set the API keys.

```powershell
$env:OpenAIKey="your-openai-api-key"
$env:AnthropicKey="your-anthropic-api-key"
```

## Usage

Here is a short example of using `PSAISuite` to generate chat completion responses from gpt-4o and claude-3-5-sonnet.

```powershell
# Import the module
Import-Module PSAISuite

$models=@("openai:gpt-4o", "anthropic:claude-3-5-sonnet-20240620")

$prompt="What is the capital of France?"

foreach($model in $models) {
    Invoke-Completion -Prompt $prompt -Model $model
}
```

Note that the model name in the Invoke-Completion call uses the format - `<provider>:<model-name>`.

## Adding support for a provider

documentation coming soon