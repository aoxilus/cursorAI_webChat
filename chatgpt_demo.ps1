# chatgpt_demo.ps1 - Demo del motor de automatización para ChatGPT
# Uso: .\chatgpt_demo.ps1 [comando] [parámetros]

param(
    [string]$Command = "demo",
    [string]$Language = "python",
    [string]$Description = "función para ordenar lista",
    [string]$Question = "¿Qué es Python?"
)

Write-Host "=== MOTOR CHATGPT AUTOMATIZADO - DEMO ===" -ForegroundColor Cyan
Write-Host "Este es un demo del sistema de automatización para ChatGPT" -ForegroundColor Yellow
Write-Host ""

# Función para simular generación de código
function Generate-DemoCode {
    param([string]$Language, [string]$Description)

    Write-Host "🔧 Generando código en $Language..." -ForegroundColor Cyan
    Write-Host "Descripción: $Description" -ForegroundColor Gray

    # Código de ejemplo según el lenguaje
    $code = switch ($Language.ToLower()) {
        "python" {
            @"
def ordenar_lista(lista):
    """Función para ordenar una lista de números"""
    return sorted(lista)

# Ejemplo de uso
numeros = [3, 1, 4, 1, 5, 9, 2, 6]
resultado = ordenar_lista(numeros)
print(f"Lista original: {numeros}")
print(f"Lista ordenada: {resultado}")

# También puedes usar el método sort() in-place
numeros.sort()
print(f"Lista ordenada in-place: {numeros}")
"@
        }
        "javascript" {
            @"
function ordenarLista(lista) {
    // Función para ordenar una lista de números
    return lista.slice().sort((a, b) => a - b);
}

// Ejemplo de uso
const numeros = [3, 1, 4, 1, 5, 9, 2, 6];
const resultado = ordenarLista(numeros);
console.log(`Lista original: ${numeros}`);
console.log(`Lista ordenada: ${resultado}`);

// También puedes usar el método sort() in-place
numeros.sort((a, b) => a - b);
console.log(`Lista ordenada in-place: ${numeros}`);
"@
        }
        "cpp" {
            @"
#include <iostream>
#include <vector>
#include <algorithm>

std::vector<int> ordenarLista(std::vector<int> lista) {
    // Función para ordenar una lista de números
    std::sort(lista.begin(), lista.end());
    return lista;
}

int main() {
    std::vector<int> numeros = {3, 1, 4, 1, 5, 9, 2, 6};
    std::vector<int> resultado = ordenarLista(numeros);

    std::cout << "Lista original: ";
    for (int num : numeros) std::cout << num << " ";
    std::cout << std::endl;

    std::cout << "Lista ordenada: ";
    for (int num : resultado) std::cout << num << " ";
    std::cout << std::endl;

    return 0;
}
"@
        }
        default {
            @"
// Código de ejemplo en $Language
// Función para: $Description

function ordenarLista(lista) {
    return lista.sort();
}

// Ejemplo de uso
const numeros = [3, 1, 4, 1, 5, 9, 2, 6];
const resultado = ordenarLista(numeros);
console.log("Lista ordenada:", resultado);
"@
        }
    }

    # Guardar código en archivo
    $filename = "generated_code.$Language"
    $code | Out-File -FilePath $filename -Encoding UTF8

    Write-Host "✅ Código guardado en: $filename" -ForegroundColor Green
    Write-Host "📄 Código generado:" -ForegroundColor Yellow
    Write-Host $code -ForegroundColor White

    return $true
}

