---
tags: [sesion, checkpoint]
---

# Estado de la sesión — 2026-06-20

## Contexto
Configuración de Hyprland 0.55.4 en CachyOS. Post-it widget con atajos, webcam fix, session switching.

## Estado actual

### ✅ Funciona
- **Alt+Shift+letra**: apps (W=Brave, R=Code, E=Dolphin, D=Discord, S=Screenshot, A=Región, M=btop, X=pavucontrol, Y=equalize, B=float)
- **Super+Return**: kitty
- **Super+Q**: cerrar ventana
- **Super+D/S/A/T/O**: wofi, screenshot, región, traducir, opencode
- **Super+F/V**: fullscreen, toggle float
- **Super+1-9**: workspaces
- **Super+Shift+1-9**: mover a workspace
- **Super+Tab**: previous workspace
- **Super+Escape**: cerrar sesión (vuelve a SDDM)
- **Super+/**: sticky note con atajos
- **Super+F2**: chvt 2 (cambiar a Plasma en TTY2)
- **Ctrl+Q**: cerrar ventana
- **Mouse 276/275**: screenshot / pegar+enter

### ❌ No funciona
- **Ctrl+Shift+letra**: bug conocido Hyprland 0.55
- **Fondo de pantalla**: hyprpaper corre pero "Monitor X has no target"

### Archivos clave
- `~/.config/hypr/hyprland.lua`
- `~/.config/hypr/hyprpaper.conf`
- `~/.config/hypr/scripts/atajos.sh`
- `~/.config/hypr/scripts/to-plasma.sh`
- `~/.config/hypr/scripts/screenshot.sh`
- `~/Escritorio/atajos.txt`
- `/etc/modprobe.d/uvcvideo.conf`
- `/etc/udev/rules.d/50-camera.rules`
