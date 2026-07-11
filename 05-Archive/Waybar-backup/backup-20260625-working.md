---
tags:
  - backup
  - waybar
  - hover
  - type/snapshot
---

# Backup 2026-06-25 — Waybar hover redesign

## Qué se respaldó

Backup completo del sistema funcional post-rediseño del hover de Waybar.
Modo activo: legacy (daemon global, módulos en orden original).

### Archivos

| Origen | Destino |
|--------|---------|
| `~/.config/hypr/hyprland.lua` | `bak/20260625-working/hyprland.lua` |
| `~/.config/waybar/config` | `bak/20260625-working/waybar/config` |
| `~/.config/waybar/style.css` | `bak/20260625-working/waybar/style.css` |
| `~/.config/waybar/config.legacy` | `bak/20260625-working/waybar/config.legacy` |
| `~/.config/waybar/style.legacy.css` | `bak/20260625-working/waybar/style.legacy.css` |
| `~/.config/waybar/config.modern` | `bak/20260625-working/waybar/config.modern` |
| `~/.config/waybar/style.modern.css` | `bak/20260625-working/waybar/style.modern.css` |
| `~/.config/waybar/legacy-scripts/*` | `bak/20260625-working/waybar/legacy-scripts/` |
| `~/.config/waybar/modern-scripts/*` | `bak/20260625-working/waybar/modern-scripts/` |
| `~/.local/bin/{waybar-hover-daemon,toggle-waybar-mode,pulseaudio,...}` | `bak/20260625-working/local-bin/` |
| `~/.config/systemd/user/waybar-hover-daemon.service` | `bak/20260625-working/systemd/` |
| `~/.local/state/waybar-mode` | `bak/20260625-working/waybar-mode` |

## Por qué

- Claude (sesión 2026-06-25) hizo cambios al waybar que rompieron el orden de módulos y la expansión hover
- No había backup completo — solo `hyprland.lua.bak` (no incluía waybar configs, CSS, scripts, ni services)
- Lección: backup = TODO lo necesario para restaurar funcionamiento completo
- Regla documentada en `CLAUDE.md`
