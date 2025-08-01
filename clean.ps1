# clean.ps1 - Script de limpieza optimizado para el proyecto
# Uso: .\clean.ps1 [tipo]

param(
    [string]$Type = "all"
)

Write-Host "🧹 SISTEMA DE LIMPIEZA OPTIMIZADO" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Configuración
$ProjectRoot = Get-Location
$BackupFolder = ".\backup\$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"

# Función para crear backup
function New-Backup {
    param([string]$Folder)

    if (-not (Test-Path $BackupFolder)) {
        New-Item -ItemType Directory -Path $BackupFolder -Force | Out-Null
    }

    if (Test-Path $Folder) {
        $backupPath = Join-Path $BackupFolder (Split-Path $Folder -Leaf)
        Copy-Item -Path $Folder -Destination $backupPath -Recurse -Force
        Write-Host "📦 Backup creado: $backupPath" -ForegroundColor Green
    }
}

# Función para limpiar con confirmación
function Remove-ItemsSafely {
    param(
        [string]$Pattern,
        [string]$Description
    )

    $items = Get-ChildItem -Path $ProjectRoot -Filter $Pattern -Recurse -ErrorAction SilentlyContinue

    if ($items.Count -gt 0) {
        Write-Host "🗑️  Encontrados $($items.Count) $Description" -ForegroundColor Yellow

        foreach ($item in $items) {
            Write-Host "   📄 $($item.Name) - $($item.Length) bytes" -ForegroundColor Gray
        }

        $confirm = Read-Host "¿Eliminar estos archivos? (y/N)"
        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            $items | Remove-Item -Force -Recurse
            Write-Host "✅ $Description eliminados" -ForegroundColor Green
        } else {
            Write-Host "⏭️  Saltando $Description" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✅ No se encontraron $Description" -ForegroundColor Green
    }
}

# Función para limpiar ejecutables
function Clear-Executables {
    Write-Host "🔧 Limpiando ejecutables..." -ForegroundColor Cyan

    $executables = @(
        "*.exe",
        "*.obj",
        "*.o",
        "*.a",
        "*.lib",
        "*.dll"
    )

    foreach ($pattern in $executables) {
        Remove-ItemsSafely -Pattern $pattern -Description "archivos compilados ($pattern)"
    }
}

# Función para limpiar archivos generados
function Clear-GeneratedFiles {
    Write-Host "📄 Limpiando archivos generados..." -ForegroundColor Cyan

    $generated = @(
        "generated_code.*",
        "capture_*.bmp",
        "screenshot_*.png",
        "screenshot_*.jpg",
        "*.log",
        "*.tmp"
    )

    foreach ($pattern in $generated) {
        Remove-ItemsSafely -Pattern $pattern -Description "archivos generados ($pattern)"
    }
}

# Función para limpiar archivos de sistema
function Clear-SystemFiles {
    Write-Host "⚙️  Limpiando archivos de sistema..." -ForegroundColor Cyan

    $system = @(
        "Thumbs.db",
        ".DS_Store",
        "*.swp",
        "*.swo",
        "*~",
        "*.bak"
    )

    foreach ($pattern in $system) {
        Remove-ItemsSafely -Pattern $pattern -Description "archivos de sistema ($pattern)"
    }
}

# Función para limpiar directorios temporales
function Clear-TempDirectories {
    Write-Host "📁 Limpiando directorios temporales..." -ForegroundColor Cyan

    $tempDirs = @(
        "temp",
        "tmp",
        "build",
        "dist",
        "node_modules"
    )

    foreach ($dir in $tempDirs) {
        $path = Join-Path $ProjectRoot $dir
        if (Test-Path $path) {
            Write-Host "🗑️  Encontrado directorio: $dir" -ForegroundColor Yellow

            $confirm = Read-Host "¿Eliminar el directorio $dir? (y/N)"
            if ($confirm -eq 'y' -or $confirm -eq 'Y') {
                Remove-Item -Path $path -Recurse -Force
                Write-Host "✅ Directorio $dir eliminado" -ForegroundColor Green
            } else {
                Write-Host "⏭️  Saltando directorio $dir" -ForegroundColor Yellow
            }
        }
    }
}

# Función para optimizar VS Code
function Optimize-VSCode {
    Write-Host "🎯 Optimizando VS Code..." -ForegroundColor Cyan

    $vscodePath = Join-Path $ProjectRoot ".vscode"
    if (Test-Path $vscodePath) {
        # Limpiar archivos temporales de VS Code
        $vscodeTemp = @(
            "*.log",
            "*.tmp",
            "browse.vc.db*",
            "ipch"
        )

        foreach ($pattern in $vscodeTemp) {
            Get-ChildItem -Path $vscodePath -Filter $pattern -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force
        }

        Write-Host "✅ VS Code optimizado" -ForegroundColor Green
    }
}

