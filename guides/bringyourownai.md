# BringYourOwnAI

The BringYourOwnAI provider is a bit different then the other providers in `psaisuite`.
The BringYourOwnAI provider allows you to use any OpenAI compatible API by defining the API URL via an environment variable.

> **Note:** You will need to figure out the exact API URL yourself based on the service you are using.


```shell
$env:BringYourOwnAIKey = "your-BringYourOwnAI-api-key"
$env:BringYourOwnAIURI = "https://some-api-url/v1/chat/completions"
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

$provider = "bringyourownai"
$model_id = "openai.gpt-4o"

# Create the model identifier
$model = "{0}:{1}" -f $provider, $model_id
$Message = New-ChatMessage -Prompt "What is the capital of France?"
Invoke-ChatCompletion -Message $Message -Model $model
```

```shell
Messages  : {"role":"user","content":"What is the capital of France?"}
Response  : The capital of France is Paris. Paris is known for its iconic landmarks such as the Eiffel Tower, the Louvre Museum, and Notre-Dame Cathedral. It is also the largest city in France.
Model     : bringyourownai:openai.gpt-4o
Provider  : bringyourownai
ModelName : openai.gpt-4o
Timestamp : 4/9/2025 11:11:11 PM
```

