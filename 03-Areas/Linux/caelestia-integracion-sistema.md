---
created: 2026-07-13
tags:
  - area/linux
  - sistema/cachyos
  - tipo/registro
aliases:
  - Caelestia Integración Sistema
---

# Caelestia — integración estética + hotkeys (2026-07-13)

## Hotkeys reparados en `hyprland.lua`

Sintaxis vieja `caelestia shell message ...` daba "Target not found". Correcta: `caelestia shell <target> <función>`.

| Bind | Ahora ejecuta |
|------|---------------|
| SUPER+Escape | `caelestia shell lock lock` |
| SUPER+R | `caelestia shell drawers toggle launcher` |
| SUPER+D | `caelestia shell drawers toggle dashboard` (antes duplicaba launcher) |
| SUPER+L | `caelestia shell drawers toggle session` |

Drawers válidos: bar, osd, session, launcher, dashboard, utilities, sidebar. Ver IPC: `caelestia shell -s`.

## Estética sistema-completo (scheme dinámico de caelestia)

- **GTK:** ya sincronizado — caelestia genera `~/.config/gtk-{3,4}.0/gtk.css` con colores del scheme + adw-gtk3-dark.
- **Terminal (kitty):** agregado a `~/.zshrc` cat de `~/.local/state/caelestia/sequences.txt` (colores dinámicos, cualquier terminal).
- **Qt:** instalado `darkly-bin` (estilo Qt oficial de caelestia-dots); qt5ct/qt6ct: `style=Darkly`, `icon_theme=Papirus-Dark`. `QT_QPA_PLATFORMTHEME=qt6ct` ya estaba en hyprland.lua.
- **Iconos:** `papirus-folders -C cat-mocha-lavender --theme Papirus-Dark` (carpetas a juego con acento lavanda).

## Paquetes desktop obsoletos eliminados (mismo día)

waybar, waypaper, mako, dunst, swaync, hyprpaper, hyprlock, wlogout, wofi, wl-gammarelay. `playerctl` marcado explícito (lo usan los binds de media). Configs/scripts/services legacy archivados en `~/Datos/Backups/desktop-legacy-20260713/`.

## Keyhint (SUPER+SPACE) — integrado AL launcher de caelestia — 2026-07-13

**Shell forkeado** a `~/.config/quickshell/caelestia` (copia de `/etc/xdg/quickshell/caelestia` — quickshell prioriza el user dir). ⚠️ Updates del paquete `caelestia-shell` NO aplican mientras exista el fork; para volver al original: `rm -rf ~/.config/quickshell/caelestia` y reiniciar shell.

Archivos del fork (diff vs original):
- `modules/launcher/services/Keybinds.qml` (nuevo) — Searcher que carga `~/.config/caelestia/keybinds.json` + flag `wantOpen`
- `modules/launcher/items/KeybindItem.qml` (nuevo) — fila con icono Material + nombre/sección + chip mono con la tecla
- `modules/launcher/AppList.qml` — estado `keys` agregado (prefijo `>keys `)
- `modules/launcher/Content.qml` — prefill `>keys ` al abrir vía IPC
- `modules/Shortcuts.qml` — IpcHandler `target: "keybinds"` con `open()` (toggle)

Uso: `SUPER+SPACE` / `ALT+SPACE` → `caelestia shell keybinds open`. También escribir `>keys ` en el launcher normal. Búsqueda fuzzy integrada. **Teclas se editan en `~/.config/caelestia/keybinds.json`** (JSON plano, sin tocar QML).

Script GTK viejo archivado en `Datos/Backups/desktop-legacy-20260713/bin/hypr-keyhint-gtk`. Submap "keyhint" eliminado de hyprland.lua.

## Explorador de archivos → Thunar

