# Comando: git-start

Inicia el trabajo en una nueva fase (después de haber cerrado la fase anterior).

## Uso
```
/git-start fase-{N}-{nombre}
```

## Ejemplo
```
/git-start fase-2-configuracion
```

## Pre-requisitos
- Haber ejecutado `/git-close` de la fase anterior
- Estar en `develop` con los cambios mergeados

## Flujo que ejecuta

1. **Verificar estado**
   - Estar en `develop`
   - No tener cambios sin commit

2. **Crear rama feature**
   ```
   git checkout -b feature/fase-{N}-{nombre}
   ```

3. **Mostrar estado**

## Diferencia con /git-close

| Comando | Qué hace |
|---------|---------|
| `/git-close` | Merge + tag + push (cierra fase) |
| `/git-start` | Crea nueva rama (inicia trabajo) |

## Parámetros

| Parámetro | Descripción | Requerido |
|-----------|-------------|-----------|
| `fase-{N}-{nombre}` | Nombre de la fase a iniciar | Sí |

## Ejemplo de salida

```
[git-start] Iniciando fase-2-configuracion
✓ Rama feature/fase-2-configuracion creada
✓ Cambiado a feature/fase-2-configuracion

Listo para trabajar en FASE 2: Configuracion
```