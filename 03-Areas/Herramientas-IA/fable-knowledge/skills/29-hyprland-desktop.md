---
name: "Hyprland Desktop Ecosystem"
description: "Use when configuring Hyprland desktop environment components. Triggers: Hyprland config, waybar hover, wofi launcher, kitty terminal, dolphin hyprland. Skip if unrelated to Hyprland/Wayland desktop."
user-invocable: false
---

# Hyprland Desktop Ecosystem

## Domain
Hyprland Wayland compositor ecosystem — configuration, status bar, launcher, terminal, and file manager components working together as a cohesive desktop environment.

## Core Concepts
- **Hyprland**: Tiling Wayland compositor — dynamic window management with animations
- **Waybar**: Status bar showing workspaces, system info, custom modules
- **waybar-hover-daemon**: Custom daemon extending Waybar with hover-expandable modules (legacy + modern output)
- **toggle-waybar-mode**: Script to switch between modern and legacy Waybar hover modes
- **wofi**: Application launcher (Wayland-native, keyboard-driven)
- **kitty Terminal**: GPU-accelerated terminal emulator for Hyprland
- **Dolphin File Manager**: KDE file manager, configured for Hyprland use

## Key Relationships
- Hyprland → uses → Waybar (status bar integration)
- Hyprland → configured_as → wofi (launcher binding)
- Hyprland → configured_as → kitty Terminal (terminal binding)
- Hyprland → configured_as → Dolphin File Manager (file manager binding)
- Waybar → extended_by → waybar-hover-daemon (custom hover modules)

## Mental Models
- **Component binding**: Hyprland configures which apps handle terminal/launcher/file-manager roles
- **Status bar architecture**: Waybar + waybar-hover-daemon for rich interactive status display
- **Mode switching**: toggle-waybar-mode allows runtime switching between hover implementations

## When NOT to use
- Skip for other Wayland compositors (Sway, river, etc.)
- Skip for X11 desktop environments
- Skip for non-Hyprland Waybar configurations
