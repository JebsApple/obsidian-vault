---
tags:
  - project/active
  - linux/rice
  - caelestia
status: active
repo: https://github.com/JebsApple/caelestia-rice
created: 2025-07-14
---

# Caelestia Rice — Dark Glassmorphism

## Resumen

Personalización estética completa de Linux partiendo de [Caelestia](https://github.com/caelestia-dots/caelestia) (Hyprland + QuickShell). Estilo: **Dark & Cozy + Glassmorphism** con colores dinámicos.

## Stack

| Componente | Actual | Objetivo |
|------------|--------|----------|
| Compositor | Hyprland | ✅ Ya tiene |
| Shell/Bar | Caelestia QuickShell | Configurar tokens |
| Terminal | foot (default) | **Kitty** |
| File Manager | thunar | **Dolphin** |
| Browser | brave | ✅ Ya tiene |
| Launcher | Caelestia integrado | Configurar fuzzel glass |
| Prompt | bash básico | **Starship** |
| Lock | — | **Hyprlock** |
| Wallpaper | — | Anime + Forest |
| Iconos | — | Papirus-Dark |

## Perfil Estético

- **Mood:** Dark & Cozy + Glassmorphism
- **Paleta:** Dinámica (Material You), acentos púrpura/violeta, rosa/mint
- **Transparencia:** Sutil (10-20% terminal, 20-30% Dolphin)
- **Blur:** Moderado (size=8, passes=2-3) — AMD/Intel
- **Animaciones:** Balance (4-5 animaciones, no abusar)
- **Redondeo:** 12-15px ventanas, 17px elementos flotantes

## Áreas de Personalización

### Fase 1 — Fundamentos
- [ ] Wallpapers (~/Pictures/Wallpapers — anime + forest)
- [ ] Dynamic color scheme (`caelestia scheme set -n dynamic`)
- [ ] Touchpad scroll fix (hecho en hypr-user.lua)
- [ ] Keyboard layout toggle (Copilot button, hecho)

### Fase 2 — Hyprland Glass
- [ ] Blur: size=8, passes=3
- [ ] Transparency: windowOpacity=0.85
- [ ] Shadow: colored shadows
- [ ] Animations: 5 animaciones principales
- [ ] Gaps y borders

### Fase 3 — Terminal (Kitty)
- [ ] Instalar Kitty
- [ ] Config: transparencia 10-20%
- [ ] Color theme matching paleta dinámica
- [ ] Font: CaskaydiaCove Nerd Font

### Fase 4 — Dolphin
- [ ] qt6ct + Kvantum para theming
- [ ] Transparencia + blur
- [ ] Toolbar custom

### Fase 5 — Shell/Bar
- [ ] Caelestia shell tokens (rounding, spacing, fonts)
- [ ] Color selector custom (3 círculos interactivos)
- [ ] Transparency layers

### Fase 6 — Launcher
- [ ] Fuzzel con glassmorphism
- [ ] Custom themes

### Fase 7 — Apps
- [ ] Discord (BetterDiscord/Vencord theme)
- [ ] Obsidian (CSS custom)
- [ ] Spotify (Spicetify theme)
- [ ] VS Code (token theme)
- [ ] Cava visualizer

### Fase 8 — Prompt
- [ ] Starship config
- [ ] Powerline vs minimal
- [ ] Colors matching scheme

### Fase 9 — Lock Screen
- [ ] Hyprlock glass effect
- [ ] Background blur
- [ ] Clock widget

### Fase 10 — Btop/Cava
- [ ] Btop theme
- [ ] Cava color config

## Comandos Clave

```bash
# Cambiar wallpaper
caelestia wallpaper -f <path>
caelestia wallpaper -r  # random

# Cambiar color scheme
caelestia scheme set -n dynamic

# Reiniciar shell
Ctrl+Super+Alt+R

# Editar overrides Hyprland
~/.config/caelestia/hypr-user.lua

# Editar tokens estéticos
~/.config/caelestia/shell-tokens.json

# Editar CLI theming
~/.config/caelestia/cli.json
```

## Archivos Importantes

| Archivo | Uso |
|---------|-----|
| `~/.config/caelestia/hypr-user.lua` | Overrides Hyprland (monitores, touchpad, keybinds) |
| `~/.config/caelestia/shell-tokens.json` | Tokens: rounding, spacing, fonts, animaciones |
| `~/.config/caelestia/cli.json` | Habilitar/deshabilitar theming por app |
| `~/.config/hypr/variables.lua` | Variables globales (terminal, browser, blur, etc.) |
| `~/.config/hypr/hyprland/decoration.lua` | Decoración base |
| `~/.config/hypr/hyprland/animations.lua` | Animaciones |
| `~/.config/hypr/hyprland/keybinds.lua` | Keybindings |

## Referencias

- [Caelestia Docs](https://caelestia-docs.com)
- [Caelestia Shell](https://github.com/caelestia-dots/shell)
- [Caelestia CLI](https://github.com/caelestia-dots/cli)
- [NotebookLM Research](https://notebooklm.google.com/notebook/0d8df607-4f0d-4bf3-9ed2-54383b1614dd)
