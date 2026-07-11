---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - monitor helper
  - hypr-active-monitor
  - tamaño lógico
---

# Conciencia de monitores: leer IPC de Hyprland, no "drivers"

## Lo que aprendí
Para que scripts/ventanas "lean los monitores", usar la IPC de Hyprland: `hyprctl monitors -j` (name, width, height, scale, x, y, focused) y `hyprctl cursorpos -j`. El tamaño LÓGICO = `width / scale` (no el `width` físico). Crear un helper reutilizable (`~/.local/bin/hypr-active-monitor`) que devuelva JSON del monitor bajo el cursor con `w_log`/`h_log`.

## Contexto
2026-06-25 en Hyprland. Se necesitaba que hypr-player y el script de brillo supieran en qué monitor estaba el cursor.

## Aplicación
Crear un helper de monitores reutilizable para cualquier script que necesite adaptarse al monitor activo. No hardcodear resoluciones.

## Conexiones
- [[gtk3-escala-fraccionaria-gdk-scale]]
- [[brillo-hdmi-hyprsunset-service]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
