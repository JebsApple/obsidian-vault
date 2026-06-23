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
- `waybar` (systemd user service) + `waybar-hover-daemon` (BindsTo=waybar)
- `hyprpaper`
- ~~`dunst`~~ (no funciona, reemplazar)

## Waybar
Ver [[waybar-hyprland]] para arquitectura completa.
- Config: `~/.config/waybar/config` + `~/.config/waybar/style.css`
- Scripts: `~/.local/bin/{clock,pulseaudio,battery,network,bluetooth,brightness-edp,brightness-hdmi,mpris}`
- Hover daemon: `~/.local/bin/waybar-hover-daemon`
- **Bug crítico resuelto (2026-06-22):** `font-size: 0px` → Pango assertion → rendering failure → módulos invisibles. Solución: scripts emiten texto condicionalmente según GROUP_FILE.

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

## Waybar
- `waybar` autostart (barra superior)
- Config: `~/.config/waybar/config`
- Style: `~/.config/waybar/style.css`

### Módulos (icon-only)
Todos muestran solo icono por defecto, hover revela texto vía tooltip o CSS sibling selector.

| Módulo | Icono | Tooltip/Texto hover |
|--------|-------|-------------------|
| `pulseaudio` | `{icon}` (///) | `{volume}%` |
| `battery` | `{icon}` (-/) | `{capacity}% {timeTo}` |
| `network` | // | `{ifname} via {essid}\n{ipaddr}` |
| `bluetooth` | //󰂲 | dispositivos conectados |
| `custom/brightness-edp` |  (JSON) | porcentaje |
| `custom/brightness-hdmi` |  (JSON) | porcentaje |
| `custom/mpris-icon` |  (JSON) | artista + título |
| `custom/mpris-scroll` | scrolling title | — (hover via CSS) |

### CSS feature: mpris hover
```css
#custom-mpris-scroll { font-size: 0; }
#custom-mpris-icon:hover + #custom-mpris-scroll,
#custom-mpris-scroll:hover { font-size: 13px; }
```
Icono de música siempre visible. Texto con título se oculta hasta hover sobre el icono.

### Scripts
- `brightness-edp`: `brightnessctl` → JSON `{"text":"","tooltip":"90%"}`
- `brightness-hdmi`: `hyprsunset gamma_output` → JSON `{"text":"","tooltip":"100%"}`
- `mpris-icon`: static  icono como JSON
- `mpris-scroll`: scrolling marquee (1.2 chars/seg) con título + artista + tiempo

## hypr-player
Mini reproductor GTK3 flotante con video YouTube embebido vía mpv --wid.
Script: `~/.local/bin/hypr-player`
Toggle: `hypr-player` (segundo click cierra)

### Stack
- `GDK_BACKEND=x11` — ventana GTK via XWayland
- `Gtk.Socket` para embeber mpv
- `mpv --vo=x11 --wid=<XID>` — video YouTube renderizado directamente, sin screenshots
- `yt-dlp -g` en thread separado para obtener stream URL
- `--input-ipc-server` para control remoto (seek, pause)

### Layout
- Área de video/arte 16:9 (420×236)
- Controles auto-ocultables (5s) que aparecen al hover
- Botones: prev, play/pause, next, volumen, cerrar
- Progress bar para seek, teclas ←/→ para ±5s
- Drag vía `begin_move_drag`

### Detección de player
Íconos por reproductor detectado vía playerctl:

| Player | Icono |
|--------|-------|
| YouTube (browser) |  + video embebido |
| Spotify |  + album art |
| VLC | 󰕼 + album art |
| Brave | 󰞟 |
| Firefox | 󰈹 |
| Chromium/Chrome |  |
| Otros | 󰎆 |

### IPC
Mpv se controla via socket UNIX (`/tmp/hypr-mpv-{pid}.sock`):
- Seek → mpv set_property time-pos
- Play/Pause → mpv set_property pause
- Flechas → mpv add time-pos ±5

### Delay
`--start=<pos_actual>` desde playerctl position. Mpv arranca cerca de donde está el browser.

### On-click
```ini
bind = SUPER, M, exec, hypr-player
```

### Archivos relacionados
- `~/.local/bin/hypr-player` — script principal
- `~/.local/bin/mpris-icon` — icono waybar
- `~/.local/bin/mpris-scroll` — scrolling waybar
- `~/.local/bin/brightness-edp` — brillo hardware eDP
- `~/.local/bin/brightness-hdmi` — brillo gamma HDMI
- `~/.config/waybar/config` — módulos waybar
- `~/.config/waybar/style.css` — estilos catppuccin

## Paquetes
- `lxqt-policykit` (autenticación)
- `xdg-desktop-portal-hyprland` (portal)
- `hyprlauncher` (lanzador)
- `yad` (dialogos GTK)
- `wf-recorder` (grabación pantalla)
- `yt-dlp` (extracción streams YouTube)
- `mpv` (reproductor embebible)
- `socat` (mpv IPC)
