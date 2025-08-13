<#
.SYNOPSIS
Gets GitHub AI model IDs with optional wildcard search.

.DESCRIPTION
Fetches model IDs from GitHub's AI catalog. You can filter results using a wildcard pattern for the model name.

.PARAMETER Name
Wildcard pattern to filter model IDs. Default is '*', which returns all models.

.EXAMPLE
Get-GitHubModel -Name '*gpt*'
Returns all models with 'gpt' in their ID.

.EXAMPLE
Get-GitHubModel
Returns all models.
#>
function Get-GitHubModel {
    param(
        [string]$Name = '*',
        [switch]$Raw
    )

    $models = Invoke-RestMethod https://models.github.ai/catalog/models

    if ($Raw) {
        # Return all properties for matching models
        return $models | Select-Object -ExpandProperty id | Where-Object { $_ -like $Name } | ForEach-Object {
            $models.data | Where-Object { $_.id -eq $_ }
        }
    }
    else {
        $models.id | Where-Object { $_ -like $Name } | Sort-Object
    }
}
