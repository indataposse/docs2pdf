# Procedimiento FASE 1: Preparación

Esta fase prepara el entorno descargando todos los recursos necesarios para trabajar offline.

---

## 1.1 Crear estructura del proyecto

### 1.1.1 Crear carpeta raíz del proyecto

**Acción**: Crear la carpeta raíz donde vivirá el proyecto.

**Comando**:
```powershell
New-Item -ItemType Directory -Path "D:\PrjS-Lino\docs2pdf" -Force
```

**Explicación**: Crea el directorio principal del proyecto. El flag `-Force` sobrescribe si ya existe.

---

### 1.1.2 Crear subcarpetas

**Acción**: Crear las subcarpetas necesarias: output/, temp/, logs/.

**Comando**:
```powershell
cd D:\PrjS-Lino\docs2pdf
New-Item -ItemType Directory -Path "output", "temp", "logs" -Force
```

**Explicación**: Crea las carpetas para el PDF final, archivos temporales y logs.

---

## 1.2 Crear requirements.txt

### 1.2.1 Definir dependencias del proyecto

**Acción**: Crear archivo con las dependencias Python necesarias.

**Comando**:
```powershell
Set-Content -Path "D:\PrjS-Lino\docs2pdf\requirements.txt" -Value @"
playwright>=1.40.0
requests>=2.31.0
beautifulsoup4>=4.12.0
lxml>=4.9.0
Jinja2>=3.1.0
"@
```

**Explicación**: Define los paquetes necesarios para scraping, parsing HTML y generación de PDF.

**Si esto no funciona, prueba esto otro**:
```powershell
# Usar UTF-8 si hay caracteres especiales
[System.IO.File]::WriteAllText("D:\PrjS-Lino\docs2pdf\requirements.txt", $contenido, [System.Text.UTF8Encoding]::new($true))
```

---

## 1.3 Instalar dependencias

### 1.3.1 Instalar paquetes Python

**Acción**: Instalar las dependencias definidas en requirements.txt.

**Comando**:
```powershell
pip install -r D:\PrjS-Lino\docs2pdf\requirements.txt
```

**Explicación**: Instala Playwright, requests, beautifulsoup4, lxml y Jinja2.

**Si esto no funciona, prueba esto otro**:
```powershell
# Actualizar pip primero
python -m pip install --upgrade pip

# Instalar cada paquete individualmente si hay errores
pip install playwright
pip install requests
pip install beautifulsoup4
pip install lxml
pip install Jinja2
```

---

### 1.3.2 Instalar Playwright chromium

**Acción**: Instalar el navegador Chromium para Playwright.

**Comando**:
```powershell
playwright install chromium
```

**Explicación**: Descarga e instala Chromium (~100MB). Necesario para renderizar páginas web.

**Si esto no funciona, prueba esto otro**:
```powershell
# Instalar con dependencias del sistema
playwright install --with-deps chromium

# Verificar instalación existente
playwright install --dry-run chromium
```

---

### 1.3.3 Verificar instalación

**Acción**: Confirmar que Playwright se instaló correctamente.

**Comando**:
```powershell
python -c "import playwright; print(playwright.__version__)"
```

**Explicación**: Importa el módulo y muestra la versión.

**Si esto no funciona, prueba esto otro**:
```powershell
# Verificar playwright en el path
playwright --version

# Reinstalar si hay problemas
pip uninstall playwright -y
pip install playwright
```

---

## 1.4 Descargar documentación

### 1.4.1 Verificar wget disponible

**Acción**: Comprobar si wget está instalado en el sistema.

**Comando**:
```powershell
wget --version
```

**Explicación**: Verifica si wget está disponible en el sistema.

**Si esto no funciona, prueba esto otro**:
```powershell
# Usar curl como alternativa
curl --version

# Instalar wget via chocolatey
choco install wget -y

# O usar Invoke-WebRequest (PowerShell nativo)
```

---

### 1.4.2 Descargar documentación completa

**Acción**: Descargar todo el sitio de documentación para trabajar offline.

**Comando**:
```powershell
cd D:\PrjS-Lino\docs2pdf\temp
wget --mirror -np -k -E -p -R "*.js,*.css,*.json" https://opencode.ai/docs/es/
```

