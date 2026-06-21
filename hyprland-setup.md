---
tags:
  - hyprland
  - cachyos
  - config
---

# Hyprland Setup

## Config
- `~/.config/hypr/hyprland.conf`
- Backups: `hyprland.conf.clean`, `hyprland.lua.bak`

## Paquetes
- `lxqt-policykit` (autenticación)
- `xdg-desktop-portal-hyprland` (portal)
- `hyprlauncher` (lanzador)
- `yad` (dialogos GTK)

## Autostart
- `/usr/bin/lxqt-policykit-agent`
- `/usr/lib/xdg-desktop-portal-hyprland`
- `waybar`
- `hyprpaper`
- ~~`dunst`~~ (no funciona, reemplazar)

## Keyhint
- `SUPER / ALT / CTRL / ALT+SHIFT + SPACE` → popup buscable con atajos
- Script: `~/.local/bin/hypr-keyhint` (Python + GTK3 con `Gtk.SearchEntry`)
- `bindr` para cerrar al soltar tecla (kill por PID, no `pkill`)
- PID file en `/tmp/hypr-keyhint.pid`

## Screenshots
- `SUPER+S` → región, guarda en `~/Imágenes/Capturas de pantalla/`
- `SUPER+SHIFT+S` → pantalla completa
- Clipboard automático (`wl-copy`)
- Toast con `hyprctl notify -1 3000 "rgb(33ccff)" "fontsize:20 Captura guardada"`
- Preview con `yad --picture` (pendiente: flotar ventana)
- Script: `~/.config/hypr/scripts/screenshot.sh`

## Notificaciones
- `hyprctl notify` funciona con `fontsize:` kwarg (toast texto)
- Preview con `yad --picture` (se abre tiled, workaround pendiente)
- `dunst` instalado pero no muestra notifs
- `grimblast` en `~/.local/bin/` (lock file issue: `rm -f /run/user/1000/grimblast.lock`)

## Audio
- PipeWire + WirePlumber
- Perfil activo: `output:hdmi-stereo+input:analog-stereo`
- Salida HDMI (monitor), entrada mic analógico
- Toggle entre HDMI y analógico: pendiente si hace falta

## Monitores
- `eDP-1` (laptop)
- `HDMI-A-1` (externo)
- `WAYLAND-1` deshabilitado (virtual/OBS)

## Waybar + Wallpaper
- `waybar` autostart (barra superior con workspaces)
- `hyprpaper` autostart con wallpaper anterior
