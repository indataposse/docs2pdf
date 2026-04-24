# AGENTS.md

## Tipo de Proyecto
- Proyecto Python CLI - docs2pdf

## Documentación del Proyecto
- `README.md` - Uso básico e instalación
- `DOCUMENTACION-TECNICA.md` - Arquitectura y detalles técnicos
- `TASKS.md` - Lista de tareas por fase
- `PROCEDIMIENTO-FASE-01.md` - Procedimiento paso a paso FASE 1 con script de comprobaciones

## Responsabilidades diferenciadas

### Agente principal
- Ejecutar tareas de desarrollo de cada fase
- **NO** realizar commits ni merges automáticamente
- Al completar una fase, informar al usuario

### Subagente git
- Escucha al usuario para ejecutar comandos:
  - `/git-start` → Iniciar nueva fase
  - `/git-close` → Cerrar fase actual (merge + tag)
  - `/git-commit` → Commit atómico por tarea
  - `/git-push` → Sincronizar con remoto
  - `/git-status` → Ver estado del proyecto

### Usuario
- Ordena el cierre de fase cuando está verificada
- Usa los comandos del subagente según necesidad

### Flujo esperado de cierre de fase
```
1. Agente principal completa tareas de fase
2. Usuario ejecuta script de comprobaciones
3. Usuario ordena: "Ejecuta /git-close fase-1"
4. Subagente git realiza:
   - Merge feature/fase-1 → develop
   - Crear tag fase-1-{nombre}
   - Push develop y tags
   - Informar al usuario
```

## Verificación de Fase
Después de completar cada fase, ejecutar:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\check_phase1.ps1
```

## Configuración
- Gestor de paquetes: pip
- Framework de pruebas: pytest (pendiente)
- Linter: ruff (pendiente)
- Navegador: Chrome local (CDN de Playwright bloqueado)