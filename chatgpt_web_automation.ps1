# chatgpt_web_automation.ps1 - Automatización REAL del ChatGPT Web
# Uso: .\chatgpt_web_automation.ps1 -Command ask -Question "tu pregunta"

param(
    [string]$Command = "",
    [string]$Question = ""
)

# Definir tipos Win32 para P/Invoke
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    public const int SW_SHOW = 5;
    public const int SW_RESTORE = 9;
}
"@

# Variables globales
$script:lastResponse = ""
$script:conversationHistory = @()
$script:config = $null

# Cargar configuración JSON
function Load-Config {
    if (Test-Path "config.json") {
        $script:config = Get-Content "config.json" | ConvertFrom-Json
        Write-Host "✅ Configuración cargada" -ForegroundColor Green
    } else {
        Write-Host "❌ config.json no encontrado" -ForegroundColor Red
        exit 1
    }
}

# Función para encontrar ventana de ChatGPT (web o desktop)
function Find-ChatGPTWindow {
    Write-Host "🔍 Buscando ventana de Project Test..." -ForegroundColor Yellow

    # Cargar configuración si no está cargada
    if ($null -eq $script:config) {
        Load-Config
    }

    # Buscar usando patrones de configuración
    $patterns = $script:config.chrome.window_title_patterns
    $chatgptProcesses = Get-Process -Name $script:config.chrome.process_name -ErrorAction SilentlyContinue | Where-Object {
        $title = $_.MainWindowTitle
        $patterns | ForEach-Object { $title -like $_ }
    }

    if ($chatgptProcesses) {
        $chatgptProcess = $chatgptProcesses | Select-Object -First 1
        Write-Host "✅ Project Test encontrado: $($chatgptProcess.MainWindowTitle)" -ForegroundColor Green
        
        # Verificar si está logueado
        $isLoggedIn = Test-UserLogin $chatgptProcess.MainWindowHandle
        if (-not $isLoggedIn) {
            Write-Host "⚠️ Usuario no logueado en Project Test" -ForegroundColor Yellow
            Write-Host "🔗 URL: $($script:config.project_test.url)" -ForegroundColor Cyan
            return $null
        }
        
        return $chatgptProcess.MainWindowHandle
    }

    # Solo Chrome - Project Test de OpenAI
    Write-Host "🎯 Configurado para Chrome 100% con Project Test" -ForegroundColor Cyan

    # Buscar Project Test específicamente
    $projectTestProcesses = Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {
        $_.MainWindowTitle -like "*Project Test*"
    }

    if ($projectTestProcesses) {
        $projectTestProcess = $projectTestProcesses | Select-Object -First 1
        Write-Host "✅ Project Test encontrado: $($projectTestProcess.MainWindowTitle)" -ForegroundColor Green
        return $projectTestProcess.MainWindowHandle
    }

    # Usar EnumWindows como respaldo
    $foundWindow = $null
    $enumWindowsDelegate = {
        param([IntPtr]$hWnd, [IntPtr]$lParam)

        $title = New-Object System.Text.StringBuilder 256
        [Win32]::GetWindowText($hWnd, $title, 256)
        $titleStr = $title.ToString()

        if ($titleStr -like "*Project Test*" -or $titleStr -like "*ChatGPT*") {
            Write-Host "🔍 Project Test encontrado: $titleStr" -ForegroundColor Gray
            $foundWindow = $hWnd
            return $false
        }
        return $true
    }

    [Win32]::EnumWindows($enumWindowsDelegate, [IntPtr]::Zero)

    if ($foundWindow) {
        Write-Host "✅ Project Test encontrado (EnumWindows): $titleStr" -ForegroundColor Green
        return $foundWindow
    }

    Write-Host "❌ No se encontró Project Test" -ForegroundColor Red
    Write-Host "💡 Asegúrate de tener Project Test abierto en Chrome" -ForegroundColor Yellow
    return $null
}

