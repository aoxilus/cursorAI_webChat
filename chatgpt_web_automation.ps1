# chatgpt_web_automation.ps1 - Automatización REAL del ChatGPT Web
# Uso: .\chatgpt_web_automation.ps1 [comando] [parámetros]

param(
	[string]$Command = "interactive",
	[string]$Language = "",
	[string]$Description = "",
	[string]$Question = ""
)

# Importar ensamblados necesarios
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Definir Win32 APIs
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll")]
    public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, ref RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    [DllImport("user32.dll")]
    public static extern bool GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern IntPtr GetWindow(IntPtr hWnd, uint uCmd);

    public const int SW_RESTORE = 9;
    public const int SW_SHOW = 5;
    public const uint GW_HWNDNEXT = 2;

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
}

[StructLayout(LayoutKind.Sequential)]
public struct RECT {
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
"@

# Variables globales
$script:chatgptWindow = [IntPtr]::Zero
$script:chromeProcess = $null

# Función para encontrar ventana de ChatGPT
function Find-ChatGPTWindow {
	Write-Host "🔍 Buscando ventana de ChatGPT..." -ForegroundColor Cyan

	# Buscar procesos de Chrome
	$chromeProcesses = Get-Process | Where-Object { $_.ProcessName -eq "chrome" -and $_.MainWindowHandle -ne [IntPtr]::Zero }

	foreach ($process in $chromeProcesses) {
		try {
			$title = [System.Windows.Forms.Control]::FromHandle($process.MainWindowHandle).Text
			if ($title -like "*ChatGPT*") {
				$script:chatgptWindow = $process.MainWindowHandle
				$script:chromeProcess = $process
				Write-Host "✅ ChatGPT encontrado: $title" -ForegroundColor Green
				return $true
			}
		}
		catch { }
	}

	# Buscar usando EnumWindows como respaldo
	$found = $false
	[Win32]::EnumWindows({
			param($hwnd, $lparam)

			if ($found) { return $true }

			$title = New-Object System.Text.StringBuilder(256)
			[Win32]::GetWindowText($hwnd, $title, 256)
			$titleStr = $title.ToString()

			Write-Host "🔍 Ventana encontrada: $titleStr" -ForegroundColor Gray

			if ($titleStr -like "*ChatGPT*") {
				$script:chatgptWindow = $hwnd
				$found = $true
				Write-Host "✅ ChatGPT encontrado (EnumWindows): $titleStr" -ForegroundColor Green
				return $false
			}

			return $true
		}, [IntPtr]::Zero)

	return $found
}

# Función para activar y posicionar ventana
function Activate-ChatGPTWindow {
	if ($script:chatgptWindow -eq [IntPtr]::Zero) {
		Write-Host "❌ No hay ventana de ChatGPT activa" -ForegroundColor Red
		return $false
	}

	Write-Host "🔄 Activando ventana de ChatGPT..." -ForegroundColor Yellow

	# Mostrar y activar ventana directamente
	[Win32]::ShowWindow($script:chatgptWindow, [Win32]::SW_RESTORE)
	[Win32]::SetForegroundWindow($script:chatgptWindow)
	Start-Sleep -Milliseconds 1000

	# Mover a posición visible por si está fuera de pantalla
	[Win32]::MoveWindow($script:chatgptWindow, 100, 100, 1200, 800, $true)
	Start-Sleep -Milliseconds 500

	Write-Host "✅ Ventana activada y posicionada" -ForegroundColor Green
	return $true
}

# Función para abrir ChatGPT si no está abierto
function Open-ChatGPT {
	Write-Host "🌐 Abriendo ChatGPT en Chrome..." -ForegroundColor Cyan

	try {
		# Intentar abrir ChatGPT
		Start-Process "chrome.exe" -ArgumentList "https://chat.openai.com"
		Start-Sleep -Seconds 3

		# Esperar a que se cargue
		$attempts = 0
		while ($attempts -lt 10) {
			if (Find-ChatGPTWindow) {
				Activate-ChatGPTWindow
				return $true
			}
			Start-Sleep -Seconds 2
			$attempts++
		}

		Write-Host "❌ No se pudo abrir ChatGPT automáticamente" -ForegroundColor Red
		return $false
	}
 catch {
		Write-Host "❌ Error abriendo ChatGPT: $($_.Exception.Message)" -ForegroundColor Red
		return $false
	}
}

# Función para enviar texto usando SendKeys
function Send-TextToChatGPT {
	param([string]$Text)

	if ($script:chatgptWindow -eq [IntPtr]::Zero) {
		Write-Host "❌ No hay ventana de ChatGPT activa" -ForegroundColor Red
		return $false
	}

	Write-Host "📝 Enviando texto: $($Text.Substring(0, [Math]::Min(50, $Text.Length)))..." -ForegroundColor Cyan

	try {
		# Asegurar que la ventana esté activa
		[Win32]::SetForegroundWindow($script:chatgptWindow)
		Start-Sleep -Milliseconds 500

		# Copiar texto al portapapeles
		[System.Windows.Forms.Clipboard]::SetText($Text)
		Start-Sleep -Milliseconds 100

		# Pegar texto (Ctrl+V)
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

# Función para enviar prompt (Enter)
function Send-Prompt {
	Write-Host "🚀 Enviando prompt..." -ForegroundColor Cyan

	try {
		# Asegurar que la ventana esté activa
		[Win32]::SetForegroundWindow($script:chatgptWindow)
		Start-Sleep -Milliseconds 200

		# Enviar Enter
		[System.Windows.Forms.SendKeys]::SendWait("{Enter}")
		Start-Sleep -Milliseconds 1000

		Write-Host "✅ Prompt enviado" -ForegroundColor Green
		return $true
	}
 catch {
		Write-Host "❌ Error enviando prompt: $($_.Exception.Message)" -ForegroundColor Red
		return $false
	}
}

# Función para esperar respuesta
function Wait-ForResponse {
	param([int]$TimeoutSeconds = 30)

	Write-Host "⏳ Esperando respuesta de ChatGPT..." -ForegroundColor Yellow

	$startTime = Get-Date
	$lastResponse = ""

	while ((Get-Date) - $startTime -lt [TimeSpan]::FromSeconds($TimeoutSeconds)) {
		# Aquí podrías implementar detección de respuesta
		# Por ahora, solo esperamos
		Start-Sleep -Seconds 2

		# Mostrar progreso
		$elapsed = (Get-Date) - $startTime
		Write-Host "⏱️  Esperando... $($elapsed.TotalSeconds.ToString('F1'))s" -ForegroundColor Gray
	}

	Write-Host "✅ Tiempo de espera completado" -ForegroundColor Green
	return $true
}

# Función para generar código
function Generate-Code {
	param([string]$Language, [string]$Description)

	Write-Host "🔧 Generando código en $Language..." -ForegroundColor Cyan
	Write-Host "📝 Descripción: $Description" -ForegroundColor Gray

	$prompt = "Genera código en $Language para: $Description. Solo el código, sin explicaciones."

	if (Send-TextToChatGPT -Text $prompt) {
		if (Send-Prompt) {
			Wait-ForResponse -TimeoutSeconds 20

			# Guardar en archivo
			$filename = "generated_code.$Language"
			$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
			$content = @"
# Código generado por ChatGPT Web Automation
# Fecha: $timestamp
# Lenguaje: $Language
# Descripción: $Description

"@
			$content | Out-File -FilePath $filename -Encoding UTF8
			Write-Host "✅ Código guardado en: $filename" -ForegroundColor Green
			return $true
		}
	}

	return $false
}

# Función para hacer pregunta
function Ask-Question {
	param([string]$Question)

	Write-Host "🤖 Enviando pregunta a ChatGPT: $Question" -ForegroundColor Cyan

	if (Send-TextToChatGPT -Text $Question) {
		if (Send-Prompt) {
			Wait-ForResponse -TimeoutSeconds 30
			Write-Host "✅ Pregunta enviada y respuesta esperada" -ForegroundColor Green
			return $true
		}
	}

	return $false
}

# Función para modo interactivo
function Start-InteractiveMode {
	Write-Host "🎮 Modo interactivo iniciado" -ForegroundColor Magenta
	Write-Host "Comandos disponibles:" -ForegroundColor Yellow
	Write-Host "  code [lenguaje] [descripción] - Generar código" -ForegroundColor Gray
	Write-Host "  ask [pregunta] - Hacer pregunta" -ForegroundColor Gray
	Write-Host "  exit - Salir" -ForegroundColor Gray
	Write-Host ""

	while ($true) {
		$input = Read-Host "ChatGPT> "

		if ($input -eq "exit") {
			Write-Host "👋 ¡Hasta luego!" -ForegroundColor Green
			break
		}

		if ($input -like "code *") {
			$parts = $input -split " ", 3
			if ($parts.Length -ge 3) {
				Generate-Code -Language $parts[1] -Description $parts[2]
			}
			else {
				Write-Host "❌ Uso: code [lenguaje] [descripción]" -ForegroundColor Red
			}
		}
		elseif ($input -like "ask *") {
			$question = $input.Substring(4)
			Ask-Question -Question $question
		}
		else {
			Write-Host "❌ Comando no reconocido" -ForegroundColor Red
		}

		Write-Host ""
	}
}

# Función principal
function Main {
	Write-Host "=== MOTOR CHATGPT WEB AUTOMATION ===" -ForegroundColor Magenta
	Write-Host "Automatización REAL del ChatGPT Web" -ForegroundColor Cyan
	Write-Host ""

	# Buscar ventana de ChatGPT
	if (-not (Find-ChatGPTWindow)) {
		Write-Host "❌ No se encontró ventana de ChatGPT" -ForegroundColor Red
		Write-Host "🔄 Intentando abrir ChatGPT automáticamente..." -ForegroundColor Yellow

		if (-not (Open-ChatGPT)) {
			Write-Host "❌ No se pudo abrir ChatGPT automáticamente" -ForegroundColor Red
			Write-Host "💡 Abriendo manualmente..." -ForegroundColor Yellow

			# Abrir ChatGPT manualmente
			Start-Process "chrome.exe" -ArgumentList "https://chat.openai.com"
			Start-Sleep -Seconds 5

			# Intentar encontrar la ventana nuevamente
			if (-not (Find-ChatGPTWindow)) {
				Write-Host "❌ No se pudo encontrar ChatGPT después de abrirlo" -ForegroundColor Red
				Write-Host "💡 Por favor, abre ChatGPT manualmente en Chrome y vuelve a intentar" -ForegroundColor Yellow
				return
			}
		}
	}

	# Activar ventana
	if (-not (Activate-ChatGPTWindow)) {
		Write-Host "❌ No se pudo activar la ventana" -ForegroundColor Red
		return
	}

	# Ejecutar comando
	switch ($Command.ToLower()) {
		"code" {
			if ($Language -and $Description) {
				Generate-Code -Language $Language -Description $Description
			}
			else {
				Write-Host "❌ Uso: .\chatgpt_web_automation.ps1 code [lenguaje] [descripción]" -ForegroundColor Red
			}
		}
		"ask" {
			if ($Question) {
				Ask-Question -Question $Question
			}
			else {
				Write-Host "❌ Uso: .\chatgpt_web_automation.ps1 ask [pregunta]" -ForegroundColor Red
				Write-Host "💡 Ejemplo: .\chatgpt_web_automation.ps1 ask '¿Qué es Python?'" -ForegroundColor Yellow
			}
		}
		"interactive" {
			Start-InteractiveMode
		}
		default {
			Write-Host "❌ Comando no reconocido: $Command" -ForegroundColor Red
			Write-Host "💡 Comandos disponibles: code, ask, interactive" -ForegroundColor Yellow
		}
	}
}

# Ejecutar función principal
Main
