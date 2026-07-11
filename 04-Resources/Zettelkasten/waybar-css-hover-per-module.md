---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/waybar
aliases:
  - waybar hover
  - per-module hover
  - CSS hover
---

# Waybar: hover per-module con daemon en vez de CSS

## Lo que aprendí
Waybar 0.15 no soporta `overflow`, `max-width`, `white-space` en CSS (GTK3 CSS rechaza propiedades web). La solución es un daemon que escriba el nombre del módulo hovered a un state file, y cada script lea el archivo y solo se expanda si su nombre coincide. CSS usa `min-width` (soportado) para anclar el centro. Toggle `SUPER+CTRL+B` entre modo moderno (per-module) y legacy (global).

## Contexto
2026-06-25 en Waybar. Se intentó hacer hover expand sin layout shift y CSS puro no funcionó.

## Aplicación
Para módulos Waybar expandibles: daemon per-module > CSS hover (que no está soportado). Mantener ambos modos (modern/legacy) con toggle para flexibilidad.

## Conexiones
- [[waybar-daemon-life-cycle]]
- [[waybar-mprios-idle-iconos]]
- [[waybar-pango-font-size-pt]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
