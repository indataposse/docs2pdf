# Comando: git-status

Muestra el estado actual del proyecto.

## Uso
```
/git-status
```

## Muestra

### 1. Rama actual y fase
```
Rama: feature/fase-1-preparacion (FASE 1)
```

### 2. Estado de git
```
Estado de git:
  - Cambios sin commit: X archivos
  - Commits sin pushear: Y
  - Ahead/Behind de origin: A/B
```

### 3. Historial reciente
```
Últimos commits:
  abc123 - feat(fase-1): 1.1.1 crear estructura de carpetas
  def456 - feat(fase-1): 1.2.1 crear requirements.txt
```

### 4. Progreso de fase
```
Progreso FASE 1:
  ✓ 1.1.1 Crear estructura de carpetas
  ✓ 1.1.2 Crear subcarpetas
  ○ 1.2.1 Crear requirements.txt
  ○ 1.3.1 Instalar dependencias
```

### 5. Tags recientes
```
Tags recientes:
  fase-1-preparacion (más reciente)
```

## Alias
- `/git-status`
- `/status`
- `/git`