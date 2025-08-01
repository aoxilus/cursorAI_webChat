# 🤖 ChatGPT Web Automation - Cursor AI Integration

Sistema de automatización avanzado para **Cursor AI** que permite interactuar directamente con **Project Test de OpenAI** usando Chrome. Genera código, responde preguntas y mantiene logs automáticos.

## 🎯 Características Principales

- ✅ **Chrome 100%** - Optimizado exclusivamente para Chrome
- 🎯 **Project Test** - Integración directa con OpenAI Project Test
- 🤖 **Automatización Real** - Interacción directa con ChatGPT web
- ⚡ **Tokens Ilimitados** - Usa ChatGPT web, no API
- 📁 **Archivos Automáticos** - Generación y guardado automático
- 🔒 **Detección de Login** - Verifica estado de autenticación
- 🚀 **Cursor AI Ready** - Configuración optimizada para desarrollo

## 🛠️ Instalación para Cursor AI

### Requisitos Previos

```bash
# Windows 10/11 con PowerShell 7
# Chrome instalado
# Cursor AI con extensiones PowerShell
```

### Instalación Rápida

```powershell
# 1. Clonar repositorio
git clone <repository-url>
cd memory

# 2. Verificar archivos
ls -la

# 3. Probar instalación
.\chatgpt_web_automation.ps1 -Command open
```

## 🎮 Uso con Cursor AI

### Comandos Principales

```powershell
# 🚀 Abrir Project Test automáticamente
.\chatgpt_web_automation.ps1 -Command open

# ❓ Hacer pregunta técnica
.\chatgpt_web_automation.ps1 -Command ask -Question "¿Cómo optimizar código Python?"

# 💻 Generar código específico
.\chatgpt_web_automation.ps1 -Command code -Question "función para validar email"
```

### Flujo de Trabajo con Cursor AI

1. **Abrir Project Test:**
   ```powershell
   .\chatgpt_web_automation.ps1 -Command open
   ```

2. **Generar código para tu proyecto:**
   ```powershell
   .\chatgpt_web_automation.ps1 -Command code -Question "clase para manejo de base de datos SQLite"
   ```

3. **Consultar mejores prácticas:**
   ```powershell
   .\chatgpt_web_automation.ps1 -Command ask -Question "patrones de diseño en JavaScript"
   ```

4. **Revisar archivos generados:**
   ```powershell
   # Ver código generado
   cat output/generated_code.txt
   
   # Ver historial de conversaciones
   cat output/conversation_log.txt
   ```

## 🔧 Configuración Avanzada

### Configuración JSON

El archivo `config.json` permite personalizar:

```json
{
  "project_test": {
    "url": "https://chatgpt.com/g/g-p-688427888348819183c00555973ff94e-project-test/project",
    "detection": {
      "login_required": true,
      "login_selectors": ["button[data-testid='login-button']"],
      "logged_in_selectors": [".chat-container"]
    }
  },
  "output": {
    "files": {
      "generated_code": "generated_code.{language}",
      "conversation_log": "conversation_log.txt",
      "debug_log": "debug.log"
    },
    "auto_save": true
  }
}
```

### Personalización para Cursor AI

1. **Modificar URL de Project Test:**
   ```json
   "url": "tu-url-específica-de-project-test"
   ```

2. **Cambiar formato de archivos:**
   ```json
   "generated_code": "mi_codigo_{language}.{extension}"
   ```

3. **Ajustar timeouts:**
   ```json
   "timeout": 45,
   "wait_time": 3000
   ```

## 📁 Estructura del Proyecto

```
memory/
├── 📄 Scripts Principales
│   ├── chatgpt_web_automation.ps1  # 🚀 Script principal
│   └── config.json                 # ⚙️ Configuración
│
├── 📦 Archivos de Sistema
│   ├── cursorAI_chatgpt.exe        # 🔧 Ejecutable
│   ├── README.md                   # 📖 Documentación
│   └── .gitignore                  # 🚫 Archivos ignorados
│
└── 📊 Archivos Generados (output/)
    ├── generated_code.txt          # 💻 Código generado
    ├── conversation_log.txt        # 💬 Historial de chat
    └── debug.log                   # 🐛 Logs de debug
```

## 🚀 Casos de Uso con Cursor AI

### Desarrollo de Aplicaciones

```powershell
# Generar estructura de proyecto
.\chatgpt_web_automation.ps1 -Command code -Question "estructura de proyecto React con TypeScript"

# Crear componentes
.\chatgpt_web_automation.ps1 -Command code -Question "componente React para formulario de login"

# Generar APIs
.\chatgpt_web_automation.ps1 -Command code -Question "API REST con Express.js y MongoDB"
```

### Debugging y Optimización

```powershell
# Analizar problemas de rendimiento
.\chatgpt_web_automation.ps1 -Command ask -Question "cómo optimizar consultas SQL lentas"

# Revisar mejores prácticas
.\chatgpt_web_automation.ps1 -Command ask -Question "patrones anti-patterns en JavaScript"

# Generar tests
.\chatgpt_web_automation.ps1 -Command code -Question "tests unitarios con Jest para función de validación"
```

