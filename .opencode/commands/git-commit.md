# Comando: git-commit

Crea un commit atómico por tarea.

## Uso
```
/git-commit {tarea} {descripción}
```

## Ejemplo
```
/git-commit 1.1.1 crear estructura de carpetas
```

## Flujo que ejecuta

1. **Verificar estado**
   - Estar en una rama feature
   - Tener cambios para commitear

2. **Mostrar cambios pendientes**
   - `git status`
   - `git diff --staged`
   - `git diff`

3. **Crear commit**
   - Usar formato: `feat(fase-{N}): {tarea} {descripción}`
   - Ejemplo: `feat(fase-1): 1.1.1 crear estructura de carpetas`

4. **Mostrar resultado**

## Parámetros

| Parámetro | Descripción | Requerido |
|-----------|-------------|-----------|
| `{tarea}` | Número de tarea (ej: 1.1.1) | Sí |
| `{descripción}` | Descripción breve de la tarea | Sí |

## Validaciones

- Solo commits en ramas feature
- No commitear cambios sin descripción
- Usar formato convencionales (feat/fix/docs)

## Tipos de commit permitidos

| Tipo | Uso |
|------|-----|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `docs` | Documentación |
| `refactor` | Refactorización |
| `test` | Tests |
| `chore` | Mantenimiento |

## Ejemplo de salida

```
[feature/fase-1-preparacion abc123] feat(fase-1): 1.1.1 crear estructura de carpetas

1 file changed, 4 directories created
```

## Commit atómico

Un commit atómico incluye:
- Solo los archivos de esa tarea específica
- Descripción clara y concisa
- Número de tarea en el mensaje

**Bien:**
```
feat(fase-1): 1.2.1 crear requirements.txt
```

**Mal:**
```
feat(fase-1): cambios varios
```