Dolphin (Qt/KDE) no seguía el scheme. Instalado `thunar + thunar-volman + thunar-archive-plugin + tumbler + gvfs`, aplicada config de caelestia-dots (`uca.xml`, `thunar-volman.xml`). `SUPER+E` y `ALT+SHIFT+E` ahora abren Thunar; default MIME `inode/directory` = thunar. Thunar es GTK: toma los colores generados por caelestia automáticamente. Dolphin sigue instalado por si acaso.

## Brillo por pantalla (interno + HDMI) — 2026-07-15

`services/Brightness.qml` del fork traía dos bugs y una limitación de hardware sin resolver:

1. **`Bar.qml` handleWheel** (scroll de brillo en la barra): `Brightness.getMonitorForScreen(screen)` podía devolver `null` (pantalla aún no registrada, ej. tras reconectar HDMI) y el código llamaba `monitor.brightness` sin chequear → TypeError silencioso, scroll no hacía nada en esa pantalla. Fix: guard `if (!monitor) return;`.

2. **Panel interno se apagaba del todo al bajar brillo**: `brightnessctl s 0%` corta el backlight completo. El flag `--min-value`/`-n` de brightnessctl NO protege valores absolutos, solo deltas (`+`/`-`) — por eso no alcanzaba con pasarle esa opción. Fix real: clamp en `setBrightness()` a piso 1% (`0.01`) antes de llamar brightnessctl.

3. **HDMI (AOC LE22H037) no respondía nada, ni con el fix de arriba**. Investigado a fondo con `ddcutil` directo (sin caelestia de por medio): el LE22H037 es un **TV**, no monitor de PC (línea "LE" de AOC — tuner analógico, resolución máx 1360x768 por VGA). Nunca implementó DDC/CI: `ddcutil -b 2 getvcp 10` responde `DDCRC_REPORTED_UNSUPPORTED` incluso con `--skip-ddc-checks`, `--sleep-multiplier`, `--mccs` forzado. No es config oculta ni bug de driver — el firmware del TV no tiene esa feature. Sin fix de software posible por esa vía.

   Solución: recuperada de la config vieja de waybar (`legacy-scripts/brightness`, ver [[brillo-hdmi-hyprsunset-service]]) — el brillo de pantallas externas se **fingía por gamma**, no por hardware real: `hyprctl hyprsunset gamma_output <nombre> <valor 0-1>`. El servicio `hyprsunset.service` (`~/.config/systemd/user/`) había quedado deshabilitado en la migración a caelestia (el comentario en `hyprland.lua` decía "caelestia reemplaza hyprsunset", pero caelestia solo tiene night-light, no brillo por gamma) → lo re-habilité: `systemctl --user enable --now hyprsunset.service`.

   Reescribí `Monitor` en `Brightness.qml`: eliminada toda la detección DDC (`ddcMonitors`, `ddcProc`, `isDdc`, `busNum` — no funcionaba y no se usaba en otro lado). Nueva clasificación por `isInternal` (regex `^(eDP|LVDS|DSI)` sobre el nombre de pantalla, igual criterio que usaba `hypr-active-monitor` en waybar):
   - interno → `brightnessctl` (piso 1%)
   - Apple Studio Display → `asdbctl` (sin cambios)
   - resto (HDMI/DP externos) → `hyprctl hyprsunset gamma_output` (piso 10% — gamma más baja vuelve la imagen ilegible en vez de solo oscurecer, no hay "apagado" real que evitar)

   Gamma no tiene IPC de lectura, así que el estado interno arranca en 1.0 (100%) y se trackea solo en memoria del proceso qs (se resetea a 100% si se reinicia el shell — igual que el `state file` que usaba el script viejo, pero sin persistencia entre reinicios; no implementado por ahora).

Verificación: `qs -c caelestia ipc call brightness setFor "HDMI-A-1" 60%` → aplica gamma real, sin errores en `/run/user/1000/quickshell/by-id/*/log.log`.

## Pendiente manual del usuario

- `~/.face`: setear foto desde dashboard caelestia (SUPER+D).
- Apps Qt/GTK abiertas necesitan reabrirse para tomar el tema.
