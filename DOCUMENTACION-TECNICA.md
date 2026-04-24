# Documentación Técnica

## Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        FASE 1: Preparación                       │
│  - Crear estructura de carpetas                                  │
│  - Crear requirements.txt                                        │
│  - Instalar dependencias                                          │
│  - Descargar documentación completa (wget)                       │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     FASE 2: Configuración                        │
│  - Crear config.json                                             │
│  - Crear CLI principal (docs2pdf.py)                             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 3: Validación de entorno                  │
│  - Verificar Python >= 3.10                                     │
│  - Verificar Playwright instalado                                │
│  - Verificar conectividad                                        │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     FASE 4: Recolección de URLs                  │
│  - Scrapear índice del sitio                                     │
│  - Filtrar y guardar URLs                                        │
│  - Validar URLs (HTTP 200)                                      │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FASE 5: Descarga de HTML                    │
│  - Crear estructura de carpetas                                   │
│  - Descargar cada página con Playwright                          │
│  - Validar descargas                                             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 6: Procesamiento de HTML                  │
│  - Limpiar HTML (scripts, estilos innecesarios)                  │
│  - Generar TOC desde headings                                    │
│  - Crear portada con metadata                                    │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 7: Generación del PDF                     │
│  - Configurar opciones de PDF                                     │
│  - Convertir cada página a PDF                                   │
│  - Combinar en un solo PDF                                       │
│  - Agregar metadatos                                             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 8: Validación                       │
│  - Verificar PDF generado                                        │
│  - Probar funcionalidades (buscador, TOC, enlaces)              │
│  - Generar reporte de validación                                 │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FASE 9: Entrega final                        │
│  - Mover PDF a carpeta de salida                                  │
│  - Renombrar según formato {nombre_sitio}.pdf                    │
│  - Limpiar archivos temporales                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Dependencias y Versiones

| Paquete | Versión mínima | Propósito |
|---------|----------------|-----------|
| playwright | >=1.40.0 | Automatización de navegador, generación PDF |
| requests | >=2.31.0 | Descarga de páginas HTTP |
| beautifulsoup4 | >=4.12.0 | Parsing y limpieza de HTML |
| lxml | >=4.9.0 | Parser HTML rápido |
| Jinja2 | >=3.1.0 | Generación de plantillas HTML |

## Configuración Detallada

### config.json

```json
{
  "sitio_web": "https://opencode.ai/docs/es/",
  "carpeta_salida": "./output/",
  "pdf_settings": {
    "format": "A4",
    "print_background": true,
    "toc": true,
    "margin": "2cm"
  },
  "retry": {
    "max_attempts": 3,
    "delay_seconds": 2
  }
}
```

### Opciones de PDF (Playwright)

| Opción | Valores posibles | Descripción |
|--------|------------------|-------------|
| format | A4, Letter, A3 | Formato de página |
| print_background | true, false | Imprimir colores de fondo |
| toc | true, false | Generar tabla de contenidos |
| margin | string (ej: "2cm") | Margen de página |

## Formato de Archivos JSON Intermedios

### urls.json
```json
[
  {
    "title": "Introducción",
    "url": "https://opencode.ai/docs/es/",
    "order": 1
  },
  {
    "title": "Configuración",
    "url": "https://opencode.ai/docs/es/config/",
    "order": 2
  }
]
```

### download_manifest.json
```json
{
  "total": 40,
  "success": 38,
  "failed": 2,
  "pages": [
    {"url": "...", "status": "success", "size_bytes": 12345},
    {"url": "...", "status": "failed", "error": "Timeout"}
  ]
}
```

### toc.json
```json
[
  {
    "title": "Introducción",
    "level": 1,
    "page": 1
  },
  {
    "title": "Instalar",
    "level": 1,
    "page": 3
  }
]
```

### validation_report.json
```json
{
  "pages_downloaded": 40,
  "pages_failed": 0,
  "pdf_size_mb": 15.2,
  "total_time_minutes": 12,
  "search_working": true,
  "toc_working": true,
  "hyperlinks_working": true
}
```

## CLI docs2pdf.py

### Argumentos

```bash
python docs2pdf.py [-h] [-u URL] [-o OUTPUT] [-n NAME] [-v]
```

| Argumento | Descripción |
|-----------|-------------|
| `-h, --help` | Mostrar ayuda |
| `-u, --url` | URL del sitio de documentación |
| `-o, --output` | Carpeta de salida |
| `-n, --name` | Nombre del PDF (sin extensión) |
| `-v, --verbose` | Modo verboso |

## Limitaciones Conocidas

1. **JavaScript dinámico**: Algunas páginas con contenido cargado dinámicamente pueden requerir wait times adicionales
2. **Rutas relativas**: Imágenes con rutas relativas pueden no verse si no se procesan correctamente
3. **PDF muy grandes**: PDFs con >1000 páginas pueden tardar significativamente más
4. **Redirecciones**: URLs con redirecciones múltiples puedenfallar si no se manejan

## Logging

- **Ubicación**: `logs/{nombre_sitio}.log`
- **Nivel**: INFO por defecto, DEBUG con `-v`
- **Formato**: `[YYYY-MM-DD HH:MM:SS] [NIVEL] Mensaje`

## Tests de Verificación

Ejecutar script de comprobaciones:
```bash
powershell -File .\check_phase1.ps1
```

Ver `PROCEDIMIENTO-FASE-01.md` para más detalles.
