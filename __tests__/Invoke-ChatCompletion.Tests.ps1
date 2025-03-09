BeforeAll {
    # Import the module to test
    $ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
    Import-Module "$ProjectRoot\PSAISuite.psd1" -Force
}

Describe "Invoke-ChatCompletion" {
    BeforeEach {
        # Set up mocks for the provider functions in the PSAISuite module scope
        Mock -ModuleName PSAISuite Invoke-OpenAIProvider { param($model, $prompt) return "OpenAI Response: $prompt" }
        Mock -ModuleName PSAISuite Invoke-AnthropicProvider { param($model, $prompt) return "Anthropic Response: $prompt" }
    }

    Context "Basic functionality" {
        It "Returns text only when TextOnly switch is used" {
            $result = Invoke-ChatCompletion -Prompt "Test prompt" -TextOnly
            $result | Should -BeOfType [string]
            # Should -Invoke -ModuleName PSAISuite Invoke-OpenAIProvider -Times 1 -Exactly
        }

        It "Returns object by default" {
            $result = Invoke-ChatCompletion -Prompt "Test prompt" 
            $result | Should -BeOfType [PSCustomObject]
            $result.Prompt | Should -Be "Test prompt"
            $result.Response | Should -Not -BeNullOrEmpty
            $result.Timestamp | Should -BeOfType [DateTime]
            # Should -Invoke -ModuleName PSAISuite Invoke-OpenAIProvider -Times 1 -Exactly
        }

        It "Uses default model when not specified" {
            $result = Invoke-ChatCompletion -Prompt "Test prompt"
            $result.Model | Should -Be "openai:gpt-4o-mini"
            # Should -Invoke -ModuleName PSAISuite Invoke-OpenAIProvider -Times 1 -Exactly -ParameterFilter { 
            #     $model -eq "gpt-4o-mini" -and $prompt -eq "Test prompt" 
            # }
        }

        It "Uses specified model when provided" {
            $result = Invoke-ChatCompletion -Prompt "Test prompt" -Model "anthropic:claude-3-sonnet-20240229"
            $result.Model | Should -Be "anthropic:claude-3-sonnet-20240229"
            $result.Provider | Should -Be "anthropic"
            $result.ModelName | Should -Be "claude-3-sonnet-20240229"
            # Should -Invoke -ModuleName PSAISuite Invoke-AnthropicProvider -Times 1 -Exactly -ParameterFilter {
            #     $model -eq "claude-3-sonnet-20240229" -and $prompt -eq "Test prompt"
            # }
        }
    }

    Context "Elapsed time tracking" {
        It "Includes elapsed time in object when requested" {
            $result = Invoke-ChatCompletion -Prompt "Test prompt" -IncludeElapsedTime
            $result.ElapsedTime | Should -BeOfType [TimeSpan]
        }

        It "Includes elapsed time in text when TextOnly and IncludeElapsedTime are used" {
            $result = Invoke-ChatCompletion -Prompt "Test prompt" -IncludeElapsedTime -TextOnly
            $result | Should -Match "Elapsed Time: \d{2}:\d{2}:\d{2}\.\d{3}"
        }
    }

    Context "Error handling" {
        It "Throws error for invalid model format" {
            { Invoke-ChatCompletion -Prompt "Test" -Model "invalid-model-format" } | 
            Should -Throw "Model must be specified in 'provider:model' format."
        }

        It "Throws error for nonexistent provider" {
            { Invoke-ChatCompletion -Prompt "Test" -Model "nonexistent:model" } | 
            Should -Throw "Unsupported provider: nonexistent. No function named Invoke-nonexistentProvider found."
        }
    }
}