# Función para simular pregunta a ChatGPT
function Ask-DemoQuestion {
    param([string]$Question)

    Write-Host "🤖 Enviando pregunta a ChatGPT: $Question" -ForegroundColor Cyan

    # Respuestas de ejemplo
    $responses = @{
        "¿Qué es Python?" = @"
Python es un lenguaje de programación de alto nivel, interpretado y orientado a objetos.
Fue creado por Guido van Rossum y lanzado en 1991.

Características principales:
• Sintaxis simple y legible
• Tipado dinámico
• Gestión automática de memoria
• Amplia biblioteca estándar
• Multiplataforma
• Ideal para principiantes y profesionales

Python se usa en:
• Desarrollo web (Django, Flask)
• Ciencia de datos (NumPy, Pandas)
• Inteligencia artificial (TensorFlow, PyTorch)
• Automatización y scripting
• Desarrollo de aplicaciones
"@

        "¿Qué es JavaScript?" = @"
JavaScript es un lenguaje de programación interpretado, orientado a objetos,
utilizado principalmente en el desarrollo web del lado del cliente.

Características principales:
• Ejecución en navegadores web
• Tipado dinámico
• Programación funcional y orientada a objetos
• Sintaxis similar a C/Java
• Muy versátil y flexible

JavaScript se usa en:
• Desarrollo web frontend
• Aplicaciones web (React, Vue, Angular)
• Desarrollo backend (Node.js)
• Aplicaciones móviles
• Automatización web
"@

        "¿Qué es C++?" = @"
C++ es un lenguaje de programación compilado, orientado a objetos,
que extiende las capacidades del lenguaje C.

Características principales:
• Compilado a código máquina
• Tipado estático
• Programación orientada a objetos
• Control de memoria manual
• Alto rendimiento
• Compatible con C

C++ se usa en:
• Desarrollo de sistemas
• Juegos y gráficos
• Aplicaciones de alto rendimiento
• Sistemas embebidos
• Software de sistema
"@
    }

    $response = $responses[$Question]
    if (-not $response) {
        $response = "Esta es una respuesta simulada de ChatGPT para la pregunta: '$Question'. En una implementación real, aquí aparecería la respuesta real de ChatGPT."
    }

    Write-Host "📝 Respuesta de ChatGPT:" -ForegroundColor Green
    Write-Host $response -ForegroundColor White

    return $true
}

# Modo interactivo demo
function Start-DemoInteractive {
    Write-Host "=== MODO INTERACTIVO DEMO ===" -ForegroundColor Cyan
    Write-Host "Comandos disponibles:" -ForegroundColor Yellow
    Write-Host "  /code [lenguaje] [descripción] - Generar código demo" -ForegroundColor Gray
    Write-Host "  /ask [pregunta] - Hacer pregunta demo" -ForegroundColor Gray
    Write-Host "  /exit - Salir" -ForegroundColor Gray
    Write-Host "  [texto] - Enviar mensaje demo" -ForegroundColor Gray
    Write-Host ""
    Write-Host "NOTA: Este es un demo que simula la automatización de ChatGPT" -ForegroundColor Yellow
    Write-Host ""

    while ($true) {
        $input = Read-Host "ChatGPT Demo>"

        if ($input -eq "/exit") { break }

        if ($input -like "/code *") {
            $parts = $input -split " ", 3
            if ($parts.Length -ge 3) {
                $language = $parts[1]
                $description = $parts[2]
                Generate-DemoCode -Language $language -Description $description
            } else {
                Write-Host "Uso: /code [lenguaje] [descripción]" -ForegroundColor Red
            }
        } elseif ($input -like "/ask *") {
            $question = $input.Substring(5)
            Ask-DemoQuestion -Question $question
        } else {
            Ask-DemoQuestion -Question $input
        }
    }
}

# Función principal
function Start-ChatGPTDemo {
    Write-Host "🚀 Inicializando motor ChatGPT Demo..." -ForegroundColor Cyan

    # Ejecutar comando
    switch ($Command) {
        "code" {
            if ($Language -and $Description) {
                Generate-DemoCode -Language $Language -Description $Description
            } else {
                Write-Host "Uso: .\chatgpt_demo.ps1 code [lenguaje] [descripción]" -ForegroundColor Red
            }
        }
        "ask" {
            if ($Question) {
                Ask-DemoQuestion -Question $Question
            } else {
                Write-Host "Uso: .\chatgpt_demo.ps1 ask [pregunta]" -ForegroundColor Red
            }
        }
        "interactive" {
            Start-DemoInteractive
        }
        "demo" {
            Write-Host "🎯 Ejecutando demo completo..." -ForegroundColor Green
            Write-Host ""

            # Demo 1: Generar código
            Generate-DemoCode -Language "python" -Description "función para ordenar lista"
            Write-Host ""

            # Demo 2: Hacer pregunta
            Ask-DemoQuestion -Question "¿Qué es Python?"
            Write-Host ""

            Write-Host "✅ Demo completado exitosamente!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Para usar el modo interactivo: .\chatgpt_demo.ps1 interactive" -ForegroundColor Yellow
        }
        default {
            Write-Host "Comandos disponibles:" -ForegroundColor Yellow
            Write-Host "  .\chatgpt_demo.ps1 demo - Ejecutar demo completo" -ForegroundColor Gray
            Write-Host "  .\chatgpt_demo.ps1 code [lenguaje] [descripción] - Generar código" -ForegroundColor Gray
            Write-Host "  .\chatgpt_demo.ps1 ask [pregunta] - Hacer pregunta" -ForegroundColor Gray
            Write-Host "  .\chatgpt_demo.ps1 interactive - Modo interactivo" -ForegroundColor Gray
        }
    }
}

# Ejecutar demo
Start-ChatGPTDemo
