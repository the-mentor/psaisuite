BeforeAll {
    # Import the module to test
    $ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    
    # Mock provider functions for testing - Define them before importing the module
    function global:Invoke-openaiprovider { param($model, $prompt) return "OpenAI Response: $prompt" }
    function global:Invoke-anthropicprovider { param($model, $prompt) return "Anthropic Response: $prompt" }
    
    # Now import the module
    Import-Module "$ProjectRoot\PSAISuite.psd1" -Force
}

Describe "Invoke-Completion" {
    Context "Basic functionality" {
        It "Returns a string when TextOnly is specified" {
            $result = Invoke-Completion -Prompt "Test prompt" -TextOnly
            $result | Should -BeOfType [string]
        }
        
        It "Returns an object when TextOnly is not specified" {
            $result = Invoke-Completion -Prompt "Test prompt" 
            $result | Should -BeOfType [PSCustomObject]
            $result.Response | Should -BeOfType [string]
            $result.Prompt | Should -Be "Test prompt"
            $result.Provider | Should -Be "openai"
            $result.Model | Should -Be "openai:gpt-4o-mini"
            $result.ModelName | Should -Be "gpt-4o-mini"
            $result.Timestamp | Should -Not -BeNullOrEmpty
        }
        
        It "Uses default model when not specified" {
            $result = Invoke-Completion -Prompt "Test prompt"
            $result.Model | Should -Be "openai:gpt-4o-mini"
        }
        
        It "Correctly parses custom provider and model" {
            Mock -CommandName Invoke-anthropicprovider -MockWith { param($model, $prompt) return "Anthropic Response: $prompt" } -ModuleName PSAISuite
            
            $result = Invoke-Completion -Prompt "Test prompt" -Model "anthropic:claude-3-haiku"
            $result.Provider | Should -Be "anthropic"
            $result.ModelName | Should -Be "claude-3-haiku"
            $result.Response | Should -Be "Anthropic Response: Test prompt"
        }
    }

    Context "Elapsed time measurement" {
        It "Includes elapsed time when IncludeElapsedTime is specified" {
            $result = Invoke-Completion -Prompt "Test prompt" -IncludeElapsedTime
            $result.ElapsedTime | Should -Not -BeNullOrEmpty
        }
        
        It "Includes elapsed time in text output when TextOnly is specified" {
            $result = Invoke-Completion -Prompt "Test prompt" -IncludeElapsedTime -TextOnly
            $result | Should -Match "Elapsed Time:"
        }
    }
    
    Context "Error handling" {
        It "Throws an error when using incorrect model format" {
            { Invoke-Completion -Prompt "Test" -Model "invalid-model-format" } | 
            Should -Throw "Model must be specified in 'provider:model' format."
        }
        
        It "Throws an error when using an unsupported provider" {
            { Invoke-Completion -Prompt "Test" -Model "nonexistent:model" } | 
            Should -Throw "Unsupported provider: nonexistent. No function named Invoke-nonexistentProvider found."
        }
    }
}