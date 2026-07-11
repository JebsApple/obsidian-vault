---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - hyprlock crash
  - pantalla negra
  - ext-session-lock
---

# NUNCA lanzar/matar hyprlock en sesión viva para "probar"

## Lo que aprendí
El protocolo Wayland `ext-session-lock` mantiene la pantalla bloqueada si el locker se cae (diseño de seguridad). Si lanzas `hyprlock` y lo matas con `timeout`/`pkill`, muere sin liberar el lock → pantalla negra → hay que ir a TTY (Ctrl+Alt+F2). Validar la config de hyprlock por inspección, no lanzándolo. Recuperación: Ctrl+Alt+F2 → login → `pkill hyprlock` / `loginctl unlock-session`.

## Contexto
2026-06-24 en Hyprland. Se quería probar la config de hyprlock y se quedó la pantalla negra.

## Aplicación
Nunca lanzar hyprlock desde la sesión gráfica para probar. Editar `hyprland.conf` o `hyprlock.conf` NO requiere reload (cada uno lee su config al arrancar). Verificar por inspección de archivos.

## Conexiones
- [[hyprland-config-lua]]
- [[waybar-double-start-problema]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
