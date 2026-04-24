# Comando: git-push

Envía commits y tags al repositorio remoto.

## Uso
```
/git-push
/git-push --tags
/git-push --force
```

## Sin parámetros
Envía la rama actual al remoto:
```bash
git push origin nombre-rama
```

## Con --tags
Envía commits y todos los tags:
```bash
git push --tags
```

## Con --force
Fuerza el push (usar con precaución):
```bash
git push --force
```

## Flujo completo

### Push después de iniciar fase
```
/git-start fase-2-configuracion
/git-push --tags
```

Resultado:
```
✓ Push feature/fase-2-configuracion
✓ Push develop
✓ Push tags: fase-1-preparacion
```

### Push de rutina
```
/git-push
```

## Parámetros

| Parámetro | Descripción | Precaución |
|-----------|-------------|------------|
| `--tags` | Incluir tags en el push | Seguro |
| `--force` | Forzar push (sobrescribe remoto) | ⚠️ Usar solo si es necesario |

## Validaciones

1. Verificar que no haya conflictos con remoto
2. Advertir si hay commits sin push
3. Advertir antes de --force

## Ejemplo de salida

```
Push a origin/feature/fase-1-preparacion:
  Contando objetos: 5, listo.
  Delta compression using up to 4 threads.
  Comprimiendo objetos: 100% (3/3), listo.
  Escribiendo objetos: 100% (3/3), 234 bytes | 78 KB/s, listo.
  Total 3 (delta 1), reused 0 (delta 0)
  A remote/feature/fase-1-preparacion

✓ Push exitoso
```

## Alias
- `/git-push`
- `/push`
- `/sync`