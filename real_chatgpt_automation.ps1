# Real ChatGPT Web Automation with Selenium
# Uses Chrome to interact with ChatGPT Web interface

param(
    [string]$Question = "",
    [string]$Language = "txt"
)

# Install Selenium if not present
function Install-Selenium {
    if (-not (Get-Module -ListAvailable -Name Selenium)) {
        Write-Host "Installing Selenium module..." -ForegroundColor Yellow
        Install-Module -Name Selenium -Force -Scope CurrentUser
    }
    Import-Module Selenium
}

# Initialize Chrome WebDriver
function Initialize-ChromeDriver {
    Write-Host "Initializing Chrome WebDriver..." -ForegroundColor Yellow
    
    try {
        $ChromeDriver = Start-SeChrome -Quiet
        Write-Host "Chrome WebDriver started successfully" -ForegroundColor Green
        return $ChromeDriver
    }
    catch {
        Write-Host "Error starting Chrome WebDriver: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Navigate to Project Test
function Navigate-ToProjectTest {
    param([object]$Driver)
    
    Write-Host "Navigating to Project Test..." -ForegroundColor Yellow
    $url = "https://chatgpt.com/g/g-p-688427888348819183c00555973ff94e-project-test/project"
    
    try {
        Enter-SeUrl -Driver $Driver -Url $url
        Start-Sleep -Seconds 5
        Write-Host "Project Test loaded" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error navigating to Project Test: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Find and interact with chat input
function Send-QuestionToChatGPT {
    param([object]$Driver, [string]$Question)
    
    Write-Host "Sending question to ChatGPT..." -ForegroundColor Yellow
    
    try {
        # Wait for page to load
        Start-Sleep -Seconds 3
        
        # Find textarea for input (ChatGPT Web uses textarea)
        $textArea = Find-SeElement -Driver $Driver -By CssSelector -Value "textarea[data-id='root']"
        
        if ($textArea) {
            # Clear and send text
            Clear-SeElement -Element $textArea
            Send-SeKeys -Element $textArea -Keys $Question
            
            # Find and click send button
            $sendButton = Find-SeElement -Driver $Driver -By CssSelector -Value "button[data-testid='send-button']"
            if ($sendButton) {
                Click-SeElement -Element $sendButton
                Write-Host "Question sent successfully" -ForegroundColor Green
                return $true
            }
        }
        
        Write-Host "Could not find input elements" -ForegroundColor Red
        return $false
    }
    catch {
        Write-Host "Error sending question: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Extract response from ChatGPT
function Extract-ChatGPTResponse {
    param([object]$Driver)
    
    Write-Host "Extracting response..." -ForegroundColor Yellow
    
    try {
        # Wait for response to load
        Start-Sleep -Seconds 10
        
        # Find response elements (ChatGPT responses are in specific containers)
        $responseElements = Find-SeElements -Driver $Driver -By CssSelector -Value "[data-message-author-role='assistant']"
        
        if ($responseElements -and $responseElements.Count -gt 0) {
            $latestResponse = $responseElements[-1]
            $responseText = $latestResponse.Text
            Write-Host "Response extracted successfully" -ForegroundColor Green
            return $responseText
        }
        
        Write-Host "No response found" -ForegroundColor Red
        return ""
    }
    catch {
        Write-Host "Error extracting response: $($_.Exception.Message)" -ForegroundColor Red
        return ""
    }
}

# Save response to file
function Save-Response {
    param([string]$Question, [string]$Response, [string]$Language)
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputDir = "requests"
    
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }
    
    # Save question
    $questionFile = Join-Path $outputDir "${timestamp}_${Language}_question.txt"
    $Question | Out-File -FilePath $questionFile -Encoding UTF8
    
    # Save response
    $responseFile = Join-Path $outputDir "${timestamp}_${Language}_answer.txt"
    $Response | Out-File -FilePath $responseFile -Encoding UTF8
    
    Write-Host "Files saved:" -ForegroundColor Green
    Write-Host "  - $questionFile" -ForegroundColor Cyan
    Write-Host "  - $responseFile" -ForegroundColor Cyan
}

# Main function
function Main {
    Write-Host "=== REAL CHATGPT WEB AUTOMATION ===" -ForegroundColor Cyan
    Write-Host "Using Chrome WebDriver for real interaction" -ForegroundColor Yellow
    
    # Install and import Selenium
    Install-Selenium
    
    # Initialize Chrome
    $Driver = Initialize-ChromeDriver
    if (-not $Driver) {
        Write-Host "Failed to initialize Chrome WebDriver" -ForegroundColor Red
        return
    }
    
    try {
        # Navigate to Project Test
        if (-not (Navigate-ToProjectTest $Driver)) {
            return
        }
        
        # Send question
        if (-not (Send-QuestionToChatGPT $Driver $Question)) {
            return
        }
        
        # Extract response
        $Response = Extract-ChatGPTResponse $Driver
        if ($Response) {
            Write-Host "Response received:" -ForegroundColor Green
            Write-Host $Response -ForegroundColor White
            
            # Save to files
            Save-Response $Question $Response $Language
        }
    }
    finally {
        # Close browser
        Stop-SeDriver -Driver $Driver
        Write-Host "Chrome WebDriver closed" -ForegroundColor Yellow
    }
}

# Execute if question provided
if ($Question) {
    Main
} else {
    Write-Host "Usage: .\real_chatgpt_automation.ps1 -Question 'your question' -Language 'txt'" -ForegroundColor Red
} 