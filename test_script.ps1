# Test script for ChatGPT Web Automation
param(
    [string]$Command = "",
    [string]$Question = ""
)

Write-Host "=== CHATGPT WEB AUTOMATION TEST ===" -ForegroundColor Cyan
Write-Host "Command: $Command" -ForegroundColor Yellow
Write-Host "Question: $Question" -ForegroundColor Yellow

# Load config
if (Test-Path "config.json") {
    $config = Get-Content "config.json" | ConvertFrom-Json
    Write-Host "✅ Config loaded" -ForegroundColor Green
} else {
    Write-Host "❌ config.json not found" -ForegroundColor Red
    exit 1
}

# Test functions
function Open-ProjectTest {
    Write-Host "🌐 Opening Project Test..." -ForegroundColor Yellow
    $url = $config.project_test.url
    Write-Host "🔗 URL: $url" -ForegroundColor Cyan
    
    try {
        Start-Process "chrome.exe" -ArgumentList "--new-window", $url
        Write-Host "✅ Project Test opened" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Ask-Question {
    param([string]$question)
    Write-Host "🤖 Question: $question" -ForegroundColor Cyan
    Write-Host "✅ Simulated response for: $question" -ForegroundColor Green
    return "Response: $question"
}

# Main logic
switch ($Command.ToLower()) {
    "open" {
        return Open-ProjectTest
    }
    "ask" {
        if ($Question) {
            return Ask-Question $Question
        } else {
            Write-Host "❌ Use: -Command ask -Question 'your question'" -ForegroundColor Red
        }
    }
    default {
        Write-Host "❌ Invalid command. Use 'open' or 'ask'" -ForegroundColor Red
    }
} 