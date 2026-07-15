---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - brillo HDMI
  - hyprsunset gamma
---

# Brillo HDMI no cambiaba: hyprsunset no estaba corriendo

## Lo que aprendí
El scroll de brillo en monitor externo no hacía nada aunque el state file se actualizaba. Causa: `hyprsunset` (que aplica gamma por output via `hyprctl hyprsunset gamma_output <name> <val>`) no estaba corriendo porque su servicio systemd tenía el target incorrecto. El `echo "$n" > state` corría igual → engañoso.

## Contexto
2026-06-25 en Hyprland. Se invertía tiempo debuggeando el script de brillo cuando el problema era el servicio.

## Aplicación
Al debuggear un módulo que "no funciona": verificar primero que el daemon/servicio subyacente esté vivo (`pgrep`, `systemctl status`). No asumir que porque el state file se actualiza, el servicio real está funcionando.

## Conexiones
- [[systemd-wantedby-default-target]]
- [[audio-cambiar-perfil-tarjeta]]
- [[caelestia-integracion-sistema]] — 2026-07-15: el mismo patrón (gamma_output vía hyprsunset) se reimplementó dentro de caelestia tras la migración de waybar. El servicio había quedado deshabilitado en la migración; además se descubrió que el monitor HDMI (AOC LE22H037) es en realidad un TV sin soporte DDC/CI real, así que gamma NO es un workaround temporal — es el único método posible para esa pantalla.

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
