<#
.SYNOPSIS
    Invokes the Azure AI Foundry API to generate responses using specified models.

.DESCRIPTION
    The Invoke-AzureAIProvider function sends requests to the Azure AI Foundry API and returns the generated content.
    It requires an API key to be set in the environment variable 'AzureAIKey' and an endpoint URL in 'AzureAIEndpoint'.

.PARAMETER ModelName
    The name of the Azure AI model to use (e.g., 'gpt-4', 'gpt-35-turbo').
    Models available depend on your deployment configuration in Azure AI Studio.

.PARAMETER Prompt
    The text prompt to send to the model.

.EXAMPLE
    $response = Invoke-AzureAIProvider -ModelName 'gpt-4' -Prompt 'Explain quantum computing'
    
.NOTES
    Requires the AzureAIKey environment variable to be set with a valid API key.
    Requires the AzureAIEndpoint environment variable to be set with your Azure AI endpoint.
    API Reference: https://learn.microsoft.com/en-us/azure/ai-services/openai/
#>
function Invoke-AzureAIProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [string]$Prompt
    )
    
    if (-not $env:AzureAIKey) {
        throw "Azure AI API key not found. Please set the AzureAIKey environment variable."
    }
    
    if (-not $env:AzureAIEndpoint) {
        throw "Azure AI endpoint not found. Please set the AzureAIEndpoint environment variable."
    }
    
    $apiKey = $env:AzureAIKey
    $endpoint = $env:AzureAIEndpoint.TrimEnd('/')
    
    # Construct the body based on the Azure OpenAI API format
    $body = @{
        'messages'    = @(
            @{
                'role'    = 'user'
                'content' = $Prompt
            }
        )
        'max_tokens'  = 800
        'temperature' = 0.7
    }

    # Azure AI uses the API key in the header as api-key
    $Uri = "$endpoint/openai/deployments/$ModelName/chat/completions?api-version=2023-05-15"
    
    $params = @{
        Uri     = $Uri
        Method  = 'POST'
        Headers = @{
            'api-key'      = $apiKey
            'Content-Type' = 'application/json'
        }
        Body    = $body | ConvertTo-Json -Depth 10
    }
    
    try {
        $response = Invoke-RestMethod @params
        # Azure OpenAI has a response structure similar to OpenAI
        return $response.choices[0].message.content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.ErrorDetails.Message
        Write-Error "Azure AI API Error (HTTP $statusCode): $errorMessage"
        return "Error calling Azure AI API: $($_.Exception.Message)"
    }
}
