---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - hyprsunset service
  - graphical-session
  - systemd wantedby
---

# systemd user services: WantedBy=default.target, NO graphical-session.target

## Lo que aprendí
`hyprsunset.service` estaba `enabled` pero con `WantedBy=graphical-session.target`, y ese target NO se activa en sesión Hyprland (sin uwsm). El comando fallaba silenciosamente (`2>/dev/null`). Fix: `WantedBy=default.target` (igual que waybar y waybar-hover-daemon). Regla: servicios user que arranquen al login van con `default.target`.

## Contexto
2026-06-25 en Hyprland. El brillo del monitor externo no cambiaba aunque el state file se actualizaba.

## Aplicación
Al crear servicios systemd user para Hyprland: usar `WantedBy=default.target`, NO `graphical-session.target`. Verificar con `pgrep -x <servicio>` que esté vivo después de habilitarlo.

## Conexiones
- [[waybar-daemon-life-cycle]]
- [[brillo-hdmi-hyprsunset-service]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
