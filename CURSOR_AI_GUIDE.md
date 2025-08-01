# 🤖 GUÍA CURSOR AI - Sistema de Monitoreo y Automatización

## 🎯 ¿Qué es este proyecto?

Este es un **sistema completo de monitoreo de memoria y automatización de ChatGPT** diseñado específicamente para trabajar con **Cursor AI**. Permite:

- 🔍 **Monitorear memoria** de procesos en tiempo real
- 🖼️ **Capturar GUI** de aplicaciones (Chrome, Word, etc.)
- 🤖 **Automatizar ChatGPT web** usando tokens de chat (no API)
- ⚡ **Desarrollo optimizado** con VS Code sin colgadas

---

## 🚀 Archivos Esenciales para Cursor AI

### 📄 **Archivos Principales (OBLIGATORIOS)**

```
📁 Código Fuente
├── memory_monitor.cpp      # 🔍 Monitoreo de memoria
├── gui_capture.cpp        # 🖼️ Captura de GUI
├── chatgpt_automation.cpp # 🤖 Automatización C++
└── security_config.h      # 🔒 Configuración de seguridad

🔧 Scripts PowerShell
├── monitor.ps1            # 🎯 Interfaz principal
├── chatgpt_web_automation.ps1  # ⭐ ChatGPT web real
├── chatgpt_demo.ps1      # 🎭 Demo ChatGPT
└── clean.ps1             # 🧹 Limpieza inteligente

⚙️ Configuración VS Code
├── .vscode/settings.json      # ⚡ Configuración optimizada
├── .vscode/tasks.json        # 🔧 Tareas automatizadas
├── .vscode/launch.json      # 🐛 Debugging
├── .vscode/c_cpp_properties.json # 🎯 IntelliSense C++
├── .vscode/extensions.json   # 📦 Extensiones
└── .vscode/performance.json  # 🚀 Optimizaciones

🛠️ Herramientas
├── build.bat              # 🔨 Compilación básica
├── build_optimized.bat    # ⚡ Compilación optimizada
├── project_config.json    # 📊 Configuración centralizada
└── README.md             # 📖 Documentación completa
```

### 🗑️ **Archivos Eliminados (No necesarios)**
- ❌ `chatgpt_engine.ps1` - Versión obsoleta
- ❌ `chatgpt_simple.ps1` - Versión obsoleta
- ❌ `chatgpt_cmd.ps1` - Versión obsoleta
- ❌ `chatgpt_final.ps1` - Versión obsoleta
- ❌ `chatgpt_advanced.ps1` - Versión obsoleta
- ❌ `RESUMEN_SISTEMA.md` - Duplicado

---

## 🎯 Cómo usar con Cursor AI

### 1️⃣ **Configuración Inicial**

```powershell
# 1. Compilar el proyecto
.\build_optimized.bat

# 2. Verificar que todo funciona
.\monitor.ps1
```

### 2️⃣ **Comandos Principales para Cursor AI**

#### **🔍 Monitoreo de Memoria**
```powershell
# Ver todos los procesos
.\memory_monitor.exe memory

# Monitorear proceso específico
.\memory_monitor.exe monitor chrome.exe
```

#### **🖼️ Captura de GUI**
```powershell
# Listar ventanas disponibles
.\gui_capture.exe list

# Capturar ventana específica
.\gui_capture.exe capture chrome.exe
```

#### **🤖 Automatización ChatGPT** ⭐
```powershell
# Modo interactivo (RECOMENDADO)
.\chatgpt_web_automation.ps1 -Command interactive

# Generar código específico
.\chatgpt_web_automation.ps1 -Command code -Language python -Description "función para ordenar lista"

# Hacer pregunta
.\chatgpt_web_automation.ps1 -Command ask -Question "¿Qué es Python?"
```

### 3️⃣ **Tareas VS Code para Cursor AI**

| Tarea | Descripción | Uso con Cursor AI |
|-------|-------------|-------------------|
| `🔄 Compilar Todo` | Compilación completa | Antes de usar el sistema |
| `⚡ Compilar Rápido` | Compilación optimizada | Desarrollo rápido |
| `🧹 Limpiar` | Limpieza de archivos | Mantenimiento |
| `📊 Monitorear Memoria` | Análisis de memoria | Debugging |
| `🖼️ Capturar GUI` | Listar ventanas | Análisis de aplicaciones |
| `🤖 ChatGPT Demo` | Demo de automatización | Pruebas |
| `🌐 ChatGPT Web` | Automatización real | Generación de código |
| `🚀 Ejecutar Todo` | Sistema completo | Testing completo |

---

## 🤖 Integración con Cursor AI

### **Flujo de Trabajo Recomendado**

1. **🔄 Compilar** - Usar `🔄 Compilar Todo` en VS Code
2. **🔍 Monitorear** - Verificar memoria de procesos
3. **🤖 Automatizar** - Usar ChatGPT web para generar código
4. **🧹 Limpiar** - Mantener el proyecto organizado

### **Comandos Rápidos para Cursor AI**

