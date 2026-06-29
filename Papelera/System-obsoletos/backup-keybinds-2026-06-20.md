---
tags: [backup, hyprland]
---

# Backup Keybinds — 2026-06-20

## Config actual: `~/.config/hypr/hyprland.conf`

### Variables
```
$mainMod = SUPER
$terminal = kitty
$fileManager = dolphin
$menu = wofi --show drun
```

### Super (mod)
| Tecla | Acción |
|-------|--------|
| Q | kitty |
| C | killactive (cerrar) |
| M | hyprshutdown / exit |
| E | dolphin |
| V | togglefloating |
| R | wofi (drun) |
| SPACE | hypr-keyhint |
| P | pseudo (dwindle) |
| J | togglesplit |
| ←↑↓→ | movefocus |
| 1-0 | workspace 1-10 |
| mouse_down/up | workspace e+1/e-1 |
| mouse:272 | movewindow (drag) |
| mouse:273 | resizewindow |

### Super + Shift
| Tecla | Acción |
|-------|--------|
| 1-0 | movetoworkspace 1-10 |
| S | movetoworkspace special:magic |

### Alt + Shift
| Tecla | Acción |
|-------|--------|
| O | kitty -e opencode |
| SPACE | hypr-keyhint |

### IMPORTANTE: Scripts perdidos
Los siguientes scripts estaban en `~/.config/hypr/scripts/` y se borraron. Hay que recrearlos:

#### `traducir.sh` (Super+T)
Abría ws10 → GDrive izq + DeepL der (preselect right)

#### `traducir3.sh` (Super+Alt+T)
Abría ws10 → 3 ventanas (preselect right → preselect right → resize)

#### `screenshot.sh`
```
#!/bin/bash
grim - | wl-copy && notify-send -t 1500 "Screenshot" "Copiado al portapapeles"
```

#### `atajos.sh`
Mostraba sticky note con atajos via kitty transparente

#### `paste-enter.sh`
```
wl-paste | wtype - ; wtype -k Return
```

#### `equalize.sh`
Equalizar ventanas (splitratio)

#### `show-desktop.sh`
Toggle ws vacío 99

### Multimedia
| Tecla | Acción |
|-------|--------|
| XF86AudioRaiseVolume | wpctl 5%+ |
| XF86AudioLowerVolume | wpctl 5%- |
| XF86AudioMute | toggle |
| XF86AudioMicMute | toggle source |
| XF86MonBrightnessUp | brightnessctl 5%+ |
| XF86MonBrightnessDown | brightnessctl 5%- |
| XF86AudioNext | playerctl next |
| XF86AudioPause | playerctl play-pause |
| XF86AudioPlay | playerctl play-pause |
| XF86AudioPrev | playerctl previous |
