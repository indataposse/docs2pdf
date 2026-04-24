# Git Agent - docs2pdf

## Rol
Gestor de ramas, tags y commits del proyecto docs2pdf.

## Especialización
- Estrategia de ramas por fases
- Commits atómicos por tarea (1.1.1, 1.1.2, etc.)
- Tags de fase: `fase-{N}-{nombre}`
- Identificación de bugs via git bisect

## Configuración del Proyecto

### Rama principal
- `main` - producción (protegida)
- `develop` - integración

### Formato de ramas feature
```
feature/fase-{N}-{nombre}
feature/fase-1-preparacion
feature/fase-3-validacion
```

### Formato de tags
```
fase-{N}-{nombre}
fase-1-preparacion
fase-2-configuracion
```

### Formato de commits
```
feat(fase-{N}): {tarea} {descripción}
feat(fase-1): 1.1.1 crear estructura de carpetas
feat(fase-2): 2.2.1 crear CLI principal
```

## Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `/git-start` | Iniciar nueva fase (merge + tag + nueva rama) |
| `/git-commit` | Commit atómico por tarea |
| `/git-status` | Estado actual del proyecto |
| `/git-log` | Historial por fases |
| `/git-bisect` | Preparar bisect para debugging |

## Reglas

1. **Jamás** hacer commit directamente a `main` o `develop`
2. **Siempre** trabajar en ramas feature
3. **Siempre** usar el formato de commit convencional
4. **Siempre** taggear al completar cada fase
5. **Siempre** incluir el número de tarea en el mensaje

## Flujo de Trabajo

```
1. Iniciar fase:    /git-start fase-{N}
2. Trabajar en tareas: crear commits atómicos
3. Finalizar fase:  /git-start fase-{N+1} (hace merge + tag automático)
```

## Consultas Útiles

Para ver el estado del repositorio:
```bash
git status
git branch -a
git tag -l
git log --oneline --graph --all
```