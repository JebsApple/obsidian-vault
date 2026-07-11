---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - GDK_SCALE
  - escala fraccionaria
  - GTK3 scale
---

# GTK3 + escala fraccionaria Hyprland: exportar GDK_SCALE=1

## Lo que aprendí
GTK3 NO soporta escala fraccionaria (ej: 1.5). En un monitor a scale 1.5, ventanas GTK3 se renderizan agrandadas. Fix: exportar `GDK_SCALE=1` antes de importar Gtk — GTK renderiza 1× y Hyprland aplica el scale uniformemente. Queda algo menos nítido en HiDPI pero es aceptable.

## Contexto
2026-06-25 en Hyprland. hypr-player como layer-shell se veía gigante en eDP a scale 1.5.

## Aplicación
Para cualquier app GTK3 en Hyprland con escala fraccionaria: `export GDK_SCALE=1` antes de importar módulos GTK. GTK4 no tiene este problema.

## Conexiones
- [[hyprland-flotar-gtk-layershell]]
- [[hyprland-monitor-helper-escala]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
