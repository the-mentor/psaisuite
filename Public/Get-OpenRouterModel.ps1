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
        [string]$Name = '*',
        [int]$LastWeeks = 0,
        [switch]$Raw
    )

    $models = Invoke-RestMethod https://openrouter.ai/api/v1/models

    if ($Raw) {
        # Return all properties for matching models
        $matchingModels = $models.data | Where-Object { $_.id -like $Name }
        if ($LastWeeks -gt 0) {
            $today = Get-Date
            $threeWeeksAgo = $today.AddDays( - $($LastWeeks * 7))
            $matchingModels = $matchingModels | Where-Object {
                $modelDate = Get-Date ([datetime]::UnixEpoch.AddSeconds($_.created)).ToString("yyyy-MM-dd")
                $modelDate -ge $threeWeeksAgo -and $modelDate -le $today
            }
        }
        return $matchingModels
    } else {
        $foundModels = foreach ($model in $models.data) {
            if ($model.id -like $Name) {
                [PSCustomObject]@{
                    Id      = $model.id
                    Created = Get-Date ([datetime]::UnixEpoch.AddSeconds($model.created)).ToString("yyyy-MM-dd")
                }
            }
        }

        $today = Get-Date            
        $threeWeeksAgo = $today.AddDays( - $($LastWeeks * 7))
        if ($LastWeeks -eq 0) {
            return $foundModels
        }
        $foundModels | Where-Object {
            $modelDate = $_.Created
            $modelDate -ge $threeWeeksAgo -and $modelDate -le $today
        } | Sort-Object Created
    }
}