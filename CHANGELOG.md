# 📋 Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-12-19

### 🚀 Agregado
- **ChatGPT Web Automation** - Interacción real con ChatGPT web usando tokens de chat
- **Sistema de Limpieza Avanzado** - Script `clean.ps1` con múltiples opciones
- **Configuración Centralizada** - `project_config.json` para toda la configuración
- **Optimización VS Code** - Configuración específica para Cursor AI
- **Compilación Optimizada** - `build_optimized.bat` con timeouts y optimización -O2
- **Sistema de Seguridad** - Whitelist de procesos permitidos
- **Documentación Completa** - README, guías y documentación técnica

### 🔧 Mejorado
- **Rendimiento** - Optimización -O2 para compilación más rápida
- **Timeouts** - Prevención de colgadas en VS Code (15s-120s)
- **Exclusión de Archivos** - Mejor gestión de archivos innecesarios
- **IntelliSense** - Configuración específica para C++
- **Manejo de Errores** - Mejor robustez en todos los módulos

### 🧹 Limpiado
- **Archivos Obsoletos** - Eliminados scripts duplicados y versiones antiguas
- **Código Redundante** - Refactorización de funciones duplicadas
- **Documentación** - Consolidación de archivos de documentación

### 🔒 Seguridad
- **Whitelist de Procesos** - Control de acceso a navegadores específicos
- **Validación de Permisos** - Verificación de privilegios de administrador
- **Auditoría de Actividad** - Monitoreo de seguridad del sistema

### 📖 Documentación
- **README.md** - Documentación principal actualizada
- **CURSOR_AI_GUIDE.md** - Guía específica para Cursor AI
- **MEJORAS_IMPLEMENTADAS.md** - Detalles técnicos de mejoras
- **CONTRIBUTING.md** - Guía para contribuidores
- **CHANGELOG.md** - Historial de cambios

## [1.0.0] - 2024-12-18

### 🚀 Agregado
- **Monitoreo de Memoria** - Análisis en tiempo real de uso de memoria por proceso
- **Captura de GUI** - Screenshots automáticos de ventanas de aplicaciones
- **Interfaz PowerShell** - Script `monitor.ps1` como punto de entrada principal
- **Compilación Básica** - Script `build.bat` para compilar módulos C++
- **Módulos C++** - `memory_monitor.cpp`, `gui_capture.cpp`, `chatgpt_automation.cpp`

### 🔧 Mejorado
- **Detección de Ventanas** - Búsqueda inteligente de ventanas activas
- **Extracción de Texto** - Captura de texto de controles de ventana
- **Formato de Salida** - Información estructurada y legible

### 🐛 Corregido
- **Manejo de Errores** - Mejor gestión de procesos no encontrados
- **Permisos** - Verificación de acceso a procesos del sistema

---

## Tipos de Cambios

- **🚀 Agregado** - Nueva funcionalidad
- **🔧 Mejorado** - Mejoras en funcionalidad existente
- **🐛 Corregido** - Corrección de bugs
- **🧹 Limpiado** - Limpieza de código y archivos
- **🔒 Seguridad** - Mejoras de seguridad
- **📖 Documentación** - Cambios en documentación
- **⚡ Rendimiento** - Mejoras de rendimiento
- **🛠️ Herramientas** - Nuevas herramientas de desarrollo

---

## Notas de Versión

### v2.0.0
Esta versión representa una reescritura completa del sistema con:
- Integración perfecta con Cursor AI
- Automatización real de ChatGPT web
- Sistema de limpieza y mantenimiento avanzado
- Optimizaciones de rendimiento significativas

### v1.0.0
Versión inicial con funcionalidades básicas de monitoreo y captura de GUI.

---

**Para más detalles sobre cada versión, consulta los tags de Git.**
