---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/waybar
aliases:
  - MPRIS idle
  - FG_EMPTY
---

# Waybar MPRIS: mostrar icono en idle state, no texto vacío

## Lo que aprendí
Los daemons MPRIS definían `FG_EMPTY` pero cuando no hay player activo emitían `"text": ""` → iconos invisibles. Fix: cambiar idle output a `f"<span foreground='{FG_EMPTY}' …>{ICON}</span>"`. Los 3 iconos siempre se ven; se iluminan al detectar un player activo.

## Contexto
2026-06-24 en Waybar. Los módulos mpris-yt, mpris-music, mpris-vlc desaparecían cuando no había nada reproduciéndose.

## Aplicación
Para módulos Waybar con estado vacío: siempre emitir el icono en color dim en vez de texto vacío. El usuario debe ver que el módulo existe aunque esté inactivo.

## Conexiones
- [[waybar-css-hover-per-module]]
- [[waybar-pango-font-size-pt]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
