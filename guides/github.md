# GitHub Provider Guide

This guide provides instructions on how to use the GitHub provider with `PSAISuite`. Visit the official [GitHub Personal Access Token](https://docs.github.com/en/enterprise-server@3.16/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) to create a personal access token.

## Setup

To use the GitHub provider, you need a GitHub token with the necessary permissions to access the models API.

Set the `GITHUB_TOKEN` environment variable:

```powershell
$env:GITHUB_TOKEN = "your-github-token"
```

# Create a Chat Completion

Install `psaisuite` from the PowerShell Gallery.

```powershell
Install-Module PSAISuite
```

In your code:

```powershell
# Import the module
Import-Module PSAISuite

Invoke-ChatCompletion 'capital of france' github:phi-4
```

```shell
Messages  : {"role":"user","content":"capital of france"}
Response  : The capital of France is Paris. It is the largest city in the country and serves as a major cultural,
            economic, and political center both in France and internationally. Paris is renowned for its rich history,
            iconic landmarks such as the Eiffel Tower, Notre-Dame Cathedral, and the Louvre Museum, as well as its
            influence on arts, fashion, and cuisine.
Model     : github:phi-4
Provider  : github
ModelName : phi-4
Timestamp : Sat 04 12 2025 8:20:22 AM
```