---
tags:
  - blueprint
  - project/ani-cli-hub
  - ani-dev
status: approved
branch: feature/hub-tabs-library-playback
created: 2026-07-17
---

# ani-dev — navegación, Biblioteca y rendimiento

## Problema real

El hub mezcla dos modelos de navegación: el grid con tabs y selectores `fzf` separados. Semana rompe el loop visual; Lista no permite clasificar de forma flexible; y las cargas o redraws rápidos degradan la experiencia. El comando estable `anime` debe permanecer intacto mientras se itera.

## Alcance aprobado

- Tabs principales: `Catálogo`, `Recientes`, `Favoritos`, `Semana` y `Biblioteca`.
- Semana se queda dentro del hub, con sub-tabs por día. Esc vuelve al hub principal.
- Biblioteca es una vista separada con tabs configurables. CRUD desde UI: crear, renombrar, reordenar y eliminar; al borrar se pide confirmación y se elimina la clasificación de sus animes, no los animes.
- Navegación por flechas/cursores y teclado, conservando Tab y números.
- Medir y corregir carga de catálogo y preparación de reproducción; reducir corrupción visual al navegar rápido.
- Reproducción embebida con `mpv --vo=kitty` queda como fase futura, no se implementa ahora.

## Fuera de alcance

- No tocar `/usr/lib/ani-cli-mx`, `/usr/bin/ani-cli-mx`, alias `anime` ni sus datos de estado.
- No cambiar fuentes de scraping ni instalar dependencias.
- No implementar todavía reproducción dentro de Kitty.

## Fases

### 1. Entorno de desarrollo aislado

- **Archivos:** `~/.local/bin/ani-dev`, `ani-cli-mx-core`.
- **Trabajo:** wrapper que ejecuta el core desde este clon y usa nombre/estado/cache propios de `ani-dev`.
- **Verificación:** `ani-dev --version`; confirmar que `anime` continúa resolviendo a `ani-cli-mx --browse`.

### 2. Navegación del hub y Semana

- **Archivos:** `ani-cli-mx-core`, `t/e2e.sh`.
- **Trabajo:** extraer el selector de Semana a un grid compatible con `CG_TABS`; incorporar sub-tabs `Lun`…`Dom`, flechas para moverse y Esc para volver al hub principal sin perder el loop.
- **Verificación:** `bash -n ani-cli-mx-core`, `t/verify.sh` y E2E de cambio de tab/retorno.

### 3. Biblioteca configurable

- **Archivos:** `ani-cli-mx-core`, nuevos tests Bash si procede.
- **Trabajo:** migración compatible del watchlist, persistencia de categorías y operaciones CRUD con confirmación destructiva. Biblioteca abre su propio loop de tabs; Esc vuelve al hub.
- **Verificación:** pruebas de crear, renombrar, mover, eliminar con entradas, y fallback a categorías iniciales si no existe configuración.

### 4. Rendimiento y estabilidad visual

- **Archivos:** `ani-cli-mx-core`, `t/e2e.sh`.
- **Trabajo:** instrumentación opcional de tiempos, evitar fetches/redraws repetidos, limitar concurrencia de miniaturas y serializar la limpieza/redibujado ante entradas rápidas.
- **Verificación:** comparar tiempos de catálogo y de resolución con caché fría/caliente; E2E de navegación rápida, resize y salida sin placeholders residuales.

### 5. Fase futura: reproducción dentro de Kitty

- **Precondición:** validar interactividad, audio, subtítulos y retorno al hub de `mpv --vo=kitty`.
- **No implementar en este plan.**

## Riesgos y rollback

- Cada fase se prueba en `ani-dev`; el comando instalado no se modifica.
- La configuración de Biblioteca usa un archivo propio y se respalda/migra antes de escribir.
- Si una fase falla, se revierte el commit de la fase en la rama; `anime` no se ve afectado.