### Documentación

```powershell
# Generar documentación técnica
.\chatgpt_web_automation.ps1 -Command ask -Question "cómo documentar una API REST"

# Crear README
.\chatgpt_web_automation.ps1 -Command code -Question "README.md para proyecto Node.js"

# Documentar funciones
.\chatgpt_web_automation.ps1 -Command ask -Question "mejores prácticas para documentar código Python"
```

## ⚡ Optimizaciones para Cursor AI

### Configuración de Rendimiento

1. **Timeouts Optimizados:**
   - Respuesta rápida: 10-15 segundos
   - Generación de código: 20-30 segundos
   - Timeout máximo: 45 segundos

2. **Gestión de Memoria:**
   - Limpieza automática de archivos temporales
   - Logs rotativos para evitar archivos grandes
   - Compresión de respuestas largas

3. **Integración con Cursor AI:**
   - Compatible con extensiones PowerShell
   - Soporte para autocompletado
   - Integración con terminal integrado

### Flujo de Trabajo Optimizado

```powershell
# 1. Iniciar sesión en Project Test
.\chatgpt_web_automation.ps1 -Command open

# 2. Generar código para tu proyecto actual
.\chatgpt_web_automation.ps1 -Command code -Question "función para el archivo actual"

# 3. Revisar y copiar código generado
Get-Content output/generated_code.txt

# 4. Integrar en tu proyecto Cursor AI
# (Copiar y pegar el código generado)
```

## 🔒 Seguridad y Privacidad

### Características de Seguridad

- ✅ **Whitelist de procesos** - Solo Chrome permitido
- ✅ **Validación de login** - Verifica autenticación
- ✅ **Control de acceso** - Solo Project Test específico
- ✅ **Logs seguros** - Sin información sensible

### Configuración de Privacidad

```json
{
  "security": {
    "allowed_processes": ["chrome.exe"],
    "allowed_urls": ["chatgpt.com"],
    "log_sensitive_data": false
  }
}
```

## 🐛 Troubleshooting

### Problemas Comunes

1. **"No se encontró Project Test"**
   ```powershell
   # Verificar que Chrome esté abierto
   Get-Process chrome
   
   # Abrir Project Test manualmente
   .\chatgpt_web_automation.ps1 -Command open
   ```

2. **"Usuario no logueado"**
   ```powershell
   # Ir a Project Test y hacer login
   # Luego ejecutar el comando nuevamente
   ```

3. **"Error de timeout"**
   ```powershell
   # Aumentar timeout en config.json
   "timeout": 60
   ```

### Debug Avanzado

```powershell
# Ver logs detallados
Get-Content output/debug.log

# Verificar configuración
Get-Content config.json | ConvertFrom-Json

# Probar conexión
.\chatgpt_web_automation.ps1 -Command ask -Question "test"
```

## 📊 Monitoreo y Logs

### Archivos de Log

- **`conversation_log.txt`** - Historial completo de conversaciones
- **`debug.log`** - Logs técnicos para debugging
- **`generated_code.txt`** - Código generado más reciente

### Análisis de Uso

```powershell
# Ver estadísticas de uso
Get-Content output/conversation_log.txt | Measure-Object -Line

# Buscar conversaciones específicas
Select-String "Python" output/conversation_log.txt

# Ver código generado recientemente
Get-Content output/generated_code.txt
```

## 🚀 Próximas Mejoras

### Roadmap

- [ ] **Integración con APIs** - Conexión directa con APIs
- [ ] **Dashboard Web** - Interfaz visual para monitoreo
- [ ] **Sistema de Plugins** - Extensiones para diferentes lenguajes
- [ ] **CI/CD Integration** - Automatización en pipelines
- [ ] **Multi-navegador** - Soporte para Edge y Firefox

### Contribuciones

Para contribuir al proyecto:

1. Fork el repositorio
2. Crear rama para feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -am 'Agregar nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

## 📞 Soporte

### Recursos de Ayuda

- **Documentación:** Este README
- **Issues:** GitHub Issues
- **Discusiones:** GitHub Discussions
- **Wiki:** Documentación técnica detallada

### Contacto

- **Email:** soporte@proyecto.com
- **Discord:** Comunidad de desarrolladores
- **Telegram:** Canal de notificaciones

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

---

## 🎉 Conclusión

Este sistema de automatización está **optimizado específicamente para Cursor AI** y proporciona:

- **Integración perfecta** con el flujo de trabajo de Cursor AI
- **Generación automática** de código y documentación
- **Tokens ilimitados** usando Project Test de OpenAI
- **Configuración flexible** para diferentes proyectos
- **Logs detallados** para debugging y análisis

**¡Listo para acelerar tu desarrollo con Cursor AI!** 🚀

---

*Desarrollado con ❤️ para la comunidad de Cursor AI*
