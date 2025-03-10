<#
.SYNOPSIS
    Invokes the Anthropic API to generate responses using Claude models.

.DESCRIPTION
    The Invoke-AnthropicProvider function sends requests to the Anthropic API and returns the generated content.
    It requires an API key to be set in the environment variable 'AnthropicKey'.

.PARAMETER ModelName
    The name of the Anthropic model to use (e.g., 'claude-3-opus', 'claude-3-sonnet', 'claude-3-haiku').

.PARAMETER Prompt
    The text prompt to send to the model.

.EXAMPLE
    $response = Invoke-AnthropicProvider -ModelName 'claude-3-opus' -Prompt 'Summarize the key events of World War II'
    
.NOTES
    Requires the AnthropicKey environment variable to be set with a valid API key.
    Uses a fixed max_tokens value of 1024.
    Returns content from the 'text' field in the response.
    API Reference: https://docs.anthropic.com/claude/reference/getting-started-with-the-api
#>
function Invoke-AnthropicProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [string]$Prompt,
        [string]$Role = 'user'
    )
    
    $headers = @{
        'x-api-key'         = $env:AnthropicKey
        'anthropic-version' = '2023-06-01'
        'content-type'      = 'application/json'
    }
    
    $body = @{
        'model'      = $ModelName
        'max_tokens' = 1024  # Hard-coded for Anthropic
        'messages'   = @(
            @{
                'role'    = $Role
                'content' = $Prompt
            }
        )
    }
        
    $Uri = "https://api.anthropic.com/v1/messages"
    
    $params = @{
        Uri     = $Uri
        Method  = 'POST'
        Headers = $headers
        Body    = $body | ConvertTo-Json -Depth 10
    }
    
    try {
        $response = Invoke-RestMethod @params
        return $response.content.text
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.ErrorDetails.Message
        Write-Error "Anthropic API Error (HTTP $statusCode): $errorMessage"
        return "Error calling Anthropic API: $($_.Exception.Message)"
    }
}
