# Comando: git-close

Cierra la fase actual: hace merge, crea tag y sincroniza con remoto.

## Uso
```
/git-close fase-{N}-{nombre}
```

## Ejemplo
```
/git-close fase-1-preparacion
```

## Pre-requisitos
- Haber completado todas las tareas de la fase
- Haber ejecutado script de comprobaciones
- No tener cambios pendientes en la rama

## Flujo que ejecuta

1. **Validaciones**
   - Verificar que no hay cambios sin commit
   - Confirmar que la verificación de fase pasó

2. **Merge a develop**
   ```
   git checkout develop
   git merge feature/fase-{N}-{nombre} --no-ff -m "Merge feature/fase-{N}-{nombre} into develop"
   ```

3. **Crear tag**
   ```
   git tag "fase-{N}-{nombre}"
   ```

4. **Push**
   ```
   git push origin develop
   git push --tags
   ```

5. **Cambiar a main para futuras integraciones**
   ```
   git checkout main
   git merge develop
   ```

## Parámetros

| Parámetro | Descripción | Requerido |
|-----------|-------------|-----------|
| `fase-{N}-{nombre}` | Nombre de la fase a cerrar | Sí |

## Validaciones

- No ejecutar si hay cambios sin commit
- Verificar que la fase no esté ya cerrada (tag no existe)
- Confirmar antes de hacer merge

## Ejemplo de salida

```
[git-close] Cerrando fase-1-preparacion
✓ Validaciones pasadas
✓ Merge feature/fase-1-preparacion → develop
✓ Tag creado: fase-1-preparacion
✓ Push develop
✓ Push tags

FASE 1 cerrada exitosamente
Listo para comenzar FASE 2
```

## Alias
- `/git-close`