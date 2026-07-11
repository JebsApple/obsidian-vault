---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/zen
aliases:
  - PiP Zen
  - Picture-in-Picture
  - wtype gesture
---

# Zen PiP: wtype simula user gesture para disparar atajo nativo

## Lo que aprendí
Firefox/Zen tiene atajo nativo de PiP (`Ctrl+Shift+]`) pero no tiene disparador externo (ni D-Bus/MPRIS/CLI) y `requestPictureInPicture()` exige user gesture. Una pulsación real con `wtype` SÍ cuenta como gesto → enfocar Zen (`class:zen`) e inyectar el atajo. `wtype` sube su propio keymap → funciona pese al layout `latam`. Caveat: disparar desde otro workspace enfoca Zen y cambia de workspace.

## Contexto
2026-06-25 en Hyprland. Se quería activar PiP de Zen desde Waybar y un atajo global.

## Aplicación
Para disparar atajos de teclado en apps Wayland desde scripts: `wtype` simula pulsaciones reales que cuentan como user gesture. Útil para PiP, shortcuts de apps, etc.

## Conexiones
- [[hyprland-dispatchers-argumentos-lua]]
- [[hyprland-flotar-gtk-layershell]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
