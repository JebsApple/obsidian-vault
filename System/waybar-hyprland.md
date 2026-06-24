---
tags: [proyecto, hyprland, waybar, desktop, linux]
created: 2026-06-22
---

# Waybar + Hyprland — Configuración completa

## Arquitectura general

```
hyprland
  └── waybar (systemd user service)
        ├── módulos izquierda: workspaces
        ├── módulo centro: custom/clock
        └── módulos derecha: pulseaudio, brightness-edp, brightness-hdmi,
                             network, bluetooth, mpris, battery, tray
  └── waybar-hover-daemon (systemd user service, BindsTo=waybar)
  └── hypr-player (GTK4, flotante, se abre desde clic en mpris)
```

## Servicios systemd

```
~/.config/systemd/user/waybar.service
~/.config/systemd/user/waybar-hover-daemon.service  (independiente, Restart=always)
```

> ⚠️ **2026-06-23:** el hover-daemon usaba `BindsTo=waybar.service`, que lo
> mataba al reiniciar waybar pero NO lo rearrancaba → quedaba huérfano y los
> módulos dejaban de expandir. Ahora es **independiente** (`WantedBy=default.target`,
> `Restart=always`, `After=waybar.service`); el daemon ya relee `pidof waybar`
> y `hyprctl layers` en cada ciclo, así que sobrevive a cualquier `waybar-reload`.

Comandos:
```bash
systemctl --user restart waybar
systemctl --user status waybar-hover-daemon
```

## Archivos clave

| Archivo | Descripción |
|---------|-------------|
| `~/.config/waybar/config` | Configuración de módulos y acciones |
| `~/.config/waybar/style.css` | Estilos (colores Catppuccin Mocha) |
| `~/.local/bin/clock` | Bash: hora+fecha en español |
| `~/.local/bin/pulseaudio` | Bash: volumen/mute con pactl |
| `~/.local/bin/battery` | Bash: batería desde /sys |
| `~/.local/bin/network` | Bash: wifi/ethernet con nmcli |
| `~/.local/bin/bluetooth` | Bash: estado con bluetoothctl |
| `~/.local/bin/brightness-edp` | Bash: brillo laptop con brightnessctl |
| `~/.local/bin/brightness-hdmi` | Bash: brillo HDMI desde state file |
| `~/.local/bin/mpris` | Python3 daemon: MPRIS + marquee ticker |
| `~/.local/bin/waybar-hover-daemon` | Python3 daemon: expande módulos en hover |
| `~/.local/bin/hypr-player` | Python3 GTK4: reproductor flotante |

## Sistema de hover-expand

Los módulos del lado derecho muestran **solo el ícono** normalmente.
Al pasar el cursor por la zona derecha de la barra, todos se **expanden** mostrando texto.

**Mecanismo:**
1. `waybar-hover-daemon` hace poll a `hyprctl cursorpos` cada 50ms
2. Lee las zonas de waybar desde `hyprctl layers -j` (multimonitor)
3. Cuando el cursor entra en la mitad derecha de cualquier barra:
   - Escribe `"1"` en `~/.local/state/waybar-hover-group`
   - Envía `SIGRTMIN+1` a todos los PIDs de waybar
4. Cuando el cursor sale (debounce 500ms):
   - Escribe `"0"` y vuelve a señalizar
5. Los scripts bash leen `waybar-hover-group` en cada ejecución:
   - `"0"` → emite solo `<span font_size='10pt'>ÍCONO</span>`
   - `"1"` → emite `<span font_size='10pt'>ÍCONO</span> texto`
6. mpris (daemon continuo) lee el archivo en su loop (~0.5s lag)

**Por qué no font-size: 0px:**
`pango_font_description_set_size: assertion 'size >= 0' failed` → la matriz Cairo
se vuelve singular → `drawing failure: invalid matrix (not invertible)` → widget
invisible. Se eliminó completamente; la lógica vive en los scripts.

## Módulos colapsables — contrato JSON

Todos los scripts emiten `return-type: json` con:
```json
{"text": "<span foreground='#COLOR' font_size='10pt'>ÍCONO</span>[ texto]",
 "tooltip": "...",
 "class": "[estado] [expanded]"}
```

La clase `expanded` es la que activa el background highlight en CSS.

## Módulos — referencias rápidas

| Módulo | Ícono colapsado | Texto expandido | on-click |
|--------|----------------|-----------------|----------|
| pulseaudio | /  según volumen | `75%` | pavucontrol |
| brightness-edp | | `80%` | nwg-displays |
| brightness-hdmi |  | `100%` | nwg-displays |
| network | /󰈁/ | SSID o IP | nm-connection-editor |
| bluetooth | /󰂲 | dispositivo conectado | blueman-manager |
| mpris |  player icon | título • artista (marquee) | hypr-player |
| battery | //// | `85%` | swaync-client -t |

## mpris daemon

- Detecta player activo con `playerctl status/metadata`
- Mapea nombre de player a ícono Nerd Font (`ICON_MAP`)
- Detecta YouTube por `xesam:url`
- Si título > 29 chars y hover=True → ticker marquee a 6 chars/seg
- Sin reproducción → ícono  dimmed

## hypr-player (v8 — 2026-06-23)

