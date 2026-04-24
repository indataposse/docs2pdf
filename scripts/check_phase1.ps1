<#
.SYNOPSIS
    Script de comprobación para FASE 1: Preparación
.DESCRIPTION
    Verifica que todos los recursos necesarios se hayan descargado correctamente
.NOTES
    Ejecutar desde la raíz del proyecto: powershell -File check_phase1.ps1
#>

param(
    [string]$ProjectRoot = "D:\PrjS-Lino\oc-DocS"
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

# 4. Verificar navegador
Write-Host "`n[4] Verificando navegador..." -ForegroundColor Yellow
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    $results.verificaciones += @{nombre="Chrome local"; estado="OK"; mensaje="Instalado en: $chromePath"}
} else {
    $results.verificaciones += @{nombre="Chrome local"; estado="FALLO"; mensaje="No encontrado"}
    $results.errores += "Chrome"
    $results.exitoso = $false
}

try {
    python -c "from playwright.sync_api import sync_playwright; p = sync_playwright().start(); b = p.chromium.launch(executable_path=r'$chromePath', headless=True); b.close(); p.stop()" 2>$null
    $results.verificaciones += @{nombre="Playwright + Chrome"; estado="OK"; mensaje="Funcional"}
} catch {
    $results.verificaciones += @{nombre="Playwright + Chrome"; estado="FALLO"; mensaje="Error de integracion"}
    $results.errores += "Playwright-Chrome"
    $results.exitoso = $false
}

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