<#
.SYNOPSIS
Gets OpenRouter models that support tools, with optional wildcard search.

.DESCRIPTION
Fetches model IDs from OpenRouter that support the "tools" parameter. You can filter results using a wildcard pattern for the model name.

.PARAMETER Name
Wildcard pattern to filter model IDs. Default is '*', which returns all models supporting tools.

.EXAMPLE
Get-OpenRouterModel -Name '*gpt*'
Returns all models with 'gpt' in their ID that support tools.

.EXAMPLE
Get-OpenRouterModel
Returns all models supporting tools.
#>
function Get-OpenRouterModel {
    param(
        [string]$Name = '*'
    )
    $models = Invoke-RestMethod https://openrouter.ai/api/v1/models

    $models.data.id | Where-Object { $_ -like $Name } | Sort-Object
}