**Explicación**:
- `--mirror`: Modo espejo (recursivo)
- `-np`: No ascender al directorio padre
- `-k`: Convertir enlaces a rutas locales
- `-E`: Convertir a extensión .html
- `-p`: Descargar imágenes y estilos necesarios
- `-R`: Excluir archivos .js, .css, .json

**Si esto no funciona, prueba esto otro**:
```powershell
# Usar PowerShell Invoke-WebRequest
$url = "https://opencode.ai/docs/es/"
Invoke-WebRequest -Uri $url -OutFile "index.html"

# O usar curl con opciones similares
curl -L -k -E -r https://opencode.ai/docs/es/ -o "#1/index.html"

# O descargar solo el índice y las páginaslinked
wget -r -l 2 -np -k -E -p https://opencode.ai/docs/es/
```

---

### 1.4.3 Mover archivos a carpeta temporal

**Acción**: Organizar los archivos descargados en la carpeta temp/.

**Comando**:
```powershell
# Si wget creó una carpeta con el dominio
Move-Item -Path "D:\PrjS-Lino\docs2pdf\temp\opencode.ai\docs\es\*" -Destination "D:\PrjS-Lino\docs2pdf\temp\html_docs\" -Force
Remove-Item -Path "D:\PrjS-Lino\docs2pdf\temp\opencode.ai" -Recurse -Force
```

**Explicación**: Mueve los archivos de la estructura wget a una carpeta plana html_docs/.

---

## 1.5 Verificar integridad

### 1.5.1 Verificar archivos descargados

**Acción**: Comprobar que los archivos se descargaron correctamente.

**Comando**:
```powershell
Get-ChildItem -Path "D:\PrjS-Lino\docs2pdf\temp\html_docs" -Recurse -File | Where-Object { $_.Length -gt 0 } | Measure-Object
```

**Explicación**: Cuenta archivos con tamaño mayor a 0 bytes.

---

### 1.5.2 Generar reporte de descarga

**Acción**: Crear un archivo con el resumen de la descarga.

**Comando**:
```powershell
$reporte = @{
    fecha = Get-Date -Format "yyyy-MM-dd HH:mm"
    total_archivos = (Get-ChildItem -Path "D:\PrjS-Lino\docs2pdf\temp\html_docs" -Recurse -File).Count
    tamano_total_mb = [math]::Round((Get-ChildItem -Path "D:\PrjS-Lino\docs2pdf\temp\html_docs" -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
}
$reporte | ConvertTo-Json | Set-Content "D:\PrjS-Lino\docs2pdf\logs\download_report.json"
```

**Explicación**: Genera un JSON con estadísticas de la descarga.

---

# Script de Comprobaciones

Ejecutar después de completar la fase para verificar que todo está correcto.

## check_phase1.ps1

```powershell
<#
.SYNOPSIS
    Script de comprobación para FASE 1: Preparación
.DESCRIPTION
    Verifica que todos los recursos necesarios se hayan descargado correctamente
.NOTES
    Ejecutar desde la raíz del proyecto: powershell -File check_phase1.ps1
#>

param(
    [string]$ProjectRoot = "D:\PrjS-Lino\docs2pdf"
)

$ErrorActionPreference = "Continue"
$results = @{
    fase = "FASE 1: Preparación"
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    verificaciones = @()
    errores = @()
    exitoso = $true
}

function Test-Item {
    param($name, $test, $mensajeOk, $mensajeFail)
    $result = & $test
    $verificacion = @{
        nombre = $name
        estado = if ($result) { "OK" } else { "FALLO" }
        mensaje = if ($result) { $mensajeOk } else { $mensajeFail }
    }
    $results.verificaciones += $verificacion
    if (-not $result) {
        $results.errores += $name
        $results.exitoso = $false
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  COMPROBACIÓN FASE 1: PREPARACIÓN" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Verificar carpetas
Write-Host "[1] Verificando estructura de carpetas..." -ForegroundColor Yellow
Test-Item "Carpeta output" { Test-Path "$ProjectRoot\output" } "Existe" "No existe"
Test-Item "Carpeta temp" { Test-Path "$ProjectRoot\temp" } "Existe" "No existe"
Test-Item "Carpeta logs" { Test-Path "$ProjectRoot\logs" } "Existe" "No existe"

# 2. Verificar requirements.txt
Write-Host "`n[2] Verificando requirements.txt..." -ForegroundColor Yellow
Test-Item "requirements.txt" { Test-Path "$ProjectRoot\requirements.txt" } "Existe" "No existe"

