# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-01

### 🚀 Agregado
- **Integración completa con Cursor AI**
  - Script principal `chatgpt_web_automation.ps1`
  - Configuración JSON centralizada
  - Detección automática de Project Test
  - Generación automática de archivos de salida

- **Comandos principales**
  - `open` - Abrir Project Test automáticamente
  - `ask` - Hacer preguntas a ChatGPT
  - `code` - Generar código específico

- **Configuración avanzada**
  - Archivo `config.json` para personalización
  - Detección de login automática
  - Timeouts configurables
  - Whitelist de procesos de seguridad

- **Archivos de salida automáticos**
  - `generated_code.txt` - Código generado
  - `conversation_log.txt` - Historial de conversaciones
  - `debug.log` - Logs de debugging

- **Documentación completa**
  - README.md detallado para Cursor AI
  - Instrucciones de instalación y uso
  - Casos de uso específicos
  - Troubleshooting y debugging

### 🔧 Mejorado
- **Optimización para Chrome 100%**
  - Eliminado soporte para Edge y desktop app
  - Enfoque exclusivo en Project Test
  - Mejor rendimiento y estabilidad

- **Integración con Project Test**
  - URL específica de OpenAI
  - Detección automática de ventanas
  - Manejo de errores mejorado

### 🐛 Corregido
- **Detección de ventanas**
  - Búsqueda optimizada de Project Test
  - Validación de login mejorada
  - Manejo de timeouts

- **Generación de archivos**
  - Creación automática de carpeta output
  - Guardado correcto de logs
  - Formato de archivos consistente

### 🔒 Seguridad
- **Whitelist de procesos**
  - Solo Chrome permitido
  - Validación de URLs
  - Control de acceso específico

## [0.9.0] - 2025-07-31

### 🚀 Agregado
- **Versión beta inicial**
  - Script básico de automatización
  - Soporte para múltiples navegadores
  - Funcionalidad básica de ChatGPT

### 🔧 Mejorado
- **Compatibilidad inicial**
  - Soporte para Chrome y Edge
  - Detección básica de ventanas
  - Interacción simple con ChatGPT

---

## Notas de Versión

### Versión 1.0.0
Esta es la primera versión estable del proyecto, optimizada específicamente para Cursor AI y Project Test de OpenAI.

### Características Destacadas
- ✅ Integración perfecta con Cursor AI
- ✅ Project Test de OpenAI
- ✅ Generación automática de código
- ✅ Logs detallados y debugging
- ✅ Configuración flexible
- ✅ Documentación completa

### Próximas Versiones
- **1.1.0** - Integración con APIs
- **1.2.0** - Dashboard web
- **1.3.0** - Sistema de plugins
- **2.0.0** - Multi-navegador completo

---

*Para más detalles sobre cambios específicos, consulta los commits en el repositorio.* 