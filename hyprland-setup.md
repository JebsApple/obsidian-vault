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

## Keyhint
- `SUPER + SPACE` → popup centrado con atajos
- Script: `~/.local/bin/hypr-keyhint` (Python + GTK3, auto-cierra 1.8s)

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