# Función para verificar si el usuario está logueado
function Test-UserLogin {
    param([IntPtr]$windowHandle)
    
    Write-Host "🔍 Verificando estado de login..." -ForegroundColor Yellow
    
    # Activar la ventana
    [Win32]::SetForegroundWindow($windowHandle)
    Start-Sleep -Milliseconds $script:config.automation.wait_time
    
    # Buscar elementos que indiquen que está logueado
    $loggedInSelectors = $script:config.project_test.detection.logged_in_selectors
    $loginSelectors = $script:config.project_test.detection.login_selectors
    
    # Simular búsqueda de elementos (en una implementación real usarías UI Automation)
    # Por ahora, verificamos el título de la ventana
    $title = (Get-Process | Where-Object { $_.MainWindowHandle -eq $windowHandle }).MainWindowTitle
    
    if ($title -like "*Project Test*" -and $title -notlike "*Login*" -and $title -notlike "*Sign In*") {
        Write-Host "✅ Usuario logueado detectado" -ForegroundColor Green
        return $true
    }
    
    Write-Host "❌ Usuario no logueado" -ForegroundColor Red
    return $false
}

# Función para guardar archivos de salida
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
            Write-Host "💾 Código guardado: $filepath" -ForegroundColor Green
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

# Función para abrir Project Test
function Open-ProjectTest {
    Write-Host "🌐 Abriendo Project Test..." -ForegroundColor Yellow
    
    # Cargar configuración si no está cargada
    if ($null -eq $script:config) {
        Load-Config
    }
    
    $projectTestUrl = $script:config.project_test.url
    Write-Host "🔗 URL: $projectTestUrl" -ForegroundColor Cyan
    
    try {
        # Cerrar ventanas existentes de Chrome con Project Test
        Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Where-Object {
            $_.MainWindowTitle -like "*Project Test*"
        } | Stop-Process -Force -ErrorAction SilentlyContinue
        
        Start-Sleep -Seconds 2
        
        # Abrir nueva ventana con Project Test
        Start-Process "chrome.exe" -ArgumentList "--new-window", $projectTestUrl
        Write-Host "✅ Project Test abierto en nueva ventana" -ForegroundColor Green
        
        # Esperar a que se cargue
        Start-Sleep -Seconds 8
        
        return $true
    }
    catch {
        Write-Host "❌ Error abriendo Project Test: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Función para activar ventana de ChatGPT
function Activate-ChatGPTWindow {
    param([IntPtr]$hWnd)

    if (-not $hWnd) {
        Write-Host "❌ No hay ventana de Project Test activa" -ForegroundColor Red
        Write-Host "🌐 Abriendo Project Test..." -ForegroundColor Yellow
        
        # Abrir Project Test usando la función específica
        if (Open-ProjectTest) {
            # Intentar encontrar la ventana nuevamente
            $hWnd = Find-ChatGPTWindow
            if (-not $hWnd) {
                Write-Host "❌ No se pudo abrir Project Test" -ForegroundColor Red
                return $false
            }
        } else {
            return $false
        }
    }

    Write-Host "🔄 Activando ventana de ChatGPT..." -ForegroundColor Yellow

    try {
        # Mostrar y restaurar ventana
        [Win32]::ShowWindow($hWnd, [Win32]::SW_RESTORE)
        Start-Sleep -Milliseconds 500

        # Traer al frente
        [Win32]::SetForegroundWindow($hWnd)
        Start-Sleep -Milliseconds 500

        # Mover a posición visible
        [Win32]::MoveWindow($hWnd, 100, 100, 1200, 800, $true)
        Start-Sleep -Milliseconds 500

        Write-Host "✅ Ventana activada y posicionada" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error activando ventana: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Función para enviar texto a ChatGPT
function Send-TextToChatGPT {
    param([string]$text)

    Write-Host "📝 Enviando texto: $($text.Substring(0, [Math]::Min(50, $text.Length)))..." -ForegroundColor Yellow

    try {
        Add-Type -AssemblyName System.Windows.Forms

        # Limpiar clipboard
        [System.Windows.Forms.Clipboard]::Clear()
        Start-Sleep -Milliseconds 200

        # Copiar texto al clipboard
        [System.Windows.Forms.Clipboard]::SetText($text)
        Start-Sleep -Milliseconds 200

        # Pegar texto
        [System.Windows.Forms.SendKeys]::SendWait("^v")
        Start-Sleep -Milliseconds 500

        Write-Host "✅ Texto enviado" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error enviando texto: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Función para enviar prompt
function Send-Prompt {
    Write-Host "🚀 Enviando prompt..." -ForegroundColor Yellow

    try {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
        Start-Sleep -Milliseconds 500

        Write-Host "✅ Prompt enviado" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error enviando prompt: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Función para extraer respuesta de ChatGPT
function Extract-ChatGPTResponse {
    Write-Host "📖 Extrayendo respuesta de ChatGPT..." -ForegroundColor Yellow

    try {
        Add-Type -AssemblyName System.Windows.Forms

        # Navegar al área de respuesta
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
        Start-Sleep -Milliseconds 300
        [System.Windows.Forms.SendKeys]::SendWait("{DOWN}")
        Start-Sleep -Milliseconds 300

        # Seleccionar todo y copiar
        [System.Windows.Forms.SendKeys]::SendWait("^a")
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait("^c")
        Start-Sleep -Milliseconds 500

        $clipboardContent = [System.Windows.Forms.Clipboard]::GetText()

        if ($clipboardContent -and $clipboardContent.Length -gt 50) {
            # Filtrar solo la respuesta de ChatGPT
            $lines = $clipboardContent -split "`n"
            $responseStart = -1
            $responseEnd = -1

            for ($i = 0; $i -lt $lines.Count; $i++) {
                $line = $lines[$i].Trim()

                # Buscar inicio de respuesta
                if ($responseStart -eq -1 -and
                    ($line -like "*ChatGPT*" -or $line -like "*Assistant*" -or $line -like "*AI*" -or $line -like "*Respuesta*")) {
                    $responseStart = $i + 1
                }

                # Buscar fin de respuesta
                if ($responseStart -ne -1 -and $responseEnd -eq -1 -and
                    ($line -like "*New chat*" -or $line -like "*Message ChatGPT*" -or $line -like "*Regenerate*")) {
                    $responseEnd = $i
                    break
                }
            }

            if ($responseStart -ne -1) {
                $endIndex = if ($responseEnd -ne -1) { $responseEnd } else { $lines.Count }
                $response = ($lines[$responseStart..($endIndex-1)] -join "`n").Trim()

                if ($response.Length -gt 10) {
                    $script:lastResponse = $response
                    Write-Host "✅ Respuesta extraída exitosamente" -ForegroundColor Green
                    return $response
                }
            }

            # Si no se pudo filtrar, usar todo el contenido
            $script:lastResponse = $clipboardContent
            Write-Host "✅ Respuesta extraída (contenido completo)" -ForegroundColor Green
            return $clipboardContent
        }

        Write-Host "⚠️ No se pudo extraer respuesta, intentando método alternativo..." -ForegroundColor Yellow

        # Método alternativo: intentar copiar solo la última respuesta
        [System.Windows.Forms.SendKeys]::SendWait("{END}")
        Start-Sleep -Milliseconds 300
        [System.Windows.Forms.SendKeys]::SendWait("^a")
        Start-Sleep -Milliseconds 300
        [System.Windows.Forms.SendKeys]::SendWait("^c")
        Start-Sleep -Milliseconds 300

        $altContent = [System.Windows.Forms.Clipboard]::GetText()
        if ($altContent -and $altContent.Length -gt 10) {
            $script:lastResponse = $altContent
            Write-Host "✅ Respuesta extraída (método alternativo)" -ForegroundColor Green
            return $altContent
        }

        Write-Host "❌ No se pudo extraer respuesta" -ForegroundColor Red
        return ""
    }
    catch {
        Write-Host "❌ Error extrayendo respuesta: $($_.Exception.Message)" -ForegroundColor Red
        return ""
    }
}

# Función para esperar respuesta
function Wait-ForResponse {
    param([int]$timeoutSeconds = 30)

    Write-Host "⏳ Esperando respuesta de ChatGPT..." -ForegroundColor Yellow

    $startTime = Get-Date
    $elapsed = 0

    while ($elapsed -lt $timeoutSeconds) {
        $elapsed = ((Get-Date) - $startTime).TotalSeconds
        Write-Host "⏱️  Esperando... $([Math]::Round($elapsed, 1))s" -ForegroundColor Gray

        # Intentar extraer respuesta cada 2 segundos
        if ($elapsed -gt 10) {
            $response = Extract-ChatGPTResponse
            if ($response -and $response.Length -gt 50) {
                return $response
            }
        }

        Start-Sleep -Seconds 2
    }

    # Último intento de extracción
    return Extract-ChatGPTResponse
}

# Función para hacer pregunta
function Ask-Question {
    param([string]$question)

    Write-Host "🤖 Haciendo pregunta a ChatGPT..." -ForegroundColor Cyan
    Write-Host "❓ Pregunta: $question" -ForegroundColor White

    # Encontrar y activar ventana
    $hWnd = Find-ChatGPTWindow
    if (-not $hWnd) {
        Write-Host "❌ No se pudo encontrar ChatGPT. Asegúrate de que esté abierto." -ForegroundColor Red
        return $false
    }

    if (-not (Activate-ChatGPTWindow $hWnd)) {
        Write-Host "❌ No se pudo activar la ventana" -ForegroundColor Red
        return $false
    }

    # Enviar pregunta
    if (-not (Send-TextToChatGPT $question)) {
        Write-Host "❌ No se pudo enviar la pregunta" -ForegroundColor Red
        return $false
    }

    # Enviar prompt
    if (-not (Send-Prompt)) {
        Write-Host "❌ No se pudo enviar el prompt" -ForegroundColor Red
        return $false
    }

    # Esperar y extraer respuesta
    $response = Wait-ForResponse

    if ($response) {
        Write-Host "✅ Pregunta enviada y respuesta recibida" -ForegroundColor Green
        Write-Host "📄 Respuesta:" -ForegroundColor Cyan
        Write-Host $response -ForegroundColor White
        
        # Guardar en archivo de conversación
        Save-OutputFile "Pregunta: $question`nRespuesta: $response" "conversation"
        
        return $response
    } else {
        Write-Host "❌ No se recibió respuesta" -ForegroundColor Red
        Save-OutputFile "Error: No se recibió respuesta para: $question" "debug"
        return $false
    }
}

# Función para generar código
function Generate-Code {
    param([string]$prompt, [string]$language = "txt")

    $codePrompt = "Genera código $language para: $prompt. Proporciona solo el código sin explicaciones adicionales."
    $response = Ask-Question $codePrompt
    
    if ($response) {
        # Guardar código generado
        Save-OutputFile $response "code" $language
    }
    
    return $response
}

# Función principal
function Main {
    Write-Host "=== MOTOR CHATGPT WEB AUTOMATION ===" -ForegroundColor Cyan
    Write-Host "Automatización REAL del ChatGPT Web" -ForegroundColor Yellow
    Write-Host "🎯 Project Test de OpenAI" -ForegroundColor Green
    Write-Host ""
    
    # Cargar configuración
    Load-Config

    switch ($Command.ToLower()) {
        "open" {
            Write-Host "🚀 Abriendo Project Test..." -ForegroundColor Cyan
            return Open-ProjectTest
        }
        "ask" {
            if ($Question) {
                return Ask-Question $Question
            } else {
                Write-Host "❌ Uso: .\chatgpt_web_automation.ps1 -Command ask -Question 'tu pregunta'" -ForegroundColor Red
                Write-Host "💡 Ejemplo: .\chatgpt_web_automation.ps1 -Command ask -Question '¿Qué es Python?'" -ForegroundColor Yellow
            }
        }
        "code" {
            if ($Question) {
                return Generate-Code $Question
            } else {
                Write-Host "❌ Uso: .\chatgpt_web_automation.ps1 -Command code -Question 'descripción del código'" -ForegroundColor Red
            }
        }
        default {
            Write-Host "❌ Comando no válido. Usa 'open', 'ask' o 'code'" -ForegroundColor Red
            Write-Host "💡 Ejemplos:" -ForegroundColor Yellow
            Write-Host "   .\chatgpt_web_automation.ps1 -Command open" -ForegroundColor Cyan
            Write-Host "   .\chatgpt_web_automation.ps1 -Command ask -Question '¿Qué es Python?'" -ForegroundColor Cyan
        }
    }
}

# Ejecutar función principal
Main
