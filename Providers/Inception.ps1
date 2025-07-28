
<#
.SYNOPSIS
    Invokes the Inception API to generate responses using specified models.

.DESCRIPTION
    The Invoke-InceptionProvider function sends requests to the Inception API and returns the generated content.
    It requires an API key to be set in the environment variable 'INCEPTION_API_KEY'.

.PARAMETER ModelName
    The name of the Inception model to use (e.g., 'mercury-coder').

.PARAMETER Messages
    An array of hashtables containing the messages to send to the model.

.EXAMPLE
    $Message = New-ChatMessage -Prompt 'What is a diffusion model?'
    $response = Invoke-InceptionProvider -ModelName 'mercury-coder' -Messages $Message

.NOTES
    Requires the INCEPTION_API_KEY environment variable to be set with a valid API key.
    API Reference: https://docs.inceptionlabs.ai/
#>
function Invoke-InceptionProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [hashtable[]]$Messages
    )

    $headers = @{
        'Authorization' = "Bearer $env:INCEPTION_API_KEY"
        'Content-Type'  = 'application/json'
    }

    $body = @{
        'model'    = $ModelName
        'messages' = $Messages
    }

    $Uri = "https://api.inceptionlabs.ai/v1/chat/completions"

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
        Write-Error "Inception API Error (HTTP $statusCode): $errorMessage"
        return "Error calling Inception API: $($_.Exception.Message)"
    }
}