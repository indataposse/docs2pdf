# docs2pdf

Herramienta CLI en Python que convierte documentación web a PDF navegable con TOC, portada con metadata y buscador de texto.

## Descripción

Descarga páginas de documentación desde una URL, las procesa y genera un PDF único con:
- Tabla de contenidos navegable
- Portada con metadata (título, fecha, número de páginas)
- Buscador de palabras clave
- Hipervínculos internos funcionales

## Requisitos

- Python 3.10+
- Playwright
- Navegador Chromium (instalado vía Playwright)
- Windows/macOS/Linux

## Instalación

1. Clonar el repositorio:
```bash
git clone <repositorio>
cd docs2pdf
```

2. Instalar dependencias:
```bash
pip install -r requirements.txt
playwright install chromium
```

## Uso

### Uso básico (usa config.json)
```bash
python docs2pdf.py
```

### Con parámetros personalizados
```bash
python docs2pdf.py -u "https://opencode.ai/docs/es/" -o "./output/" -n "opencode.ai"
```

### Parámetros

| Parámetro | Descripción | Valor por defecto |
|-----------|-------------|-------------------|
| `-u, --url` | URL del sitio de documentación | config.json |
| `-o, --output` | Carpeta de salida | ./output/ |
| `-n, --name` | Nombre del PDF (sin extensión) | dominio del sitio |

## Estructura de carpetas

```
docs2pdf/
├── docs2pdf.py              # CLI principal
├── config.json              # Configuración
├── requirements.txt         # Dependencias
├── output/                  # PDF final generado
├── logs/                    # Archivos de log
└── temp/                    # Archivos temporales (se borra al final)
```

## Configuración

Editar `config.json` para personalizar:

```json
{
  "sitio_web": "https://opencode.ai/docs/es/",
  "carpeta_salida": "./output/",
  "pdf_settings": {
    "format": "A4",
    "print_background": true,
    "toc": true,
    "margin": "2cm"
  }
}
```

## Fases de ejecución

1. **FASE 1**: Preparación y descarga de recursos
2. **FASE 2**: Configuración del proyecto
3. **FASE 3**: Validación de entorno
4. **FASE 4**: Recolección de URLs
5. **FASE 5**: Descarga de HTML
6. **FASE 6**: Procesamiento de HTML
7. **FASE 7**: Generación del PDF
8. **FASE 8**: Validación
9. **FASE 9**: Entrega final

Ver `PROCEDIMIENTO-FASE-01.md` para el procedimiento detallado de la primera fase.

## Licencia

MIT
