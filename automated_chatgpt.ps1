# Automated ChatGPT Web Automation
# Sends questions with random timing 1-5 minutes apart

param(
    [string]$QuestionsFile = "questions.txt",
    [int]$MaxQuestions = 20
)

# Load questions from file
function Load-Questions {
    param([string]$File)
    
    if (Test-Path $File) {
        $questions = Get-Content $File | Where-Object { $_.Trim() -ne "" }
        Write-Host "Loaded $($questions.Count) questions from $File" -ForegroundColor Green
        return $questions
    } else {
        Write-Host "Questions file not found: $File" -ForegroundColor Red
        Write-Host "Creating sample questions file..." -ForegroundColor Yellow
        
        $sampleQuestions = @(
            "Write a Python function to calculate fibonacci numbers",
            "How to create a React component with TypeScript?",
            "Explain the difference between let, const, and var in JavaScript",
            "Write a SQL query to find duplicate records",
            "How to implement authentication in Node.js?",
            "Create a CSS grid layout for a responsive website",
            "Write a function to validate email addresses in Python",
            "How to use async/await in JavaScript?",
            "Explain the concept of closures in programming",
            "Write a recursive function to traverse a binary tree"
        )
        
        $sampleQuestions | Out-File -FilePath $File -Encoding UTF8
        Write-Host "Sample questions file created: $File" -ForegroundColor Green
        return $sampleQuestions
    }
}

# Get random delay between 1-5 minutes
function Get-RandomDelay {
    $minutes = Get-Random -Minimum 1 -Maximum 6
    $seconds = Get-Random -Minimum 0 -Maximum 60
    $totalSeconds = ($minutes * 60) + $seconds
    
    Write-Host "Next question in $minutes minutes $seconds seconds" -ForegroundColor Cyan
    return $totalSeconds
}

# Main automation loop
function Start-Automation {
    param([array]$Questions, [int]$MaxCount)
    
    Write-Host "=== AUTOMATED CHATGPT WEB AUTOMATION ===" -ForegroundColor Cyan
    Write-Host "Starting automation with $MaxCount questions max" -ForegroundColor Yellow
    Write-Host "Random timing: 1-5 minutes between questions" -ForegroundColor Yellow
    
    $questionCount = 0
    
    foreach ($question in $Questions) {
        if ($questionCount -ge $MaxCount) {
            Write-Host "Reached maximum question count ($MaxCount)" -ForegroundColor Yellow
            break
        }
        
        $questionCount++
        Write-Host "`n=== Question $questionCount/$MaxCount ===" -ForegroundColor Green
        Write-Host "Question: $question" -ForegroundColor White
        
        # Send question using real automation
        try {
            & ".\ui_automation_chatgpt.ps1" -Question $question -Language "txt"
            Write-Host "Question sent successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "Error sending question: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # Random delay before next question
        if ($questionCount -lt $MaxCount) {
            $delay = Get-RandomDelay
            Write-Host "Waiting $delay seconds..." -ForegroundColor Yellow
            Start-Sleep -Seconds $delay
        }
    }
    
    Write-Host "`n=== AUTOMATION COMPLETED ===" -ForegroundColor Cyan
    Write-Host "Total questions sent: $questionCount" -ForegroundColor Green
}

# Execute automation
$questions = Load-Questions $QuestionsFile
if ($questions) {
    Start-Automation $questions $MaxQuestions
} 