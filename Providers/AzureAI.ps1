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

.PARAMETER SystemRole
    This parameter allows you to overwrite the default system role by passing a     
    hashtable containing the system role information with keys 'role' and 'content'.

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
        [string]$Prompt,
        [ValidateScript({
            if ($_ -is [hashtable] -and $_.ContainsKey('role') -and $_.ContainsKey('content')) {
                return $true
            }
            else {
                throw "SystemRole must be a hashtable with keys 'role' and 'content'."
            }
        })]
        [hashtable]$SystemRole
    )
    
    if (-not $env:AzureAIKey) {
        throw "Azure AI API key not found. Please set the AzureAIKey environment variable."
    }
    
    if (-not $env:AzureAIEndpoint) {
        throw "Azure AI endpoint not found. Please set the AzureAIEndpoint environment variable."
    }
    
    $apiKey = $env:AzureAIKey
    $endpoint = $env:AzureAIEndpoint.TrimEnd('/')
    
    # Determine API version based on the model
    $apiVersion = "2023-05-15"
    # Special handling for o3-mini model which requires a newer API version
    if ($ModelName -eq "o3-mini") {
        $apiVersion = "2024-12-01-preview"
    }
    
    # Construct the body based on the Azure OpenAI API format
    $body = @{
        'messages' = @(
            if($SystemRole) {
                $SystemRole
            }
            @{
                'role'    = 'user'
                'content' = $Prompt
            }
        )
        'max_completion_tokens' = 800
        # Removed temperature parameter as the API only supports the default value (1)
    }

    # Azure AI uses the API key in the header as api-key
    $Uri = "$endpoint/openai/deployments/$ModelName/chat/completions?api-version=$apiVersion"
    
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
