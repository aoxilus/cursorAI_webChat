# Contributing to ChatGPT Web Automation

¡Gracias por tu interés en contribuir a este proyecto! Este documento proporciona las pautas para contribuir al sistema de automatización de ChatGPT para Cursor AI.

## 🚀 Cómo Contribuir

### Tipos de Contribuciones

Aceptamos los siguientes tipos de contribuciones:

- 🐛 **Bug Reports** - Reportar errores encontrados
- 💡 **Feature Requests** - Solicitar nuevas funcionalidades
- 📝 **Documentation** - Mejorar documentación
- 🔧 **Code Improvements** - Mejorar código existente
- 🧪 **Testing** - Probar y validar funcionalidades

## 📋 Antes de Contribuir

### Requisitos

- Windows 10/11 con PowerShell 7
- Chrome instalado
- Cursor AI (opcional pero recomendado)
- Conocimientos básicos de PowerShell

### Configuración del Entorno

1. **Fork el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/chatgpt-web-automation.git
   cd chatgpt-web-automation
   ```

2. **Instalar dependencias**
   ```powershell
   # Verificar PowerShell 7
   $PSVersionTable.PSVersion
   
   # Verificar Chrome
   Get-Process chrome -ErrorAction SilentlyContinue
   ```

3. **Probar instalación**
   ```powershell
   .\chatgpt_web_automation.ps1 -Command open
   ```

## 🔧 Proceso de Desarrollo

### 1. Crear una Rama

```bash
git checkout -b feature/nueva-funcionalidad
# o
git checkout -b fix/correccion-error
```

### 2. Hacer Cambios

- **Sigue las convenciones de código**
- **Prueba tus cambios**
- **Actualiza documentación si es necesario**

### 3. Commit y Push

```bash
git add .
git commit -m "feat: agregar nueva funcionalidad X"
git push origin feature/nueva-funcionalidad
```

### 4. Crear Pull Request

- Describe claramente los cambios
- Incluye ejemplos de uso
- Menciona cualquier breaking change

## 📝 Convenciones de Código

### PowerShell

```powershell
# ✅ Correcto
function Get-UserData {
    param([string]$userId)
    
    if (-not $userId) {
        Write-Host "❌ User ID requerido" -ForegroundColor Red
        return $null
    }
    
    # Lógica aquí
}

# ❌ Incorrecto
function getUserData($userId) {
    if (!$userId) {
        return null
    }
}
```

### Nombres de Archivos

- **Scripts PowerShell:** `verb-noun.ps1`
- **Configuración:** `config.json`
- **Documentación:** `README.md`, `CONTRIBUTING.md`

### Mensajes de Commit

Usa el formato convencional:

```
type(scope): description

feat: agregar nueva funcionalidad de logging
fix: corregir detección de ventanas
docs: actualizar README
test: agregar tests para nueva función
```

## 🧪 Testing

### Pruebas Requeridas

Antes de hacer commit, ejecuta:

```powershell
# 1. Probar apertura de Project Test
.\chatgpt_web_automation.ps1 -Command open

# 2. Probar pregunta simple
.\chatgpt_web_automation.ps1 -Command ask -Question "test"

# 3. Probar generación de código
.\chatgpt_web_automation.ps1 -Command code -Question "función simple"

# 4. Verificar archivos generados
Get-ChildItem output/
```

### Checklist de Testing

- [ ] Script se ejecuta sin errores
- [ ] Project Test se abre correctamente
- [ ] Preguntas se envían y reciben respuestas
- [ ] Archivos se generan en carpeta output
- [ ] Logs se crean correctamente
- [ ] Configuración JSON se lee sin problemas

## 📋 Reportar Issues

### Template para Bug Reports

```markdown
## 🐛 Bug Report

### Descripción
Descripción clara del problema.

### Pasos para Reproducir
1. Ejecutar comando X
2. Hacer acción Y
3. Ver error Z

### Comportamiento Esperado
Lo que debería pasar.

### Comportamiento Actual
Lo que realmente pasa.

### Información del Sistema
- Windows: [versión]
- PowerShell: [versión]
- Chrome: [versión]
- Cursor AI: [versión]

### Logs
```
[Pegar contenido de output/debug.log]
```

### Screenshots
[Si aplica]
```

### Template para Feature Requests

```markdown
## 💡 Feature Request

### Descripción
Descripción clara de la nueva funcionalidad.

### Caso de Uso
Cómo se usaría esta funcionalidad.

### Alternativas Consideradas
Otras opciones que consideraste.

### Información Adicional
Cualquier contexto adicional.
```

## 🏷️ Etiquetas de Issues

- `bug` - Error en el código
- `enhancement` - Nueva funcionalidad
- `documentation` - Mejoras en documentación
- `good first issue` - Bueno para principiantes
- `help wanted` - Necesita ayuda
- `question` - Pregunta sobre el proyecto

## 📚 Recursos

### Documentación

- [README.md](README.md) - Documentación principal
- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios
- [config.json](config.json) - Configuración del sistema

### Comunidad

- **Discord:** [Enlace al servidor]
- **Telegram:** [Enlace al canal]
- **Email:** soporte@proyecto.com

## 🎯 Roadmap

### Próximas Funcionalidades

- [ ] Integración con APIs de OpenAI
- [ ] Dashboard web para monitoreo
- [ ] Sistema de plugins
- [ ] Soporte multi-navegador
- [ ] Integración con CI/CD

### Áreas de Mejora

- [ ] Optimización de rendimiento
- [ ] Mejoras en detección de ventanas
- [ ] Sistema de logging avanzado
- [ ] Configuración más flexible

## 🙏 Agradecimientos

Gracias a todos los contribuidores que han ayudado a hacer este proyecto mejor:

- [Lista de contribuidores]

---

**¡Gracias por contribuir a hacer este proyecto mejor para la comunidad de Cursor AI!** 🚀 