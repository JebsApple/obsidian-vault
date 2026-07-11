---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/waybar
aliases:
  - waybar doble
  - spawn duplicado
  - autostart conflict
---

# Waybar se arrancaba DOS veces: autostart Hyprland + systemd

## Lo que aprendí
Si waybar lo lanzan a la vez el autostart de Hyprland (`hl.exec_cmd("waybar")`) y `waybar.service` (systemd), al re-loguear ambos ganan → barras dobles + daemons mpris duplicados. Fix: quitar el autostart del `.lua` y dejar systemd como único lanzador (tiene `Restart=always`). Footgun: `pkill -f "bin/mpris-yt"` mata el propio shell — matar solo si `comm==python3`.

## Contexto
2026-06-24 en Hyprland. Al re-loguear aparecían 4 superficies de waybar (2 por monitor) y 12 daemons mpris.

## Aplicación
Nunca lanzar el mismo servicio desde dos orígenes. Elegir uno (systemd recomendado) y quitar el otro. Al hacer `pkill`, verificar que el patrón no matchee el propio shell.

## Conexiones
- [[waybar-daemon-life-cycle]]
- [[hyprland-config-lua]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
