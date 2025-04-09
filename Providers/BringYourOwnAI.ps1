<#
.SYNOPSIS
    Invokes the BringYourOwnAI API to generate responses using specified models.

.DESCRIPTION
    The Invoke-BringYourOwnAIProvider function sends requests to the BringYourOwnAI API and returns the generated content.
    It requires an API key to be set in the environment variable 'BringYourOwnAIKey'.

.PARAMETER ModelName
    The name of the BringYourOwnAI model to use (e.g., 'google/gemini-2.5-pro-preview-03-25', 'openai/gpt-4o').

.PARAMETER Messages
    An array of hashtables containing the messages to send to the model.

.EXAMPLE
    $Message = New-ChatMessage -Prompt 'Write a PowerShell function to calculate factorial'
    $response = Invoke-BringYourOwnAIProvider -ModelName 'BringYourOwnAI:google/gemini-2.5-pro-preview-03-25' -Message $Message
    
.NOTES
#>
function Invoke-BringYourOwnAIProvider {
    param(
        [Parameter(Mandatory)]
        [string]$ModelName,
        [Parameter(Mandatory)]
        [hashtable[]]$Messages
    )
    
    $headers = @{
        'Authorization' = "Bearer $env:BringYourOwnAIKey"        
        'content-type'  = 'application/json'
    }
    
    $body = @{
        'model'    = $ModelName
        'messages' = $Messages
    }

    $Uri = $env:BringYourOwnAIURI
    
    $params = @{
        Uri     = $Uri
        Method  = 'POST'
        Headers = $headers
        Body    = $body | ConvertTo-Json -Depth 10
    }
    
    try {
        $response = Invoke-RestMethod @params
        if ($response.Error) {
            Write-Error "BringYourOwnAI API Error: $($response.Error)"
            return "Error calling BringYourOwnAI API: $($response.Error)"
        }
        return $response.choices[0].message.content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.ErrorDetails.Message
        Write-Error "BringYourOwnAI API Error (HTTP $statusCode): $errorMessage"
        return "Error calling BringYourOwnAI API: $($_.Exception.Message)"
    }
}
