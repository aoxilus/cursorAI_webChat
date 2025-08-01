# setup_github.ps1 - Script para configurar el repositorio GitHub
# Uso: .\setup_github.ps1 [nombre-del-repositorio]

param(
    [string]$RepoName = "memory-monitoring-cursor-ai"
)

Write-Host "🚀 CONFIGURACIÓN DE REPOSITORIO GITHUB" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Verificar si Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git no está instalado" -ForegroundColor Red
    Write-Host "💡 Instala Git desde: https://git-scm.com/" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Git encontrado" -ForegroundColor Green

# Verificar si estamos en un repositorio Git
$isGitRepo = git rev-parse --git-dir 2>$null
if ($isGitRepo) {
    Write-Host "⚠️  Ya estás en un repositorio Git" -ForegroundColor Yellow
    $continue = Read-Host "¿Continuar con la configuración? (y/N)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Host "❌ Configuración cancelada" -ForegroundColor Red
        exit 0
    }
} else {
    Write-Host "🔧 Inicializando repositorio Git..." -ForegroundColor Cyan
    git init
}

# Configurar .gitignore si no existe
if (-not (Test-Path ".gitignore")) {
    Write-Host "❌ .gitignore no encontrado" -ForegroundColor Red
    exit 1
}

# Agregar todos los archivos
Write-Host "📦 Agregando archivos al repositorio..." -ForegroundColor Cyan
git add .

# Commit inicial
Write-Host "💾 Creando commit inicial..." -ForegroundColor Cyan
git commit -m "feat: versión inicial del sistema de monitoreo para Cursor AI

- Monitoreo de memoria en tiempo real
- Captura de GUI con screenshots
- Automatización ChatGPT web real
- Sistema de seguridad con whitelist
- Configuración optimizada para Cursor AI
- Scripts de limpieza y mantenimiento
- Documentación completa

Versión: 2.0.0"

# Crear tag de versión
Write-Host "🏷️  Creando tag de versión..." -ForegroundColor Cyan
git tag -a v2.0.0 -m "Versión 2.0.0 - Sistema completo optimizado para Cursor AI"

# Mostrar información del repositorio
Write-Host ""
Write-Host "📊 INFORMACIÓN DEL REPOSITORIO" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

$commitHash = git rev-parse --short HEAD
$branch = git branch --show-current
$files = git ls-files | Measure-Object | Select-Object -ExpandProperty Count

Write-Host "📄 Archivos en el repositorio: $files" -ForegroundColor Gray
Write-Host "🌿 Rama actual: $branch" -ForegroundColor Gray
Write-Host "🔗 Commit: $commitHash" -ForegroundColor Gray
Write-Host "🏷️  Versión: v2.0.0" -ForegroundColor Gray

# Instrucciones para GitHub
Write-Host ""
Write-Host "🌐 INSTRUCCIONES PARA GITHUB" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

Write-Host "1️⃣  Crear repositorio en GitHub:" -ForegroundColor Yellow
Write-Host "   - Ve a https://github.com/new" -ForegroundColor Gray
Write-Host "   - Nombre: $RepoName" -ForegroundColor Gray
Write-Host "   - Descripción: Sistema de Monitoreo y Automatización para Cursor AI" -ForegroundColor Gray
Write-Host "   - Público o Privado (según prefieras)" -ForegroundColor Gray
Write-Host "   - NO inicialices con README (ya tenemos uno)" -ForegroundColor Gray

Write-Host ""
Write-Host "2️⃣  Conectar repositorio local con GitHub:" -ForegroundColor Yellow
Write-Host "   git remote add origin https://github.com/TU_USUARIO/$RepoName.git" -ForegroundColor Gray
Write-Host "   git branch -M main" -ForegroundColor Gray
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host "   git push --tags" -ForegroundColor Gray

Write-Host ""
Write-Host "3️⃣  Configurar GitHub Pages (opcional):" -ForegroundColor Yellow
Write-Host "   - Ve a Settings > Pages" -ForegroundColor Gray
Write-Host "   - Source: Deploy from a branch" -ForegroundColor Gray
Write-Host "   - Branch: main" -ForegroundColor Gray
Write-Host "   - Folder: / (root)" -ForegroundColor Gray

Write-Host ""
Write-Host "4️⃣  Configurar Topics en GitHub:" -ForegroundColor Yellow
Write-Host "   - cursor-ai" -ForegroundColor Gray
Write-Host "   - memory-monitoring" -ForegroundColor Gray
Write-Host "   - chatgpt-automation" -ForegroundColor Gray
Write-Host "   - powershell" -ForegroundColor Gray
Write-Host "   - cpp" -ForegroundColor Gray
Write-Host "   - windows" -ForegroundColor Gray

# Crear script de comandos
$commandsScript = @"
# Comandos para conectar con GitHub
# Reemplaza TU_USUARIO con tu nombre de usuario de GitHub

git remote add origin https://github.com/TU_USUARIO/$RepoName.git
git branch -M main
git push -u origin main
git push --tags
"@

$commandsScript | Out-File -FilePath "github_commands.ps1" -Encoding UTF8

Write-Host ""
Write-Host "📝 Comandos guardados en: github_commands.ps1" -ForegroundColor Green
Write-Host "💡 Edita el archivo y reemplaza TU_USUARIO con tu usuario de GitHub" -ForegroundColor Yellow

Write-Host ""
Write-Host "🎉 CONFIGURACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Repositorio Git inicializado" -ForegroundColor Green
Write-Host "✅ Commit inicial creado" -ForegroundColor Green
Write-Host "✅ Tag de versión creado" -ForegroundColor Green
Write-Host "✅ Archivos de GitHub creados" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 ¡Listo para subir a GitHub!" -ForegroundColor Green
