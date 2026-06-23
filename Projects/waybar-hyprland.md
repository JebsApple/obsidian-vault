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
~/.config/systemd/user/waybar-hover-daemon.service  (BindsTo=waybar)
```

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

## hypr-player

GTK4, app_id `com.github.hypr-player`. Hyprland rules:
```
windowrulev2 = float, class:^(com.github.hypr-player)$
windowrulev2 = pin,   class:^(com.github.hypr-player)$
windowrulev2 = size 420 300, class:^(com.github.hypr-player)$
```

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
