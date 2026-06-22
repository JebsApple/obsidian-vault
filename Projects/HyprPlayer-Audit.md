---
tags: [audit, hyprland, ponytail]
---

# HyprPlayer Audit — 2026-06-22
**Modo ponytail:** full | **Stack:** Python/GTK3 + mpv + yt-dlp + XWayland

## Resultado: ENTREGABLE (con deuda técnica documentada)

---

## Requerimientos cumplidos

### Funcionales
- [x] Mini reproductor flotante en esquina inferior-derecha del monitor donde está el cursor
- [x] Área de arte/video 16:9 (420×236)
- [x] Álbum art desde `mpris:artUrl` (HTTP/file)
- [x] YouTube thumbnail fallback cuando `mpris:artUrl` es archivo temporal eliminado
- [x] Video YouTube embebido vía `mpv --wid` (sin screenshots, sin lag)
- [x] Controles: prev, play/pause, next, seek bar, volumen, cerrar
- [x] Auto-ocultar controles tras 5s de inactividad
- [x] Aparecer controles al hover
- [x] Drag con `begin_move_drag`
- [x] Singleton vía PID file (segundo toggle cierra)
- [x] Teclas: ESC (cerrar), Space (play/pause), ←/→ (seek ±5s)
- [x] Seek también controla mpv via IPC socket
- [x] Play/pause también controla mpv via IPC
- [x] `--start=<pos_actual>` para reducir delay con el browser
- [x] Icono por player detectado (YouTube , Spotify , VLC 󰕼, etc.)
- [x] Placeholder muestra icono del player cuando no hay arte

### No funcionales
- [x] Sin dependencias nuevas (todo stdlib o ya instalado: GTK3, mpv, yt-dlp)
- [x] Sin bloqueo del main loop de GTK (threads para red/yt-dlp)
- [x] Race condition manejada (`mpv_pending` flag)
- [x] Drag no pelea con `position_window` (`dragging` flag)
- [x] Resize instantáneo (Revealer duration=0, no glitches en mpv)
- [x] mpv se mata al cambiar canción, cerrar player, o salir
- [x] Socket IPC se limpia al cerrar

## Waybar
- [x] Todos los módulos icon-only por defecto
- [x] Tooltip o hover reveal para texto
- [x] mpris: split en icono fijo (visible) + scrolling texto (hover via CSS sibling selector)
- [x] Brillo eDP/HDMI como JSON con icono + tooltip
- [x] Colores Catppuccin (morado/lavanda)

---

## Deuda técnica diferida

### Bugs conocidos

| Bug | Impacto | Upgrade path |
|-----|---------|-------------|
| mpv no se sincroniza con seek del browser | Si el usuario seekea en el browser, mpv queda desincronizado | Polling periódico: `_mpv_cmd(["set_property", "time-pos", cur_sec])` en update() cuando mpv_running |
| mpv reinicia desde `--start` en cada cambio de canción | Tiempo muerto mientras mpv bufferrea | Usar `--keep-open` + pausa en vez de matar/recrear; o cambiar a `libmpv` (python-mpv) |
| Ventana XWayland sin transparencia real | El `rgba` visual puede mostrar fondo negro en vez de transparente en algunos WM | `set_app_paintable(True)` + `draw` signal con Cairo para pintar el fondo redondeado manualmente |

### Simplificaciones deliberadas

| Decisión | Razón | Cuándo re-visitar |
|----------|-------|-------------------|
| `transition_duration=0` en Revealer | Animación resize confunde mpv embebido | Si se mueve a `libmpv` (no necesita resize sync) |
| mpv se mata al cambiar canción | Ciclo de vida simple, un solo proceso mpv a la vez | Si el delay de `--start` molesta, mantener mpv vivo y cambiar stream |
| `--no-audio` en mpv | El browser ya reproduce el audio | Si se quiere hacer del mpv el reproductor principal (en vez del browser) |
| GDK_BACKEND=x11 (XWayland) | mpv --wid solo funciona en X11 | Cuando mpv soporte `wl_surface*` embedding nativo en Wayland |
| Sin cola de mensajes para IPC | Fire-and-forget, se pierde respuesta si mpv ocupado | Agregar cola + retry si los comandos IPC fallan |
| Sin heartbeat mpv → hypr-player | No detecta si mpv crasheó hasta el próximo update() | `_check_mpv_alive()` con poll() cada 500ms es suficiente |

---

## Comandos de verificación

```bash
# hypr-player debe lanzarse y mostrar ventana
hypr-player
hyprctl clients -j | jq '.[] | select(.class=="Hypr-player")'

# mpv debe estar embebido (SIN ventana separada)
hyprctl clients -j | jq '.[] | select(.class=="mpv")'  # → vacío

# Waybar debe mostrar iconos
pgrep waybar

# Stream YouTube se extrae sin error
yt-dlp -g "$(playerctl metadata xesam:url)" 2>/dev/null | head -1
```

## Referencias
- Script: `~/.local/bin/hypr-player`
- Waybar config: `~/.config/waybar/config`
- Waybar style: `~/.config/waybar/style.css`
- [[hyprland-setup]]
