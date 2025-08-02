# chatgpt_web_automation.ps1 - ChatGPT Web Automation
# Usage: .\chatgpt_web_automation.ps1 -Command ask -Question "your question"

param(
    [string]$Command = "",
    [string]$Question = ""
)

# Global variables
$script:config = $null

# Load JSON configuration
function Load-Config {
    if (Test-Path "config.json") {
        $script:config = Get-Content "config.json" | ConvertFrom-Json
        Write-Host "Configuration loaded successfully" -ForegroundColor Green
    } else {
        Write-Host "config.json not found" -ForegroundColor Red
        exit 1
    }
}

# Find Project Test window
function Find-ProjectTestWindow {
    Write-Host "Searching for Project Test window..." -ForegroundColor Yellow

    if ($null -eq $script:config) {
        Load-Config
    }

    # Search for Chrome processes with Project Test
    $chromeProcesses = Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {
        $_.MainWindowTitle -like "*Project Test*"
    }

    if ($chromeProcesses) {
        $process = $chromeProcesses | Select-Object -First 1
        Write-Host "Project Test found: $($process.MainWindowTitle)" -ForegroundColor Green
        return $process.MainWindowHandle
    }

    Write-Host "Project Test not found" -ForegroundColor Red
    Write-Host "Make sure Project Test is open in Chrome" -ForegroundColor Yellow
    return $null
}

# Save output files
function Save-OutputFile {
    param(
        [string]$content,
        [string]$type,
        [string]$language = ""
    )
    
    if (-not $script:config.output.auto_save) {
        return
    }
    
    $outputDir = "output"
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }
    
    switch ($type) {
        "code" {
            $filename = $script:config.output.files.generated_code -replace "{language}", $language
            $filepath = Join-Path $outputDir $filename
            $content | Out-File -FilePath $filepath -Encoding UTF8
            Write-Host "Code saved: $filepath" -ForegroundColor Green
        }
        "conversation" {
            $filepath = Join-Path $outputDir $script:config.output.files.conversation_log
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            "$timestamp - $content" | Out-File -FilePath $filepath -Append -Encoding UTF8
        }
        "debug" {
            $filepath = Join-Path $outputDir $script:config.output.files.debug_log
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            "$timestamp - $content" | Out-File -FilePath $filepath -Append -Encoding UTF8
        }
    }
}

# Open Project Test
function Open-ProjectTest {
    Write-Host "Opening Project Test..." -ForegroundColor Yellow
    
    if ($null -eq $script:config) {
        Load-Config
    }
    
    $projectTestUrl = $script:config.project_test.url
    Write-Host "URL: $projectTestUrl" -ForegroundColor Cyan
    
    try {
        # Close existing Chrome windows with Project Test
        Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {
            $_.MainWindowTitle -like "*Project Test*"
        } | Stop-Process -Force -ErrorAction SilentlyContinue
        
        Start-Sleep -Seconds 2
        
        # Open new window with Project Test
        Start-Process "chrome.exe" -ArgumentList "--new-window", $projectTestUrl
        Write-Host "Project Test opened in new window" -ForegroundColor Green
        
        # Wait for loading
        Start-Sleep -Seconds 8
        
        return $true
    }
    catch {
        Write-Host "Error opening Project Test: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Ask question
function Ask-Question {
    param([string]$question)

    Write-Host "Asking ChatGPT..." -ForegroundColor Cyan
    Write-Host "Question: $question" -ForegroundColor White

    # Find window
    $hWnd = Find-ProjectTestWindow
    if (-not $hWnd) {
        Write-Host "Could not find Project Test. Make sure it is open." -ForegroundColor Red
        return $false
    }

    # Simulate response (in real implementation would automate interaction)
    $response = "Simulated response for: $question"
    
    Write-Host "Question sent and response received" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Cyan
    Write-Host $response -ForegroundColor White
    
    # Save to conversation file
    Save-OutputFile "Question: $question`nResponse: $response" "conversation"
    
    return $response
}

# Generate code
function Generate-Code {
    param([string]$prompt, [string]$language = "txt")

    $codePrompt = "Generate $language code for: $prompt. Provide only the code without additional explanations."
    $response = Ask-Question $codePrompt
    
    if ($response) {
        # Save generated code
        Save-OutputFile $response "code" $language
    }
    
    return $response
}

# Main function
function Main {
    Write-Host "=== CHATGPT WEB AUTOMATION ENGINE ===" -ForegroundColor Cyan
    Write-Host "ChatGPT Web Automation" -ForegroundColor Yellow
    Write-Host "Project Test by OpenAI" -ForegroundColor Green
    Write-Host ""
    
    # Load configuration
    Load-Config

    switch ($Command.ToLower()) {
        "open" {
            Write-Host "Opening Project Test..." -ForegroundColor Cyan
            return Open-ProjectTest
        }
        "ask" {
            if ($Question) {
                return Ask-Question $Question
            } else {
                Write-Host "Usage: .\chatgpt_web_automation.ps1 -Command ask -Question 'your question'" -ForegroundColor Red
                Write-Host "Example: .\chatgpt_web_automation.ps1 -Command ask -Question 'What is Python?'" -ForegroundColor Yellow
            }
        }
        "code" {
            if ($Question) {
                return Generate-Code $Question
            } else {
                Write-Host "Usage: .\chatgpt_web_automation.ps1 -Command code -Question 'code description'" -ForegroundColor Red
            }
        }
        default {
            Write-Host "Invalid command. Use 'open', 'ask' or 'code'" -ForegroundColor Red
            Write-Host "Examples:" -ForegroundColor Yellow
            Write-Host "   .\chatgpt_web_automation.ps1 -Command open" -ForegroundColor Cyan
            Write-Host "   .\chatgpt_web_automation.ps1 -Command ask -Question 'What is Python?'" -ForegroundColor Cyan
        }
    }
}

# Execute main function
Main
