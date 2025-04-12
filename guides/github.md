# GitHub Provider Guide

This guide provides instructions on how to use the GitHub provider with `PSAISuite`. Visit the official [GitHub Personal Access Token](https://docs.github.com/en/enterprise-server@3.16/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) to create a personal access token.

## Setup

To use the GitHub provider, you need a GitHub token with the necessary permissions to access the models API.

Set the `GITHUB_TOKEN` environment variable:

```powershell
$env:GITHUB_TOKEN = "your-github-token"
```

Replace `"your-github-token"` with your actual GitHub token.

## Available Models

GitHub offers various models. As of the last update, models like `gpt-4o-mini` were available via their inference endpoint. Model availability and names might change, so refer to official GitHub documentation for the most current list.

## Usage Example

```powershell
# Ensure the GITHUB_TOKEN environment variable is set

# Invoke the GitHub provider
Invoke-ChatCompletion 'capital of france' github:gpt-4o-mini
```

This example sends a prompt to the `gpt-4o-mini` model via the GitHub provider and displays the response.