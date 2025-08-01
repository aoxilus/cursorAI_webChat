# 🤝 Contribuir al Sistema de Monitoreo para Cursor AI

¡Gracias por tu interés en contribuir! Este proyecto está diseñado para optimizar el desarrollo con Cursor AI.

## 🚀 Cómo Contribuir

### 1️⃣ **Fork y Clone**

```bash
# Fork el repositorio en GitHub
# Luego clona tu fork
git clone https://github.com/TU_USUARIO/memory-monitoring-cursor-ai.git
cd memory-monitoring-cursor-ai
```

### 2️⃣ **Configurar el Entorno**

```powershell
# Instalar dependencias
# Asegúrate de tener MinGW-w64 instalado
winget install MinGW.MinGW

# Compilar el proyecto
.\build_optimized.bat

# Verificar que todo funciona
.\monitor.ps1
```

### 3️⃣ **Crear una Rama**

```bash
git checkout -b feature/nueva-funcionalidad
# o
git checkout -b fix/correccion-bug
```

### 4️⃣ **Desarrollar**

- **Sigue las convenciones** del proyecto
- **Mantén el código limpio** y bien documentado
- **Prueba tus cambios** antes de commitear
- **Usa los scripts de limpieza** para mantener el proyecto organizado

### 5️⃣ **Commit y Push**

```bash
git add .
git commit -m "feat: agregar nueva funcionalidad de monitoreo"
git push origin feature/nueva-funcionalidad
```

### 6️⃣ **Crear Pull Request**

- Ve a tu fork en GitHub
- Crea un Pull Request
- Describe claramente los cambios
- Incluye ejemplos de uso si es necesario

## 📋 Convenciones del Proyecto

### **Estructura de Commits**

```
tipo: descripción breve

feat: nueva funcionalidad
fix: corrección de bug
docs: documentación
style: formato de código
refactor: refactorización
test: pruebas
chore: tareas de mantenimiento
```

### **Estructura de Archivos**

```
📁 Código Fuente (.cpp, .h)
├── memory_monitor.cpp      # Monitoreo de memoria
├── gui_capture.cpp        # Captura de GUI
├── chatgpt_automation.cpp # Automatización C++
└── security_config.h      # Configuración de seguridad

🔧 Scripts PowerShell (.ps1)
├── monitor.ps1            # Interfaz principal
├── chatgpt_web_automation.ps1  # ChatGPT web real
├── chatgpt_demo.ps1      # Demo ChatGPT
└── clean.ps1             # Limpieza inteligente

⚙️ Configuración (.json, .bat)
├── .vscode/              # Configuración VS Code/Cursor AI
├── build.bat             # Compilación básica
├── build_optimized.bat   # Compilación optimizada
└── project_config.json   # Configuración centralizada
```

### **Estándares de Código**

#### **C++**
- **Indentación**: 4 espacios
- **Nombres**: camelCase para variables, PascalCase para clases
- **Comentarios**: En español, claros y concisos
- **Headers**: Incluir descripción de la clase al inicio

#### **PowerShell**
- **Indentación**: 4 espacios
- **Nombres**: Verb-Noun para funciones
- **Comentarios**: En español, explicar lógica compleja
- **Manejo de errores**: Usar try-catch cuando sea apropiado

## 🎯 Áreas de Contribución

### **Funcionalidades Nuevas**
- [ ] **Monitoreo de red** - Análisis de conexiones
- [ ] **Dashboard web** - Interfaz gráfica
- [ ] **Sistema de alertas** - Notificaciones automáticas
- [ ] **Análisis de archivos** - Detección de malware
- [ ] **Integración con APIs** - Servicios externos

### **Mejoras de Rendimiento**
- [ ] **Compilación paralela** - Más rápida
- [ ] **Optimización de memoria** - Menor uso de RAM
- [ ] **Caché inteligente** - Resultados más rápidos
- [ ] **Lazy loading** - Carga bajo demanda

### **Documentación**
- [ ] **Tutoriales paso a paso** - Para principiantes
- [ ] **Ejemplos de uso** - Casos reales
- [ ] **API documentation** - Referencia técnica
- [ ] **Videos demostrativos** - Guías visuales

### **Testing**
- [ ] **Unit tests** - Para funciones individuales
- [ ] **Integration tests** - Para módulos completos
- [ ] **Performance tests** - Para rendimiento
- [ ] **Security tests** - Para vulnerabilidades

## 🔧 Herramientas de Desarrollo

### **Scripts Útiles**

```powershell
# Compilar con optimización
.\build_optimized.bat

# Limpiar archivos generados
.\clean.ps1 quick

# Ver estadísticas del proyecto
.\clean.ps1 stats

# Probar ChatGPT web
.\chatgpt_web_automation.ps1 -Command interactive
```

### **VS Code/Cursor AI Tasks**

- `🔄 Compilar Todo` - Compilación completa
- `⚡ Compilar Rápido` - Compilación optimizada
- `🧹 Limpiar` - Limpieza de archivos
- `🌐 ChatGPT Web` - Automatización real

## 🐛 Reportar Bugs

### **Antes de Reportar**

1. **Verifica** que el bug no esté ya reportado
2. **Prueba** con la última versión
3. **Reproduce** el problema paso a paso
4. **Incluye** información del sistema

### **Template de Bug Report**

```markdown
## 🐛 Descripción del Bug

### Pasos para Reproducir
1. Ejecutar `.\monitor.ps1`
2. Seleccionar opción X
3. Ver error Y

### Comportamiento Esperado
- Debería hacer Z

### Comportamiento Actual
- Hace W en su lugar

### Información del Sistema
- OS: Windows 10/11
- PowerShell: 7.x
- Compilador: MinGW-w64
- Versión del proyecto: X.Y.Z

### Logs/Errores
```
Error específico aquí
```

### Screenshots
[Si aplica]
```

## 🚀 Solicitar Features

### **Template de Feature Request**

```markdown
## 🚀 Nueva Funcionalidad

### Descripción
Explicar qué funcionalidad se necesita

### Caso de Uso
Cómo se usaría en la práctica

### Alternativas Consideradas
Otras opciones evaluadas

### Información Adicional
Contexto adicional relevante
```

## 📞 Contacto

- **Issues**: Usa GitHub Issues para bugs y features
- **Discussions**: Para preguntas y discusiones generales
- **Wiki**: Para documentación adicional

## 🎉 Reconocimientos

- **Contribuidores** serán mencionados en el README
- **Pull Requests** destacados serán promocionados
- **Bugs críticos** serán atendidos prioritariamente

---

**¡Gracias por contribuir al ecosistema de Cursor AI!** 🚀