GTK3 **Wayland nativo** (`GDK_BACKEND=wayland`) + **GtkLayerShell**. **Sin mpv, sin yt-dlp.**
Clases: `PlayerController` (MPRIS/playerctl) · `ArtWidget` (Cairo cross-fade) ·
`MarqueeLabel` · `ProgressBar` · `PlayerWindow` (modos MUSIC / COMPACT, tecla `C`).

### Flotado: GtkLayerShell (no window rules)
- En 0.55 las `windowrulev2 = float,...` y `hyprctl dispatch movewindowpixel`
  están rotos (dispatch parsea args como Lua). Solución: la ventana es una
  **superficie layer-shell** anclada a BOTTOM+RIGHT con margen `MARGIN`.
- `set_keyboard_mode(ON_DEMAND)` (teclas al hacer foco con clic).
- `set_monitor()` al monitor del cursor; sigue al cursor entre monitores cada 10s.
- Aparece en `hyprctl layers` (namespace `hypr-player`), NO en `hyprctl clients`.
- Estilo en hyprland.conf: `layerrule = blur, hypr-player`.
- Singleton **toggle real**: clic abre / 2º clic cierra (no replace).
- Args: acepta `--player yt|music|vlc` (con espacio) y `--player=...`.

### Approach de control: MPRIS puro
- Controla el browser directamente via `playerctl` (prev/next/play-pause/seek/position)
- `playerctl position` sí devuelve posición real de YouTube en tiempo real (via plasma-browser-integration)
- Polling 500ms → progress bar + tiempo sincronizados con el browser
- D-Bus `PropertiesChanged` → cambio de canción detectado instantáneamente

### Arquitectura
```
PlayerWin
  ├── ArtWidget (Gtk.DrawingArea + Cairo) — esquinas redondeadas, cover fill, gradiente inferior
  ├── Labels: título (bold), artista (muted)
  ├── HScale progress + label tiempo "MM:SS / MM:SS"
  └── HBox: [prev] [play (pill)] [next] ── [VolumeButton]

Threading:
  Main loop GTK ← GLib.idle_add ← background threads (playerctl)
  Poll 500ms → _fetch_position → GLib.idle_add(_update_position)
  D-Bus signal → thread → _fetch_meta → GLib.idle_add(_apply_meta)
```

### Dimensiones
- Ventana: 380px ancho, RGBA (`rgba(24,24,37,0.95)`) con border-radius 16px
- Art: 380×210px, DrawingArea con Cairo (rounded top 12px, cover-fill, gradiente)
- Posición: esquina inferior-derecha del monitor donde está el cursor

### Parámetros
```bash
hypr-player --player=yt     # YouTube (default)
hypr-player --player=music  # Spotify / YouTube Music
hypr-player --player=vlc    # VLC
```

### Hyprland (posicionamiento manual via hyprctl)
La ventana usa `title:hypr-player`. `_position_window()` llama `hyprctl dispatch movewindowpixel exact X Y` a los 300ms del arranque.

### Versiones anteriores
| Versión | Approach | Problema |
|---------|----------|----------|
| v4 | GTK3 + Gtk.Socket + mpv XWayland | `realize` signal ya disparado cuando se conecta |
| v5 | python-mpv + D-Bus polling | Threading deadlock en terminate() |
| v6 | mpv subprocess + IPC socket JSON | Reproduce stream independiente (no sync con browser) |
| v7 | MPRIS puro (playerctl) | ✓ Sincronizado con el browser en tiempo real |

## Backups

```
~/.config/waybar/bak/
  20260621/          ← config original (módulos nativos waybar)
  20260622/          ← primer estado custom
  20260622-fase1/    ← primera iteración hover
  20260622-fase2/    ← versión con font-size:0px (bug Pango)
  20260622-rebuild/  ← estado antes de la reconstrucción final
```

## Bugs conocidos y solucionados

| Bug | Causa | Solución |
|-----|-------|----------|
| Módulos invisibles | `font-size: 0px` → Pango assertion | Eliminar truco; scripts emiten texto condicionalmente |
| Hover no activaba en HDMI | `get_waybar()` solo retornaba primer rect | `get_waybar_zones()` retorna lista de todos los rects |
| Bluetooth/mpris desaparecían en 1280px | `margin: 2px 37px` → overflow | `margin: 2px 2px` |
| brightness no respondía a señal | Sin `"signal": 1` en config | Agregado `"signal": 1` |
| mpris huérfanos al reiniciar waybar | Procesos no terminados | Corregido; systemd limpia hijos |
| Hover dejó de expandir módulos | `BindsTo=waybar` mataba el daemon al `waybar-reload` y no lo rearrancaba | Daemon independiente: `WantedBy=default.target`, `Restart=always`, sin `BindsTo` |
| hypr-player abría tiled (grande) | window rules + `hyprctl dispatch` rotos en 0.55 | Migrado a **GtkLayerShell** (Wayland), anclado a esquina |
| Módulos music/VLC abrían el player de YouTube | parser solo aceptaba `--player=X` | Aceptar también `--player X` (con espacio) |
| Clic en módulo no cerraba el player | singleton hacía replace en vez de toggle | Si hay instancia viva → SIGTERM + `sys.exit(0)` |
