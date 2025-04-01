# Ollama

To use Ollama with `psaisuite` you will need to download and install Ollama https://ollama.com.


## Create a Chat Completion

Install `psaisuite` from the PowerShell Gallery.

```powershell
Install-Module PSAISuite
```

In your code:

```powershell
# Import the module
Import-Module PSAISuite

$provider = "ollama"
$model_id = "deepseek-r1:latest"

# Create the model identifier
$model = "{0}:{1}" -f $provider, $model_id
$Message = New-ChatMessage -Prompt "What is the capital of France?"
Invoke-ChatCompletion -Message $Message -Model $model
```

```shell
Messages  : {"role":"user","content":"What is the capital of France?"}
Response  : The capital of France is Paris.
Model     : ollama:deepseek-r1:latest
Provider  : ollama
ModelName : deepseek-r1:latest
Timestamp : 4/1/2025 11:20:21 PM
```