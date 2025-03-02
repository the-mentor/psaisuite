<#
.SYNOPSIS
    Invokes the DeepSeek API to generate responses using specified models.

.DESCRIPTION
    The Invoke-DeepSeekProvider function sends requests to the DeepSeek API and returns the generated content.
    It requires an API key to be set in the environment variable 'DeepSeekKey'.

.PARAMETER ModelName
    The name of the DeepSeek model to use (e.g., 'deepseek-chat', 'deepseek-coder').

.PARAMETER Prompt
    The text prompt to send to the model.

.EXAMPLE
    $response = Invoke-DeepSeekProvider -ModelName 'deepseek-coder' -Prompt 'Write a binary search algorithm in Python'
    
.NOTES
    Requires the DeepSeekKey environment variable to be set with a valid API key.
    API Reference: https://platform.deepseek.com/docs
#>
function Invoke-DeepSeekProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [string]$Prompt
    )
    
    $headers = @{
        'Authorization' = "Bearer $env:DeepSeekKey"
        'content-type'  = 'application/json'
    }
    
    $body = @{
        'model'    = $ModelName
        'messages' = @(
            @{
                'role'    = 'user'
                'content' = $Prompt
            }
        )
    }

    $Uri = "https://api.deepseek.com/v1/chat/completions"
    
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
        Write-Error "DeepSeek API Error (HTTP $statusCode): $errorMessage"
        return "Error calling DeepSeek API: $($_.Exception.Message)"
    }
}
