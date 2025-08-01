# monitor.ps1 - Monitor unificado de memoria y GUI
# Uso: .\monitor.ps1 [opcion] [proceso]

param(
	[string]$Option = "menu",
	[string]$ProcessName = ""
)

# Verificar si los ejecutables existen
$memoryExe = "memory_monitor.exe"
$guiExe = "gui_capture.exe"

if (-not (Test-Path $memoryExe)) {
	Write-Host "Error: $memoryExe no encontrado. Ejecuta build.bat primero." -ForegroundColor Red
	exit 1
}

if (-not (Test-Path $guiExe)) {
	Write-Host "Error: $guiExe no encontrado. Ejecuta build.bat primero." -ForegroundColor Red
	exit 1
}

function Show-Menu {
	Write-Host "=== MONITOR UNIFICADO DE MEMORIA Y GUI (SEGURIDAD HABILITADA) ===" -ForegroundColor Cyan
	Write-Host "1. Ver uso de memoria de navegadores" -ForegroundColor Yellow
	Write-Host "2. Ver uso de memoria de proceso específico" -ForegroundColor Yellow
	Write-Host "3. Listar ventanas de navegadores" -ForegroundColor Yellow
	Write-Host "4. Capturar GUI de proceso específico" -ForegroundColor Yellow
	Write-Host "5. Monitorear ventana activa" -ForegroundColor Yellow
	Write-Host "6. Monitoreo continuo de memoria" -ForegroundColor Yellow
	Write-Host "7. Monitoreo continuo de GUI" -ForegroundColor Yellow
	Write-Host "8. Configuración de seguridad" -ForegroundColor Green
	Write-Host "9. Salir" -ForegroundColor Red
	Write-Host ""
}

function Get-MemoryUsage {
	param([string]$ProcessName = "")

	if ($ProcessName -eq "") {
		& $memoryExe memory
	}
 else {
		& $memoryExe monitor $ProcessName
	}
}

function Get-WindowList {
	& $guiExe list
}

function Capture-GUI {
	param([string]$ProcessName)

	if ($ProcessName -eq "") {
		$ProcessName = Read-Host "Nombre del proceso para capturar"
	}

	Write-Host "Capturando GUI de: $ProcessName" -ForegroundColor Green
	& $guiExe capture $ProcessName
}

function Monitor-ActiveWindow {
	& $guiExe active
}

function Start-ContinuousMemoryMonitoring {
	param([string]$ProcessName = "", [int]$Interval = 5)

	Write-Host "Monitoreo continuo de memoria iniciado. Presiona Ctrl+C para detener." -ForegroundColor Green
	Write-Host "Intervalo: $Interval segundos" -ForegroundColor Gray

	while ($true) {
		Clear-Host
		Write-Host "=== MONITOREO CONTINUO DE MEMORIA - $(Get-Date -Format 'HH:mm:ss') ===" -ForegroundColor Cyan

		if ($ProcessName -eq "") {
			& $memoryExe memory
		}
		else {
			& $memoryExe monitor $ProcessName
		}

		Start-Sleep -Seconds $Interval
	}
}

function Start-ContinuousGUIMonitoring {
	param([int]$Interval = 10)

	Write-Host "Monitoreo continuo de GUI iniciado. Presiona Ctrl+C para detener." -ForegroundColor Green
	Write-Host "Intervalo: $Interval segundos" -ForegroundColor Gray

	while ($true) {
		Clear-Host
		Write-Host "=== MONITOREO CONTINUO DE GUI - $(Get-Date -Format 'HH:mm:ss') ===" -ForegroundColor Cyan

		& $guiExe active

		Start-Sleep -Seconds $Interval
	}
}

# Main execution
switch ($Option) {
	"menu" {
		Show-Menu
		$choice = Read-Host "Selecciona opción"

		switch ($choice) {
			"1" { Get-MemoryUsage }
			"2" {
				$proc = Read-Host "Nombre del proceso"
				Get-MemoryUsage -ProcessName $proc
			}
			"3" { Get-WindowList }
			"4" {
				$proc = Read-Host "Nombre del proceso"
				Capture-GUI -ProcessName $proc
			}
			"5" { Monitor-ActiveWindow }
			"6" {
				$proc = Read-Host "Proceso específico (Enter para todos)"
				$interval = Read-Host "Intervalo en segundos (default 5)"
				if ($interval -eq "") { $interval = 5 }
				Start-ContinuousMemoryMonitoring -ProcessName $proc -Interval $interval
			}
			"7" {
				$interval = Read-Host "Intervalo en segundos (default 10)"
				if ($interval -eq "") { $interval = 10 }
				Start-ContinuousGUIMonitoring -Interval $interval
			}
			"8" {
				Write-Host "=== CONFIGURACIÓN DE SEGURIDAD ===" -ForegroundColor Green
				& $memoryExe security
				Write-Host ""
				Write-Host "Para agregar un proceso a la lista blanca:" -ForegroundColor Yellow
				Write-Host "  .\memory_monitor.exe allow [proceso]" -ForegroundColor Gray
				Write-Host "Para remover un proceso de la lista blanca:" -ForegroundColor Yellow
				Write-Host "  .\memory_monitor.exe deny [proceso]" -ForegroundColor Gray
			}
			"9" {
				Write-Host "Saliendo..." -ForegroundColor Green
				exit
			}
			default {
				Write-Host "Opción inválida" -ForegroundColor Red
			}
		}
	}
	"memory" { Get-MemoryUsage -ProcessName $ProcessName }
	"gui" { Get-WindowList }
	"capture" { Capture-GUI -ProcessName $ProcessName }
	"active" { Monitor-ActiveWindow }
	"continuous-memory" { Start-ContinuousMemoryMonitoring -ProcessName $ProcessName }
	"continuous-gui" { Start-ContinuousGUIMonitoring }
	"security" {
		Write-Host "=== CONFIGURACIÓN DE SEGURIDAD ===" -ForegroundColor Green
		& $memoryExe security
	}
	default {
		Write-Host "Uso: .\monitor.ps1 [opcion] [proceso]" -ForegroundColor Yellow
		Write-Host "Opciones: menu, memory, gui, capture, active, continuous-memory, continuous-gui, security" -ForegroundColor Gray
	}
}
