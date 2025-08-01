@echo off
setlocal enabledelayedexpansion

echo ========================================
echo 🚀 SISTEMA DE MONITOREO - COMPILACIÓN OPTIMIZADA
echo ========================================
echo.

:: Configuración de compilación optimizada
set COMPILER=g++
set OPTIMIZATION=-O2
set WARNINGS=-Wall -Wextra
set STANDARD=-std=c++17
set TIMEOUT=30

:: Verificar compilador
echo 🔍 Verificando compilador...
%COMPILER% --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Compilador %COMPILER% no encontrado
    echo 💡 Instala MinGW-w64 o Visual Studio Build Tools
    pause
    exit /b 1
)

echo ✅ Compilador encontrado
echo.

:: Función para compilar con timeout
:compile_with_timeout
set "source_file=%~1"
set "output_file=%~2"
set "libraries=%~3"

echo 🔧 Compilando %source_file%...
echo 📝 Comando: %COMPILER% -o %output_file% %source_file% %OPTIMIZATION% %WARNINGS% %STANDARD% %libraries%

:: Ejecutar compilación con timeout
powershell -Command "& { $job = Start-Job -ScriptBlock { param($cmd) Invoke-Expression $cmd } -ArgumentList '%COMPILER% -o %output_file% %source_file% %OPTIMIZATION% %WARNINGS% %STANDARD% %libraries%'; if (Wait-Job $job -Timeout %TIMEOUT%) { Receive-Job $job; Remove-Job $job } else { Stop-Job $job; Remove-Job $job; Write-Host '❌ Timeout en compilación'; exit 1 } }" 2>$null

if %errorlevel% neq 0 (
    echo ❌ Error compilando %source_file%
    echo 💡 Verifica el código fuente y las dependencias
    pause
    exit /b 1
)

echo ✅ %output_file% compilado exitosamente
echo.
goto :eof

:: Compilar módulos principales
echo 📦 Compilando módulos principales...
echo.

:: Memory Monitor
call :compile_with_timeout "memory_monitor.cpp" "memory_monitor.exe" "-lgdi32 -luser32 -lpsapi"

:: GUI Capture
call :compile_with_timeout "gui_capture.cpp" "gui_capture.exe" "-lgdi32 -luser32 -lpsapi"

:: ChatGPT Automation
call :compile_with_timeout "chatgpt_automation.cpp" "chatgpt_automation.exe" "-lgdi32 -luser32 -lole32 -loleaut32 -lpsapi"

:: Verificar archivos generados
echo 🔍 Verificando archivos generados...
set "missing_files="

for %%f in (memory_monitor.exe gui_capture.exe chatgpt_automation.exe) do (
    if not exist "%%f" (
        set "missing_files=!missing_files! %%f"
    )
)

if defined missing_files (
    echo ❌ Archivos faltantes:!missing_files!
    pause
    exit /b 1
)

:: Mostrar información de archivos
echo.
echo 📊 ARCHIVOS GENERADOS:
echo ========================================
for %%f in (memory_monitor.exe gui_capture.exe chatgpt_automation.exe) do (
    for %%a in ("%%f") do (
        echo 📄 %%~na.exe - %%~za bytes
    )
)
echo.

:: Mostrar uso
echo 📋 USO DEL SISTEMA:
echo ========================================
echo 🔍 Monitoreo de memoria:
echo    memory_monitor.exe memory
echo    memory_monitor.exe monitor chrome.exe
echo.
echo 🖼️ Captura de GUI:
echo    gui_capture.exe list
echo    gui_capture.exe capture chrome.exe
echo.
echo 🤖 Automatización ChatGPT:
echo    chatgpt_web_automation.ps1 -Command interactive
echo    chatgpt_demo.ps1 demo
echo.
echo 🎯 Interfaz unificada:
echo    monitor.ps1
echo.

:: Optimización de archivos
echo ⚡ Optimizando archivos...
for %%f in (memory_monitor.exe gui_capture.exe chatgpt_automation.exe) do (
    echo 🔧 Optimizando %%f...
    :: Aquí podrías agregar más optimizaciones si es necesario
)

echo.
echo 🎉 COMPILACIÓN OPTIMIZADA COMPLETADA
echo ========================================
echo ✅ Todos los módulos compilados exitosamente
echo ✅ Optimización -O2 aplicada
echo ✅ Timeouts configurados (%TIMEOUT%s)
echo ✅ Verificación de archivos completada
echo.
echo 🚀 El sistema está listo para usar
echo.

pause