# 3. Verificar Python y dependencias
Write-Host "`n[3] Verificando Python y dependencias..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    $results.verificaciones += @{nombre="Python"; estado="OK"; mensaje=$pythonVersion}
} catch {
    $results.verificaciones += @{nombre="Python"; estado="FALLO"; mensaje="No encontrado"}
    $results.errores += "Python"
    $results.exitoso = $false
}

try {
    $playwrightVersion = python -c "import playwright; print(playwright.__version__)" 2>&1
    $results.verificaciones += @{nombre="Playwright"; estado="OK"; mensaje="Versión: $playwrightVersion"}
} catch {
    $results.verificaciones += @{nombre="Playwright"; estado="FALLO"; mensaje="No instalado"}
    $results.errores += "Playwright"
    $results.exitoso = $false
}

# 4. Verificar Chromium
Write-Host "`n[4] Verificando Chromium..." -ForegroundColor Yellow
Test-Item "Chromium (playwright)" { python -c "from playwright.sync_api import sync_playwright; p = sync_playwright().start(); p.chromium.launch(); p.stop()" 2>$null } "Instalado" "No instalado"

# 5. Verificar archivos descargados
Write-Host "`n[5] Verificando archivos descargados..." -ForegroundColor Yellow
$htmlFiles = Get-ChildItem -Path "$ProjectRoot\temp" -Recurse -Include "*.html","*.htm" -ErrorAction SilentlyContinue
if ($htmlFiles) {
    $results.verificaciones += @{
        nombre="Archivos HTML"
        estado="OK"
        mensaje="$($htmlFiles.Count) archivos encontrados"
    }
    $totalSize = ($htmlFiles | Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "    Tamaño total: $sizeMB MB" -ForegroundColor Gray
} else {
    $results.verificaciones += @{nombre="Archivos HTML"; estado="FALLO"; mensaje="No se encontraron"}
    $results.errores += "Archivos HTML"
    $results.exitoso = $false
}

# 6. Verificar archivo de descarga
Write-Host "`n[6] Verificando reporte de descarga..." -ForegroundColor Yellow
Test-Item "download_report.json" { Test-Path "$ProjectRoot\logs\download_report.json" } "Existe" "No existe"

# Mostrar resultados
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  RESULTADO DE VERIFICACIONES" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

foreach ($v in $results.verificaciones) {
    $color = if ($v.estado -eq "OK") { "Green" } else { "Red" }
    Write-Host "[$($v.estado)] $($v.nombre): $($v.mensaje)" -ForegroundColor $color
}

Write-Host "`n========================================" -ForegroundColor Cyan
if ($results.exitoso) {
    Write-Host "  ✓ FASE 1 COMPLETADA EXITOSAMENTE" -ForegroundColor Green
} else {
    Write-Host "  ✗ FASE 1 INCOMPLETA" -ForegroundColor Red
    Write-Host "  Errores: $($results.errores -join ', ')" -ForegroundColor Red
}
Write-Host "========================================`n" -ForegroundColor Cyan

# Guardar resultado
$results | ConvertTo-Json -Depth 3 | Set-Content "$ProjectRoot\logs\check_phase1_result.json"
Write-Host "Resultado guardado en: $ProjectRoot\logs\check_phase1_result.json`n" -ForegroundColor Gray

# Fin del script
```

---

## Resumen de la Fase

| Tarea | Estado esperado |
|-------|-----------------|
| Carpetas creadas | output/, temp/, logs/ |
| requirements.txt | Existe con 5 dependencias |
| Python | >= 3.10 |
| Playwright | Instalado y funcionando |
| Chromium | Instalado |
| Archivos descargados | > 0 archivos HTML |
| Reporte | download_report.json generado |

---

## Siguiente paso

Una vez completada y verificada esta fase, proceder a **FASE 2: Configuración del proyecto**.

Ver `TASKS.md` para el listado completo de tareas.
