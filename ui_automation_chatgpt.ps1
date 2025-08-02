# UI Automation ChatGPT Web Automation
# Uses Windows UI Automation to interact with Chrome

param(
    [string]$Question = "",
    [string]$Language = "txt"
)

# Add UI Automation types
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class UIAutomationHelper {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    public const int SW_RESTORE = 9;
}
"@

# Find Chrome window with Project Test
function Find-ProjectTestWindow {
    Write-Host "Searching for Project Test window..." -ForegroundColor Yellow
    
    $chromeProcesses = Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {
        $_.MainWindowTitle -like "*Project Test*"
    }
    
    if ($chromeProcesses) {
        $process = $chromeProcesses | Select-Object -First 1
        Write-Host "Project Test found: $($process.MainWindowTitle)" -ForegroundColor Green
        return $process.MainWindowHandle
    }
    
    Write-Host "Project Test not found. Opening..." -ForegroundColor Yellow
    Start-Process "chrome.exe" -ArgumentList "--new-window", "https://chatgpt.com/g/g-p-688427888348819183c00555973ff94e-project-test/project"
    Start-Sleep -Seconds 8
    
    # Try to find again
    $chromeProcesses = Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {
        $_.MainWindowTitle -like "*Project Test*"
    }
    
    if ($chromeProcesses) {
        $process = $chromeProcesses | Select-Object -First 1
        Write-Host "Project Test opened: $($process.MainWindowTitle)" -ForegroundColor Green
        return $process.MainWindowHandle
    }
    
    return $null
}

# Activate window
function Activate-Window {
    param([IntPtr]$hWnd)
    
    if ($hWnd) {
        [UIAutomationHelper]::ShowWindow($hWnd, [UIAutomationHelper]::SW_RESTORE)
        Start-Sleep -Milliseconds 500
        [UIAutomationHelper]::SetForegroundWindow($hWnd)
        Start-Sleep -Milliseconds 500
        Write-Host "Window activated" -ForegroundColor Green
        return $true
    }
    return $false
}

# Send text using clipboard and keyboard
function Send-TextToChatGPT {
    param([string]$Text)
    
    Write-Host "Sending text to ChatGPT..." -ForegroundColor Yellow
    
    try {
        # Clear clipboard and copy text
        Set-Clipboard -Value $Text
        Start-Sleep -Milliseconds 200
        
        # Paste text (Ctrl+V)
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait("^v")
        Start-Sleep -Milliseconds 500
        
        Write-Host "Text sent successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error sending text: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Send Enter key
function Send-Enter {
    Write-Host "Sending Enter key..." -ForegroundColor Yellow
    
    try {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
        Start-Sleep -Milliseconds 500
        Write-Host "Enter sent successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error sending Enter: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Extract response using clipboard
function Extract-Response {
    Write-Host "Extracting response..." -ForegroundColor Yellow
    
    try {
        # Wait for response
        Start-Sleep -Seconds 20
        
        # Try multiple extraction methods
        for ($attempt = 1; $attempt -le 3; $attempt++) {
            Write-Host "Extraction attempt $attempt..." -ForegroundColor Gray
            
            # Method 1: Select all and copy
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.SendKeys]::SendWait("^a")
            Start-Sleep -Milliseconds 1000
            [System.Windows.Forms.SendKeys]::SendWait("^c")
            Start-Sleep -Milliseconds 1000
            
            $response = Get-Clipboard
            if ($response -and $response.Length -gt 100) {
                Write-Host "Response extracted successfully (attempt $attempt)" -ForegroundColor Green
                return $response
            }
            
            # Method 2: Try clicking in the response area first
            if ($attempt -eq 2) {
                Write-Host "Trying to click in response area..." -ForegroundColor Gray
                [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
                Start-Sleep -Milliseconds 500
                [System.Windows.Forms.SendKeys]::SendWait("{DOWN}")
                Start-Sleep -Milliseconds 500
            }
            
            # Method 3: Try different selection
            if ($attempt -eq 3) {
                Write-Host "Trying alternative selection..." -ForegroundColor Gray
                [System.Windows.Forms.SendKeys]::SendWait("{END}")
                Start-Sleep -Milliseconds 500
                [System.Windows.Forms.SendKeys]::SendWait("^a")
                Start-Sleep -Milliseconds 1000
                [System.Windows.Forms.SendKeys]::SendWait("^c")
                Start-Sleep -Milliseconds 1000
                
                $response = Get-Clipboard
                if ($response -and $response.Length -gt 100) {
                    Write-Host "Response extracted successfully (attempt $attempt)" -ForegroundColor Green
                    return $response
                }
            }
            
            Start-Sleep -Seconds 5
        }
        
        Write-Host "No response found after 3 attempts" -ForegroundColor Red
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
    
    # Clean old files (keep only last 50 pairs)
    Clean-OldRequests
}

# Clean old request files
function Clean-OldRequests {
    $outputDir = "requests"
    $maxFiles = 50
    
    if (Test-Path $outputDir) {
        # Get all files and sort by creation time (newest first)
        $allFiles = Get-ChildItem -Path $outputDir -File | Sort-Object CreationTime -Descending
        
        if ($allFiles.Count -gt $maxFiles) {
            $filesToDelete = $allFiles | Select-Object -Skip $maxFiles
            $deletedCount = 0
            
            foreach ($file in $filesToDelete) {
                Remove-Item $file.FullName -Force
                $deletedCount++
            }
            
            if ($deletedCount -gt 0) {
                Write-Host "Cleaned $deletedCount old files (keeping last $maxFiles)" -ForegroundColor Yellow
            }
        }
    }
}

# Main function
function Main {
    Write-Host "=== UI AUTOMATION CHATGPT WEB ===" -ForegroundColor Cyan
    Write-Host "Using Windows UI Automation" -ForegroundColor Yellow
    
    # Find and activate Project Test window
    $hWnd = Find-ProjectTestWindow
    if (-not $hWnd) {
        Write-Host "Could not find or open Project Test" -ForegroundColor Red
        return
    }
    
    if (-not (Activate-Window $hWnd)) {
        Write-Host "Could not activate window" -ForegroundColor Red
        return
    }
    
    # Send question
    if (-not (Send-TextToChatGPT $Question)) {
        return
    }
    
    # Send Enter
    if (-not (Send-Enter)) {
        return
    }
    
    # Extract response
    $Response = Extract-Response
    if ($Response) {
        Write-Host "Response received:" -ForegroundColor Green
        Write-Host $Response -ForegroundColor White
        
        # Save to files
        Save-Response $Question $Response $Language
    }
}

# Execute if question provided
if ($Question) {
    Main
} else {
    Write-Host "Usage: .\ui_automation_chatgpt.ps1 -Question 'your question' -Language 'txt'" -ForegroundColor Red
} 