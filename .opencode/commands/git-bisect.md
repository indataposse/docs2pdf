# Comando: git-bisect

Prepara y ejecuta git bisect para identificar el commit que introdujo un bug.

## Uso
```
/git-bisect iniciar
/git-bisect buenas {commit}
/git-bisect malas {commit}
/git-bisect verificar {commit}
/git-bisect reset
```

## Concepto

Git bisect divide el historial en mitades para encontrar rápidamente cuál commit introdujo un bug:
1. Marcamos un commit "bueno" (sin bug)
2. Marcamos un commit "malo" (con bug)
3. Git prueba commits intermedios
4. Probamos y decimos "bueno" o "malo"
5. Repetimos hasta encontrar el commit

## Ejemplo completo

### Paso 1: Iniciar bisect
```
/git-bisect iniciar
```
Esto ejecuta: `git bisect start`

### Paso 2: Marcar commit bueno (sin bug)
```
/git-bisect buenas fase-5-descarga
```
Esto marca el tag `fase-5-descarga` como bueno.

### Paso 3: Marcar commit malo (con bug)
```
/git-bisect malas fase-7-pdf
```
Esto marca la rama actual como mala.

### Paso 4: Git bisca automaticamente
```
Git probará el commit intermedio. Ejecuta tu test y responde:
  /git-bisect verificar {commit}

Donde {commit} es el hash que Git te indica.
```

### Paso 5: Marcar verificación
```
/git-bisect buenas  # si el bug NO existe en este commit
/git-bisect malas  # si el bug SÍ existe en este commit
```

### Paso 6: Obtenemos resultado
Git identifica el commit exacto que introdujo el bug.

### Paso 7: Limpiar
```
/git-bisect reset
```

## Parámetros

| Parámetro | Descripción |
|-----------|-------------|
| `iniciar` | Inicia la sesión de bisect |
| `buenas {ref}` | Marca un commit/tag como sin bug |
| `malas {ref}` | Marca un commit/tag como con bug |
| `verificar {hash}` | Muestra el estado de un commit específico |
| `reset` | Termina la sesión de bisect |

## Fases entre tags para bisectar

| Bug en fase | Rango de bisect |
|-------------|-----------------|
| FASE 3 | `fase-2-configuracion` → `fase-3-validacion` |
| FASE 4 | `fase-3-validacion` → `fase-4-urls` |
| FASE 5 | `fase-4-urls` → `fase-5-descarga` |
| FASE 6 | `fase-5-descarga` → `fase-6-procesamiento` |
| FASE 7 | `fase-6-procesamiento` → `fase-7-pdf` |
| FASE 8 | `fase-7-pdf` → `fase-8-validacion` |

## Script de test automático

Para casos avanzados, puedes crear un script de test:

```bash
#!/bin/bash
# test_bug.sh
python -c "from docs2pdf import *; generar_pdf()"
exit $?
```

Uso:
```bash
git bisect start fase-7-pdf fase-5-descarga
git bisect run test_bug.sh
```

## Alias
- `/git-bisect`
- `/bisect`
- `/debug`