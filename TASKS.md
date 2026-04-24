# Tareas por Fase

## FASE 1: Preparación (Descarga de recursos)

### 1.1 Crear estructura del proyecto
- 1.1.1 Crear carpeta raíz del proyecto
- 1.1.2 Crear subcarpeta output/
- 1.1.3 Crear subcarpeta temp/
- 1.1.4 Crear subcarpeta logs/

### 1.2 Crear requirements.txt
- 1.2.1 Definir dependencias del proyecto

### 1.3 Instalar dependencias
- 1.3.1 Instalar paquetes Python
- 1.3.2 Instalar Playwright chromium

### 1.4 Descargar documentación
- 1.4.1 Verificar wget disponible
- 1.4.2 Ejecutar descarga completa del sitio

### 1.5 Verificar integridad
- 1.5.1 Verificar archivos descargados
- 1.5.2 Mover a carpeta temp/

---

## FASE 2: Configuración del proyecto

### 2.1 Crear config.json
- 2.1.1 Definir sitio_web por defecto
- 2.1.2 Definir carpeta_salida
- 2.1.3 Definir pdf_settings

### 2.2 Crear CLI principal
- 2.2.1 Crear docs2pdf.py
- 2.2.2 Implementar argparse

---

## FASE 3: Validación de entorno

### 3.1 Verificar Python
- 3.1.1 Ejecutar verificación de versión
- 3.1.2 Validar Python >= 3.10

### 3.2 Verificar Playwright
- 3.2.1 Verificar instalación de paquete
- 3.2.2 Verificar navegador chromium

### 3.3 Verificar conectividad
- 3.3.1 Probar conexión a internet
- 3.3.2 Probar conexión a sitio destino

---

## FASE 4: Recolección de URLs

### 4.1 Scrapear índice
- 4.1.1 Abrir página principal con Playwright
- 4.1.2 Extraer links de navegación
- 4.1.3 Normalizar URLs

### 4.2 Filtrar y guardar
- 4.2.1 Filtrar paths de documentación
- 4.2.2 Deduplicar lista
- 4.2.3 Guardar en urls.json

### 4.3 Validar URLs
- 4.3.1 Verificar HTTP 200
- 4.3.2 Registrar URLs fallidas
- 4.3.3 Reintentar URLs fallidas

---

## FASE 5: Descarga de HTML

### 5.1 Crear estructura
- 5.1.1 Crear carpeta html_pages/
- 5.1.2 Crear carpeta pdfs/

### 5.2 Descargar páginas
- 5.2.1 Cargar página con Playwright
- 5.2.2 Extraer contenido HTML
- 5.2.3 Guardar en archivo local

### 5.3 Validar descargas
- 5.3.1 Verificar tamaño de archivo
- 5.3.2 Verificar contenido de texto
- 5.3.3 Registrar en manifest

---

## FASE 6: Procesamiento de HTML

### 6.1 Limpiar HTML
- 6.1.1 Remover etiquetas script
- 6.1.2 Remover iframes externos
- 6.1.3 Convertir rutas relativas

### 6.2 Generar TOC
- 6.2.1 Extraer headings h1, h2, h3
- 6.2.2 Crear estructura de índice
- 6.2.3 Guardar en toc.json

### 6.3 Crear portada
- 6.3.1 Generar HTML de portada
- 6.3.2 Incluir metadata

---

## FASE 7: Generación del PDF

### 7.1 Configurar PDF
- 7.1.1 Definir opciones de formato
- 7.1.2 Definir márgenes
- 7.1.3 Configurar TOC

### 7.2 Generar PDF
- 7.2.1 Convertir portada a PDF
- 7.2.2 Convertir páginas a PDF
- 7.2.3 Combinar PDFs

### 7.3 Agregar metadatos
- 7.3.1 Agregar título
- 7.3.2 Agregar autor
- 7.3.3 Agregar fecha

---

## FASE 8: Validación

### 8.1 Verificar PDF
- 8.1.1 Verificar archivo existe
- 8.1.2 Verificar tamaño > 0
- 8.1.3 Contar páginas

### 8.2 Probar funcionalidades
- 8.2.1 Probar buscador de texto
- 8.2.2 Probar TOC
- 8.2.3 Probar hipervínculos

### 8.3 Generar reporte
- 8.3.1 Crear validation_report.json
- 8.3.2 Incluir métricas

---

## FASE 9: Entrega final

### 9.1 Mover PDF
- 9.1.1 Mover a carpeta de salida
- 9.1.2 Renombrar archivo

### 9.2 Limpiar temporales
- 9.2.1 Eliminar carpeta temp/
- 9.2.2 Mantener logs y PDF

---

## Resumen de dependencias entre fases

```
FASE 1 → FASE 2 → FASE 3 → FASE 4 → FASE 5 → FASE 6 → FASE 7 → FASE 8 → FASE 9
  │         │         │         │         │         │         │         │
  └─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┘
                                          │
                              (FASE 1 proporciona archivos para FASE 5)
```
