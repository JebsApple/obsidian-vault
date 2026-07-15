---
name: "Linux Desktop Config"
description: "Use when configuring Hyprland/Wayland desktop, debugging Waybar modules, fixing system services, or building GTK3 Wayland apps. Triggers: Hyprland Lua config, hyprctl dispatch, Waybar hover, mako DBus, chroma-mcp leak, hypr-player, zen-pip-toggle, audit playbook. Skip for application-level code not related to desktop environment."
user-invocable: false
---

# Linux Desktop Config

## Domain
Hyprland/Wayland desktop environment configuration, troubleshooting, and custom tooling. Covers the full stack from system services (mako, systemd) through Hyprland Lua config to GTK3 Wayland-native apps (hypr-player, waybar-hover-daemon).

## Core Concepts
- **Hyprland Lua Config Ecosystem**: `hyprland.lua` is the real config. `hl.dispatch()` evaluates Lua expressions. `hl.dsp` API (focus, exec_cmd, window) was discovered via error messages. Dispatchers interpret args as Lua in 0.55+.
- **Waybar Architecture**: Hover-expand daemon (`waybar-hover-daemon` polls cursorpos, sends SIGRTMIN+1). "Celdas" redesign (WIP) — cell ≠ button, toggle via SUPER+SHIFT+B. Waybar + Hyprland is the complete architecture.
- **hypr-player Evolution**: v4-v6 (GTK3 + mpv + yt-dlp + XWayland) → v7 (MPRIS pure, no mpv) → v8 (GTK3 Wayland native + GtkLayerShell, no mpv). Progressive simplification.
- **System Audit**: `fix-audit-20260712` script fixed chroma-mcp orphan process leaks and mako.service DBus conflicts with caelestia-shell. Playbook (`audit-sistema`) is the reusable playbook.
- **Package Hygiene**: Obsolete desktop packages removed (waybar legacy, mako, hyprpaper, hyprlock, wlogout, wofi) — replaced by caelestia-shell integration.
- **zen-pip-toggle**: PiP for Zen/Firefox via wtype, calls `hl.dsp` API.

## Key Relationships
- Waybar architecture → implements → waybar-hover-daemon + hypr-player v8
- hyprctl dispatch (Lua) → references → Hyprland config Lua → references → Waybar architecture
- Rediseño celdas → references → hyprctl dispatch → references → Hyprland Setup
- Playbook auditoría → references → chroma-mcp leak + mako conflict
- hypr-player v7 → semantically_similar_to → hypr-player v8 (evolution)
- zen-pip-toggle → calls → hl.dsp API (discovered through error messages)

## Mental Models
- **"Read the IPC, not the drivers"**: Monitor awareness comes from Hyprland IPC, not hardware drivers. The compositor knows what's connected.
- **"Lua eval is a minefield"**: Hyprland dispatchers evaluate Lua expressions — powerful but dangerous. Test in isolation, never in a live session (especially hyprlock).
- **"Wayland-native or nothing"**: XWayland apps add complexity. GtkLayerShell gives GTK3 apps native Wayland layer semantics. mpv --wid was a stepping stone, not the destination.
- **"Audit scripts are living documents"**: The fix-audit script captures real failures. Re-run periodically — new orphans accumulate.

## When NOT to use
- Skip for Hyprland config theory without hands-on debugging (community 11 has the quirks)
- Skip for GTK3 app development not targeting Wayland layers
- Skip for systemd service management unrelated to desktop environment
