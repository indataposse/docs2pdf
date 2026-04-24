"""
Script para descargar documentación usando Playwright
Uso: python download_docs.py
"""

import os
import json
import logging
from datetime import datetime
from pathlib import Path
from playwright.sync_api import sync_playwright

# Configuración
SITE_URL = "https://opencode.ai/docs/es/"
CHROME_PATH = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
OUTPUT_DIR = Path("temp/html_docs")
LOG_FILE = Path("logs/download_docs.log")

# Setup logging
LOG_FILE.parent.mkdir(exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE, encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

def get_page_urls(page):
    """Extrae todos los links de documentación de la página."""
    urls = []
    try:
        # Esperar a que carguen los links del sidebar
        page.wait_for_selector('a[href^="/docs/es/"]', timeout=10000)

        # Encontrar todos los links de documentación
        links = page.query_selector_all('a[href^="/docs/es/"]')

        for link in links:
            href = link.get_attribute('href')
            if href and href.endswith('/'):
                full_url = f"https://opencode.ai{href}"
                title = link.inner_text().strip()
                if title and full_url not in [u['url'] for u in urls]:
                    urls.append({
                        'url': full_url,
                        'title': title,
                        'path': href.replace('/docs/es/', '').strip('/')
                    })
                    logger.info(f"Encontrado: {title} -> {href}")

    except Exception as e:
        logger.error(f"Error extrayendo URLs: {e}")

    return urls

def download_page(page, url_info):
    """Descarga una página y guarda el HTML."""
    try:
        logger.info(f"Descargando: {url_info['url']}")

        page.goto(url_info['url'], wait_until='networkidle', timeout=30000)

        # Esperar contenido
        page.wait_for_selector('article, main, .content', timeout=10000)

        html = page.content()

        # Crear nombre de archivo
        filename = url_info['path'].replace('/', '_') or 'index'
        filename = f"{filename}.html"

        # Guardar
        filepath = OUTPUT_DIR / filename
        filepath.parent.mkdir(parents=True, exist_ok=True)

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(html)

        logger.info(f"Guardado: {filepath} ({len(html)} bytes)")

        return {'url': url_info['url'], 'status': 'success', 'size': len(html)}

    except Exception as e:
        logger.error(f"Error descargando {url_info['url']}: {e}")
        return {'url': url_info['url'], 'status': 'error', 'error': str(e)}

def main():
    logger.info("=" * 50)
    logger.info("INICIANDO DESCARGA DE DOCUMENTACIÓN")
    logger.info(f"Sitio: {SITE_URL}")
    logger.info(f"Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    logger.info("=" * 50)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    results = []

    with sync_playwright() as p:
        logger.info("Iniciando Chromium...")
        browser = p.chromium.launch(
            executable_path=CHROME_PATH,
            headless=True,
            args=['--disable-gpu', '--no-sandbox']
        )
        page = browser.new_page()

        try:
            # 1. Obtener índice
            logger.info("Obteniendo índice del sitio...")
            page.goto(SITE_URL, wait_until='networkidle', timeout=30000)
            page.wait_for_selector('a[href^="/docs/es/"]', timeout=10000)

            urls = get_page_urls(page)
            logger.info(f"Encontradas {len(urls)} páginas")

            # Guardar lista de URLs
            with open('logs/urls.json', 'w', encoding='utf-8') as f:
                json.dump(urls, f, ensure_ascii=False, indent=2)

            # 2. Descargar cada página
            logger.info("Iniciando descarga de páginas...")
            for i, url_info in enumerate(urls, 1):
                logger.info(f"[{i}/{len(urls)}] Descargando: {url_info['title']}")
                result = download_page(page, url_info)
                results.append(result)

        finally:
            browser.close()

    # 3. Generar reporte
    success = [r for r in results if r['status'] == 'success']
    failed = [r for r in results if r['status'] == 'error']

    report = {
        'fecha': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'total': len(results),
        'success': len(success),
        'failed': len(failed),
        'results': results
    }

    with open('logs/download_report.json', 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    logger.info("=" * 50)
    logger.info("DESCARGA COMPLETADA")
    logger.info(f"Total: {len(results)}")
    logger.info(f"Exitosas: {len(success)}")
    logger.info(f"Fallidas: {len(failed)}")
    logger.info("=" * 50)

    if failed:
        logger.warning("URLs fallidas:")
        for f in failed:
            logger.warning(f"  - {f['url']}: {f.get('error', 'Unknown')}")

    return report

if __name__ == "__main__":
    main()