---
tags: [sesion, hyprland]
---

# Sesión 2026-06-21 — Hyprland: keyhint, screenshots, notificaciones

## Archivos modificados

### `~/.config/hypr/hyprland.conf`
- `env=XDG_SCREENSHOTS_DIR` → `~/Imágenes/Capturas de pantalla`
- `env=PATH` → incluye `~/.local/bin`
- `exec-once` dunst comentado (no funciona)
- Screenshot binds: `SUPER+S` → region, `SUPER+SHIFT+S` → full screen, ambos via `screenshot.sh`
- Keyhint binds: `SUPER/ALT/CTRL/ALT+SHIFT + SPACE` con `bindr` para PID kill en release
- Submap `keyhint` agregado para bloquear scroll mientras keyhint abierto

### `~/.config/hypr/scripts/screenshot.sh`
- Estado actual: usa `grim -g "$(slurp)"` directo, guarda en `~/Imágenes/Capturas de pantalla/`, `wl-copy`, `hyprctl notify` (toast azul), `yad --picture` (preview 360x240, timeout 2s, sticky, on-top)
- **Pendiente**: yad --picture abre como ventana tiled (no flotante). `hyprctl dispatch togglefloating` con sleep no funcionó bien. Solución: window rules rotas en Hyprland 0.55, buscar alternativa (layer-shell? Gtk.WindowTypeHint?).

### `~/.local/bin/hypr-keyhint`
- Python GTK3 con buscador (`Gtk.SearchEntry`)
- `set_type_hint(POPUP_MENU)` para floating
- `GLib.timeout_add(80, togglefloating)` como workaround
- PID file en `/tmp/hypr-keyhint.pid` para toggle
- Captura Escape para cerrar

### `~/.local/bin/grimblast`
- Script de hyprwm/contrib (descargado de GitHub releases v0.8.0)
- Usa `grim` + `slurp` + `wl-copy` + `jq`
- Lock file en `$XDG_RUNTIME_DIR/grimblast.lock` — causa: solo funciona una vez hasta que se limpia el lock
- Workaround: `rm -f /run/user/1000/grimblast.lock` antes de ejecutar

### `~/.config/dunst/dunstrc`
- Creado por subagente, tema Catppuccin Mocha
- `protocol = xdg` para imágenes
- Dunst no está corriendo (nunca mostró notificaciones)

## Paquetes instalados

| Paquete | Estado |
|---------|--------|
| `mako` | Instalado, DBus roto (no muestra notifs) |
| `dunst` | Instalado, nunca mostró notifs |
| `grimblast` (AUR/hyprwm) | Descargado manual desde GitHub release |
| `hyprnotify` (AUR) | Instalado v0.8.0, binario compilado Sep 2024, no funcionó |

## Lecciones aprendidas

1. **XDG dirs en español**: `xdg-user-dir PICTURES` → `~/Imágenes/`, capturas → `~/Imágenes/Capturas de pantalla/`
2. **grimblast lock file**: solo permite una ejecución simultánea. Si el proceso anterior no terminó (por notify-send colgado, etc.), el lock queda y el siguiente `grimblast` no arranca.
3. **`hyprctl notify`**: texto-only, no soporta imágenes. Usar `fontsize:20` en el mensaje para forzar render. Con `vfr=true` (default) puede no mostrar la notif hasta el próximo input.
4. **Window rules rotas en Hyprland 0.55**: no se pueden usar `windowrule=` ni `windowrulev2=`. Para flotar ventanas: `hyprctl dispatch togglefloating` o `set_type_hint()` en GTK.
5. **`notify-send` puede colgarse**: si no hay notification daemon corriendo, `notify-send` bloquea hasta timeout (~15s). Siempre lanzarlo con `&` (background) para no bloquear.
6. **Prebuilt hyprnotify v0.8.0 (Sep 2024)**: no funciona con Hyprland actual. Recompilar desde source o actualizar.

## Pendientes

- [ ] Preview de screenshot como ventana flotante (yad --picture se abre tiled). Probar: `Gtk.WindowTypeHint.POPUP_MENU`, `gtk-layer-shell`, o `hyprctl dispatch setfloating`
- [ ] Decidir notification daemon: dunst, nwg-notifications, o custom Python GTK3
- [ ] `Alt+Shift+Space` bindr: revisar timing (pkill vs PID file race condition)
