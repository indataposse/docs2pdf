<#
.SYNOPSIS
    Script de comprobacion para FASE 1: Preparacion
.DESCRIPTION
    Verifica que todos los recursos necesarios se hayan descargado correctamente
.NOTES
    Ejecutar desde la raz del proyecto: powershell -File check_phase1.ps1
#>

param(
    [string]$ProjectRoot = $PSScriptRoot
)

$ErrorActionPreference = "Continue"
$results = @{
    fase = "FASE 1: Preparacion"
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
Write-Host "  COMPROBACION FASE 1: PREPARACION" -ForegroundColor Cyan
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
    $playwrightVersion = python -c "from playwright.sync_api import sync_playwright; print('OK')" 2>&1
    if ($playwrightVersion -eq "OK") {
        $results.verificaciones += @{nombre="Playwright"; estado="OK"; mensaje="Instalado y funcional"}
    } else {
        $results.verificaciones += @{nombre="Playwright"; estado="FALLO"; mensaje="Error al importar"}
        $results.errores += "Playwright"
        $results.exitoso = $false
    }
} catch {
    $results.verificaciones += @{nombre="Playwright"; estado="FALLO"; mensaje="No instalado"}
    $results.errores += "Playwright"
    $results.exitoso = $false
}

# 4. Verificar Chrome local
Write-Host "`n[4] Verificando Chrome..." -ForegroundColor Yellow
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
Test-Item "Chrome local" { Test-Path $chromePath } "Instalado en: $chromePath" "No encontrado"

# 5. Verificar archivos descargados
Write-Host "`n[5] Verificando archivos descargados..." -ForegroundColor Yellow
$htmlFiles = Get-ChildItem -Path "$ProjectRoot\temp\html_docs" -Filter "*.html" -ErrorAction SilentlyContinue
if ($htmlFiles) {
    $results.verificaciones += @{
        nombre="Archivos HTML"
        estado="OK"
        mensaje="$($htmlFiles.Count) archivos encontrados"
    }
    $totalSize = ($htmlFiles | Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "    Tamano total: $sizeMB MB" -ForegroundColor Gray

    # Verificar algunas paginas criticas
    $criticalPages = @("index.html", "config.html", "providers.html")
    foreach ($page in $criticalPages) {
        $exists = Test-Path "$ProjectRoot\temp\html_docs\$page"
        $status = if ($exists) { "OK" } else { "FALLO" }
        Write-Host "    [$status] $page" -ForegroundColor $(if ($exists) { "Green" } else { "Red" })
    }
} else {
    $results.verificaciones += @{nombre="Archivos HTML"; estado="FALLO"; mensaje="No se encontraron"}
    $results.errores += "Archivos HTML"
    $results.exitoso = $false
}

# 6. Verificar urls.json
Write-Host "`n[6] Verificando archivos de log..." -ForegroundColor Yellow
Test-Item "urls.json" { Test-Path "$ProjectRoot\logs\urls.json" } "Existe" "No existe"
Test-Item "download_report.json" { Test-Path "$ProjectRoot\logs\download_report.json" } "Existe" "No existe"
Test-Item "download_docs.log" { Test-Path "$ProjectRoot\logs\download_docs.log" } "Existe" "No existe"

# 7. Verificar contenido de urls.json
if (Test-Path "$ProjectRoot\logs\urls.json") {
    try {
        $urlsContent = Get-Content "$ProjectRoot\logs\urls.json" -Raw | ConvertFrom-Json
        $urlsCount = $urlsContent.Count
        $results.verificaciones += @{
            nombre="urls.json contenido"
            estado="OK"
            mensaje="$urlsCount URLs listadas"
        }
    } catch {
        $results.verificaciones += @{nombre="urls.json contenido"; estado="FALLO"; mensaje="Error al leer"}
    }
}

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
    Write-Host "  [OK] FASE 1 COMPLETADA EXITOSAMENTE" -ForegroundColor Green
} else {
    Write-Host "  [FALLO] FASE 1 INCOMPLETA" -ForegroundColor Red
    Write-Host "  Errores: $($results.errores -join ', ')" -ForegroundColor Red
}
Write-Host "========================================`n" -ForegroundColor Cyan

# Guardar resultado
$results | ConvertTo-Json -Depth 3 | Set-Content "$ProjectRoot\logs\check_phase1_result.json"
Write-Host "Resultado guardado en: $ProjectRoot\logs\check_phase1_result.json" -ForegroundColor Gray

# Fin del script