# Test cleanup functionality
param([int]$MaxFiles = 50)

Write-Host "=== TESTING CLEANUP FUNCTIONALITY ===" -ForegroundColor Cyan

# Clean old request files
function Clean-OldRequests {
    param([int]$maxFiles = 50)
    
    $outputDir = "requests"
    
    if (Test-Path $outputDir) {
        # Get all files and sort by creation time (newest first)
        $allFiles = Get-ChildItem -Path $outputDir -File | Sort-Object CreationTime -Descending
        
        Write-Host "Current files: $($allFiles.Count)" -ForegroundColor Yellow
        
        if ($allFiles.Count -gt $maxFiles) {
            $filesToDelete = $allFiles | Select-Object -Skip $maxFiles
            $deletedCount = 0
            
            Write-Host "Files to delete: $($filesToDelete.Count)" -ForegroundColor Red
            
            foreach ($file in $filesToDelete) {
                Write-Host "Would delete: $($file.Name)" -ForegroundColor Gray
                # Remove-Item $file.FullName -Force
                $deletedCount++
            }
            
            if ($deletedCount -gt 0) {
                Write-Host "Would clean $deletedCount old files (keeping last $maxFiles)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "No cleanup needed (files: $($allFiles.Count), max: $maxFiles)" -ForegroundColor Green
        }
        
        # Show oldest and newest files
        if ($allFiles.Count -gt 0) {
            Write-Host "`nOldest file: $($allFiles[-1].Name)" -ForegroundColor Gray
            Write-Host "Newest file: $($allFiles[0].Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "No requests directory found" -ForegroundColor Red
    }
}

# Test with different max values
Write-Host "`nTesting with max $MaxFiles files:" -ForegroundColor Yellow
Clean-OldRequests -maxFiles $MaxFiles

Write-Host "`nTesting with max 5 files:" -ForegroundColor Yellow
Clean-OldRequests -maxFiles 5

Write-Host "`n=== CLEANUP TEST COMPLETED ===" -ForegroundColor Cyan 