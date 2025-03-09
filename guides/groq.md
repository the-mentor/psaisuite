# Groq

To use Groq with `psaisuite` you will need to [create a free account](https://console.groq.com/). Once logged in, go to the [API Keys](https://console.groq.com/keys) section in your account settings and generate a new Groq API key. Once you have your key, add it to your environment as follows:

```shell
$env:GroqKey = "your-groq-api-key"
```

## Create a Chat Completion

Install `psaisuite` from the PowerShell Gallery.

```powershell
Install-Module PSAISuite
```

In your code:

```powershell
# Import the module
Import-Module PSAISuite

$provider = "groq"
$model_id = "llama-3.2-8b-instruct"

# Create the model identifier
$model = "{0}:{1}" -f $provider, $model_id

Invoke-Completion -Prompt "What is the capital of France?" -Model $model
```

```shell
Prompt    : What is the capital of France?
Response  : The capital of France is Paris.
Model     : groq:llama-3.2-8b-instruct
Provider  : groq
ModelName : llama-3.2-8b-instruct
Timestamp : Sun 03 09 2025 10:15:30 AM
```