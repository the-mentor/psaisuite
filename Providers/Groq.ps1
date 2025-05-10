<#
.SYNOPSIS
    Invokes the Groq API to generate responses using LLM models.

.DESCRIPTION
    The Invoke-GroqProvider function sends requests to the Groq API and returns the generated content.
    It requires an API key to be set in the environment variable 'GroqKey'.

.PARAMETER ModelName
    The name of the Groq model to use (e.g., 'llama2-70b-4096', 'mixtral-8x7b-32768', 'gemma2-9b-it').
    list of models https://console.groq.com/docs/models

.PARAMETER Messages
    An array of hashtables containing the messages to send to the model.

.EXAMPLE
    $Message = New-ChatMessage -Prompt 'Explain quantum computing in simple terms'
    $response = Invoke-GroqProvider -ModelName 'llama3-70b-8192' -Message $Message 
    
.NOTES
    Requires the GroqKey environment variable to be set with a valid API key.
    Uses a fixed max_tokens value of 1024.
    Returns content from the 'content' field in the response.
    API Reference: https://console.groq.com/docs/api-reference
#>
function Invoke-GroqProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [hashtable[]]$Messages
    )
    
    $headers = @{
        'Authorization' = "Bearer $env:GroqKey"
        'Content-Type'  = 'application/json'
    }
    
    $body = @{
        'model'      = $ModelName
        'max_tokens' = 1024  # Hard-coded for Groq
        'messages'   = $Messages
    }
        
    $Uri = "https://api.groq.com/openai/v1/chat/completions"
    
    $params = @{
        Uri     = $Uri
        Method  = 'POST'
        Headers = $headers
        Body    = $body | ConvertTo-Json -Depth 10
    }
    
    try {
        $response = Invoke-RestMethod @params
        return $response.choices[0].message.content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.ErrorDetails.Message
        Write-Error "Groq API Error (HTTP $statusCode): $errorMessage"
        return "Error calling Groq API: $($_.Exception.Message)"
    }
}
