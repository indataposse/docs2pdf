# Comando: git-log

Muestra el historial de commits por fases.

## Uso
```
/git-log
/git-log fase-{N}
/git-log --all
```

## Sin parámetros
Muestra todos los commits de la rama actual con formato:

```
* abc123 (HEAD -> feature/fase-2-configuracion) feat(fase-2): 2.1.1 crear config.json
* def456 feat(fase-2): 2.2.1 crear CLI principal
* ghi789 (tag: fase-1-preparacion) feat(fase-1): 1.5.2 verificar integridad
*
```

## Con parámetro de fase
```
/git-log fase-1
```

Muestra solo commits de FASE 1:

```
feat(fase-1): 1.1.1 crear estructura de carpetas
feat(fase-1): 1.1.2 crear subcarpetas
feat(fase-1): 1.2.1 crear requirements.txt
feat(fase-1): 1.3.1 instalar dependencias
feat(fase-1): 1.3.2 instalar playwright chromium
feat(fase-1): 1.3.3 verificar instalación
feat(fase-1): 1.4.1 verificar wget disponible
feat(fase-1): 1.4.2 descargar documentación
feat(fase-1): 1.5.1 verificar archivos descargados
feat(fase-1): 1.5.2 generar reporte de descarga
```

## Opción --all
```
/git-log --all
```

Muestra todas las ramas y sus commits.

## Formato de salida

### Por defecto
```bash
git log --oneline --graph --decorate --format="%C(bold yellow)%h%C(reset) %C(white)%s%C(reset) %C(dim white)(%ar)%C(reset)%C(bold green)%d%C(reset)"
```

### Por fase (para debugging)
```bash
git log --oneline --all --grep="feat(fase-1)" --no-merges
```

## Alias
- `/git-log`
- `/log`
- `/history`