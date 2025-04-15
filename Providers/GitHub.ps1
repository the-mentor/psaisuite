<#
.SYNOPSIS
    Invokes the GitHub Models API to generate responses using specified models.

.DESCRIPTION
    The Invoke-GitHubProvider function sends requests to the GitHub Models API and returns the generated content.
    It requires a GitHub token to be set in the environment variable 'GithubKey'.

.PARAMETER ModelName
    The name of the GitHub model to use (e.g., 'gpt-4o-mini'). Note: Model availability might change.

.PARAMETER Messages
    An array of hashtables containing the messages to send to the model.

.EXAMPLE
    $Message = New-ChatMessage -Prompt 'Explain quantum computing in simple terms'
    $response = Invoke-GitHubProvider -ModelName 'gpt-4o-mini' -Messages $Message

.NOTES
    Requires the GithubKey environment variable to be set with a valid GitHub token with appropriate permissions.
    The API endpoint used is 'https://models.inference.ai.azure.com/chat/completions'. This might be subject to change.
#>
function Invoke-GitHubProvider {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [hashtable[]]$Messages
    )

    if (-not $env:GithubKey) {
        Write-Error "Please set the GithubKey environment variable with a valid GitHub token."
        return
    }

    $headers = @{
        "Content-Type"  = "application/json"
        "Authorization" = "Bearer $($env:GithubKey)"
    }

    $body = @{
        "messages" = $Messages
        "model"    = $ModelName
    }

    # Note: This endpoint might change. Refer to official GitHub documentation if issues arise.
    $Uri = "https://models.inference.ai.azure.com/chat/completions"

    $params = @{
        Uri     = $Uri
        Method  = 'POST'
        Headers = $headers
        Body    = $body | ConvertTo-Json -Depth 10
    }

    try {
        $response = Invoke-RestMethod @params
        # Assuming the response structure is similar to OpenAI's
        return $response.choices[0].message.content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.ErrorDetails.Message
        Write-Error "GitHub Models API Error (HTTP $statusCode): $errorMessage"
        return "Error calling GitHub Models API: $($_.Exception.Message)"
    }
}
