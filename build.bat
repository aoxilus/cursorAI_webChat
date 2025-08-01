@echo off
echo Compilando modulos de monitoreo de memoria y GUI...

REM Verificar si g++ esta disponible
where g++ >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: g++ no encontrado. Instala MinGW o Visual Studio Build Tools
    pause
    exit /b 1
)

echo Compilando memory_monitor.cpp...
g++ -o memory_monitor.exe memory_monitor.cpp -lgdi32 -luser32 -lpsapi
if %errorlevel% neq 0 (
    echo Error al compilar memory_monitor.cpp
    pause
    exit /b 1
)

echo Compilando gui_capture.cpp...
g++ -o gui_capture.exe gui_capture.cpp -lgdi32 -luser32 -lole32 -loleaut32 -lpsapi
if %errorlevel% neq 0 (
    echo Error al compilar gui_capture.cpp
    pause
    exit /b 1
)

echo Compilando chatgpt_automation.cpp...
g++ -o chatgpt_automation.exe chatgpt_automation.cpp -lgdi32 -luser32 -lole32 -loleaut32 -lpsapi
if %errorlevel% neq 0 (
    echo Error al compilar chatgpt_automation.cpp
    pause
    exit /b 1
)

echo Compilacion completada exitosamente!
echo.
echo Archivos generados:
echo - memory_monitor.exe
echo - gui_capture.exe
echo - chatgpt_automation.exe
echo.
echo Uso:
echo   memory_monitor.exe memory
echo   memory_monitor.exe gui
echo   memory_monitor.exe monitor chrome
echo   gui_capture.exe list
echo   gui_capture.exe capture chrome
echo   gui_capture.exe active
echo   chatgpt_automation.exe interactive
echo   chatgpt_automation.exe code python "función para ordenar lista"
echo   chatgpt_automation.exe ask "¿Qué es Python?"
pause
