# Piping Data into Invoke-ChatCompletion

The `Invoke-ChatCompletion` command in PSAISuite supports piping data directly into the function as context. This allows you to use the output of any command or file as additional context for your chat prompt.

## How It Works
- Any data piped into `Invoke-ChatCompletion` is treated as context and prepended to your main prompt message.
- The context is sent as a user message before your main prompt, giving the AI model more information.

## Examples

### Pipe File Content as Context
```powershell
Get-Content .\README.md | Invoke-ChatCompletion -Messages "Summarize this document." -Model "openai:gpt-4o-mini"
```

### Pipe a String as Context
```powershell
"This is context from the pipeline" | Invoke-ChatCompletion -Messages "Explain the context." -Model "openai:gpt-4o-mini"
```

### Pipe Command Output as Context
```powershell
Get-Process | Out-String | Invoke-ChatCompletion -Messages "What processes are running?" -Model "openai:gpt-4o-mini"
```

## Notes
- The piped context is always prepended to the messages you provide via the `-Messages` parameter.
 - You can use this feature to summarize, analyze, or ask questions about any data accessible from PowerShell.

## Tip: Use the `icc` Alias

You can use the shorter `icc` alias instead of typing `Invoke-ChatCompletion`:

```powershell
icc -Messages "Your prompt here" -Model "openai:gpt-4o-mini"
```

All examples above work the same way with `icc`.

### Model Parameter Tab Completion

When using the `-Model` parameter with `icc` (or `Invoke-ChatCompletion`), you can use tab completion to quickly select available providers and models. Start typing a provider (like `openai:` or `github:`) and press `Tab` to see suggestions.

---
For more details, see the `Invoke-ChatCompletion` help or the main documentation.