# Función para mostrar estadísticas
function Show-Statistics {
    Write-Host ""
    Write-Host "📊 ESTADÍSTICAS DEL PROYECTO" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta

    $stats = @{
        "Archivos .cpp" = (Get-ChildItem -Filter "*.cpp" | Measure-Object).Count
        "Archivos .ps1" = (Get-ChildItem -Filter "*.ps1" | Measure-Object).Count
        "Archivos .exe" = (Get-ChildItem -Filter "*.exe" | Measure-Object).Count
        "Archivos .bmp" = (Get-ChildItem -Filter "*.bmp" | Measure-Object).Count
        "Archivos generados" = (Get-ChildItem -Filter "generated_code.*" | Measure-Object).Count
    }

    foreach ($stat in $stats.GetEnumerator()) {
        Write-Host "   📄 $($stat.Key): $($stat.Value)" -ForegroundColor Gray
    }

    $totalSize = (Get-ChildItem -Recurse | Measure-Object -Property Length -Sum).Sum
    Write-Host "   💾 Tamaño total: $([math]::Round($totalSize / 1MB, 2)) MB" -ForegroundColor Gray
}

# Función para limpieza completa
function Clear-All {
    Write-Host "🚀 LIMPIEZA COMPLETA" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red

    $confirm = Read-Host "¿Estás seguro de realizar una limpieza completa? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "❌ Limpieza cancelada" -ForegroundColor Red
        return
    }

    # Crear backup antes de limpiar
    Write-Host "📦 Creando backup de seguridad..." -ForegroundColor Yellow
    New-Backup -Folder $ProjectRoot

    Clear-Executables
    Clear-GeneratedFiles
    Clear-SystemFiles
    Clear-TempDirectories
    Optimize-VSCode
}

# Función para limpieza rápida
function Clear-Quick {
    Write-Host "⚡ LIMPIEZA RÁPIDA" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow

    # Solo limpiar archivos más comunes
    $quickPatterns = @("*.exe", "generated_code.*", "capture_*.bmp")

    foreach ($pattern in $quickPatterns) {
        $items = Get-ChildItem -Filter $pattern -ErrorAction SilentlyContinue
        if ($items.Count -gt 0) {
            $items | Remove-Item -Force
            Write-Host "✅ Eliminados $($items.Count) archivos ($pattern)" -ForegroundColor Green
        }
    }
}

# Función para limpieza selectiva
function Clear-Selective {
    Write-Host "🎯 LIMPIEZA SELECTIVA" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    $options = @(
        "1. Ejecutables (*.exe, *.obj, etc.)",
        "2. Archivos generados (generated_code.*, capture_*.bmp)",
        "3. Archivos de sistema (Thumbs.db, .DS_Store)",
        "4. Directorios temporales (temp, build, etc.)",
        "5. Optimizar VS Code",
        "6. Mostrar estadísticas",
        "0. Salir"
    )

    do {
        Write-Host ""
        Write-Host "Selecciona una opción:" -ForegroundColor Yellow
        foreach ($option in $options) {
            Write-Host "   $option" -ForegroundColor Gray
        }

        $choice = Read-Host "Opción"

        switch ($choice) {
            "1" { Clear-Executables }
            "2" { Clear-GeneratedFiles }
            "3" { Clear-SystemFiles }
            "4" { Clear-TempDirectories }
            "5" { Optimize-VSCode }
            "6" { Show-Statistics }
            "0" { break }
            default { Write-Host "❌ Opción no válida" -ForegroundColor Red }
        }
    } while ($choice -ne "0")
}

# Ejecutar limpieza según el tipo
switch ($Type.ToLower()) {
    "all" { Clear-All }
    "quick" { Clear-Quick }
    "selective" { Clear-Selective }
    "executables" { Clear-Executables }
    "generated" { Clear-GeneratedFiles }
    "system" { Clear-SystemFiles }
    "temp" { Clear-TempDirectories }
    "vscode" { Optimize-VSCode }
    "stats" { Show-Statistics }
    default {
        Write-Host "❌ Tipo de limpieza no válido: $Type" -ForegroundColor Red
        Write-Host "💡 Tipos disponibles: all, quick, selective, executables, generated, system, temp, vscode, stats" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "🎉 LIMPIEZA COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Proyecto optimizado y listo para desarrollo" -ForegroundColor Green
Write-Host ""
