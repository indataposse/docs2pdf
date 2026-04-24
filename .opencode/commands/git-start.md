# Comando: git-start

Inicia una nueva fase de desarrollo.

## Uso
```
/git-start fase-{N}-{nombre}
```

## Ejemplo
```
/git-start fase-3-validacion
```

## Flujo que ejecuta

1. **Verificar estado**
   - Estar en una rama feature
   - No tener cambios sin commit

2. **Si es primera fase (FASE 1)**
   - Crear `develop` desde `main`
   - Crear `feature/fase-1-{nombre}` desde `develop`
   - Cambiar a la nueva rama

3. **Si no es primera fase (FASE N > 1)**
   - Hacer commit de cambios pendientes (si existen)
   - Merge `feature/fase-{N-1}-{nombre}` a `develop`
   - Crear tag `fase-{N-1}-{nombre}` en el merge commit
   - Push `develop` y tags
   - Crear `feature/fase-{N}-{nombre}` desde `develop`
   - Cambiar a la nueva rama

## Parámetros

| Parámetro | Descripción | Requerido |
|-----------|-------------|-----------|
| `fase-{N}-{nombre}` | Nombre de la fase a iniciar | Sí |

## Validaciones

- No ejecutar si hay cambios sin commit
- Verificar que la rama no exista previamente
- Confirmar antes de hacer merge

## Ejemplo de salida

```
✓ Commits guardados
✓ Merge feature/fase-2-configuracion → develop
✓ Tag creado: fase-2-configuracion
✓ develop pushado
✓ Rama creada: feature/fase-3-validacion
✓ Cambiado a feature/fase-3-validacion

Listo para comenzar FASE 3: Validación
```