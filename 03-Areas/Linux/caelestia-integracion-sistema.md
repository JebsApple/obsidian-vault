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

## Pendiente manual del usuario

- `~/.face`: setear foto desde dashboard caelestia (SUPER+D).
- Apps Qt/GTK abiertas necesitan reabrirse para tomar el tema.
