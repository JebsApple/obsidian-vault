---
tags:
  - project/active
  - tracking
status: active
source_plan: "[[Caelestia-Rice]]"
updated: 2026-07-15
---

# Caelestia Rice — Tracking

Plan original en `Caelestia-Rice.md` (10 fases) estaba desactualizado vs sistema real. Este tracking refleja estado verificado 2026-07-15 y ejecución con sub agentes.

## Decisión pendiente resuelta
- **File manager**: usuario pide personalizar AMBOS (Dolphin + Thunar), quedarse con el que se vea mejor estéticamente. No es un solo objetivo fijo.

## Estado verificado (antes de ejecutar)

| Fase | Item | Estado real |
|------|------|-------------|
| 1 | Wallpapers | ✅ hecho (frieren, mushoku, oshinoko, rezero, witchhat, landscapes) |
| 1 | Dynamic scheme | ✅ vía scheme.current en variables.lua |
| 1 | Touchpad/keyboard fixes | ✅ hecho (hypr-user.lua) |
| 2 | Blur/shadow/gaps | ✅ configurado (blurSize=8 passes=2, shadow con color de scheme, gaps 20/5/10/20) — desvío menor vs plan (passes=3, opacity=0.85) |
| 3 | Kitty | ⚠ instalado, kitty.conf existe — falta verificar transparencia/font/paleta |
| 4 | File manager | ⚠ Thunar activo, Dolphin también instalado — falta themear ambos |
| 5 | Shell tokens | ⚠ usa `shell.json` (no `shell-tokens.json` como dice doc viejo) — ya tiene bar/sidebar/launcher config, falta selector de color custom |
| 6 | Launcher (fuzzel) | ⚠ fuzzel binario existe pero config activa parece gestionada por caelestia shell, no standalone — verificar |
| 7 | Apps: Discord | ✅ Vencord+BetterDiscord instalados — falta verificar CSS con paleta actual |
| 7 | Apps: Spotify (spicetify) | ❌ no instalado |
| 7 | Apps: Obsidian CSS | ❌ no verificado |
| 7 | Apps: VSCode theme | ❌ no verificado |
| 7 | Cava | ❌ no instalado |
| 8 | Starship | ✅ instalado y configurado — falta confirmar paleta dinámica |
| 9 | Lock screen | ✅ ya usa `caelestia shell lock` (propio de Caelestia) — Hyprlock del plan viejo es obsoleto, no aplica |
| 10 | Btop | ✅ instalado — falta verificar tema |
| 10 | Cava | ❌ no instalado |

## Ejecución (sub agentes, batches de máx 3 en paralelo, sin archivos compartidos)

### Batch 1
- [ ] Agent A — Terminal & Prompt: Kitty (transparencia, font CaskaydiaCove, paleta dinámica) + Starship (confirmar/ajustar paleta)
- [ ] Agent B — File Managers: themear Thunar (GTK) y Dolphin (qt6ct+Kvantum) ambos con glass/paleta, dejar nota comparativa
- [ ] Agent C — Media apps: instalar+configurar Cava (paleta), instalar+configurar Spicetify (Spotify), verificar tema Btop

### Batch 2
- [ ] Agent D — Launcher/Shell: verificar y ajustar fuzzel/launcher glass, revisar shell.json (selector de color custom fase 5), confirmar lock screen (caelestia shell lock) estética
- [ ] Agent E — Apps: Discord (Vencord/BetterDiscord CSS con paleta), Obsidian CSS, VSCode token theme

## Notas
- Ningún agente hace `sudo` desde Bash — pedirá al usuario correr comandos con `!` si hace falta.
- Instalaciones de paquete (spicetify-cli, cava) via pacman/AUR — confirmar antes de instalar si requiere AUR helper.
