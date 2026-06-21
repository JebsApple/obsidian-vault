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