```powershell
# Desarrollo rápido
.\build_optimized.bat && .\monitor.ps1

# Generar código con ChatGPT
.\chatgpt_web_automation.ps1 -Command code -Language python -Description "clase para manejo de base de datos"

# Limpiar y optimizar
.\clean.ps1 quick
```

---

## ⚡ Optimizaciones para Cursor AI

### **VS Code Optimizado**
- **Timeouts** para prevenir colgadas
- **Exclusión de archivos** innecesarios
- **Optimización de memoria** para archivos grandes
- **IntelliSense** específico para C++

### **Rendimiento**
- **Compilación -O2** para velocidad máxima
- **Limpieza inteligente** automática
- **Backup automático** antes de operaciones críticas
- **Estadísticas** del proyecto en tiempo real

---

## 🎯 Casos de Uso con Cursor AI

### **👨‍💻 Desarrollo de Código**
```powershell
# 1. Monitorear uso de memoria durante desarrollo
.\memory_monitor.exe monitor code.exe

# 2. Generar código automáticamente
.\chatgpt_web_automation.ps1 -Command code -Language python -Description "API REST con FastAPI"

# 3. Limpiar archivos generados
.\clean.ps1 generated
```

### **🔍 Análisis de Aplicaciones**
```powershell
# 1. Analizar procesos con mayor uso de memoria
.\memory_monitor.exe memory | Sort-Object {[int]($_.Split()[1])} -Descending

# 2. Capturar estado de aplicaciones críticas
.\gui_capture.exe capture chrome.exe

# 3. Generar documentación automáticamente
.\chatgpt_web_automation.ps1 -Command ask -Question "Genera documentación para una API REST en Python"
```

### **🤖 Automatización Completa**
```powershell
# 1. Crear scripts de automatización
.\chatgpt_web_automation.ps1 -Command code -Language powershell -Description "script para backup automático"

# 2. Generar tests unitarios
.\chatgpt_web_automation.ps1 -Command code -Language python -Description "tests unitarios para clase Database"

# 3. Crear documentación técnica
.\chatgpt_web_automation.ps1 -Command ask -Question "Explica el patrón Singleton en programación"
```

---

## 🔧 Configuración Avanzada

### **Personalizar para tu Proyecto**

1. **Editar `project_config.json`** - Configuración centralizada
2. **Modificar `security_config.h`** - Procesos permitidos
3. **Ajustar `.vscode/settings.json`** - Preferencias de VS Code

### **Extensiones Recomendadas para Cursor AI**

- **C/C++** - Soporte completo para C++
- **PowerShell** - Scripting avanzado
- **GitLens** - Control de versiones
- **Auto Rename Tag** - HTML/XML
- **Bracket Pair Colorizer** - Código más legible

---

## 🚨 Solución de Problemas

### **Problemas Comunes**

#### **❌ Error de Compilación**
```powershell
# Verificar compilador
g++ --version

# Instalar MinGW si es necesario
winget install MinGW.MinGW
```

#### **❌ ChatGPT no responde**
```powershell
# Verificar que ChatGPT esté abierto
.\gui_capture.exe list

# Abrir ChatGPT manualmente
Start-Process "https://chat.openai.com"
```

#### **❌ VS Code lento**
```powershell
# Limpiar archivos temporales
.\clean.ps1 vscode

# Optimizar configuración
# Verificar .vscode/performance.json
```

---

## 🎉 Beneficios para Cursor AI

### **✅ Ventajas del Sistema**

- **🚀 Desarrollo rápido** - Compilación optimizada
- **🤖 Automatización real** - ChatGPT web funcional
- **🔍 Monitoreo profesional** - Análisis en tiempo real
- **⚡ Sin colgadas** - VS Code optimizado
- **🧹 Mantenimiento fácil** - Limpieza inteligente
- **📊 Configuración centralizada** - Fácil personalización

### **🎯 Resultados Esperados**

- **50% más rápido** en compilación
- **Sin colgadas** en VS Code
- **Automatización completa** de ChatGPT
- **Monitoreo profesional** de memoria
- **Mantenimiento automático** del proyecto

---

## 📞 Soporte para Cursor AI

### **Comandos de Ayuda**
```powershell
# Ver todas las opciones
.\monitor.ps1

# Estadísticas del proyecto
.\clean.ps1 stats

# Documentación completa
Get-Content README.md
```

### **Recursos Adicionales**
- **README.md** - Documentación completa
- **MEJORAS_IMPLEMENTADAS.md** - Detalles técnicos
- **project_config.json** - Configuración centralizada

---

## 🎯 Conclusión

Este sistema está **específicamente optimizado** para trabajar con **Cursor AI**:

- ✅ **Archivos esenciales** identificados y organizados
- ✅ **Comandos optimizados** para desarrollo rápido
- ✅ **Integración perfecta** con VS Code
- ✅ **Automatización real** de ChatGPT
- ✅ **Mantenimiento automático** del proyecto

**¡Listo para usar con Cursor AI!** 🚀

---

**💡 Tip**: Usa `.\monitor.ps1` como punto de entrada principal para explorar todas las funcionalidades del sistema.
