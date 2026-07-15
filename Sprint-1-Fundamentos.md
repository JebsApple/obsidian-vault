---
tags:
  - project/caelestia-rice
  - sprint
status: active
sprint: 1
date: 2025-07-14
---

# Sprint 1 — Fundamentos & Hardware Fixes

**Objetivo:** Fix input issues + base setup

## Tasks

- [x] Fix touchpad scroll fluidity (scroll_factor 0.3 → 1.0)
- [x] Fix keyboard layout (latam primary, us secondary)
- [x] Copilot button → keyboard layout toggle (XF86Assistant)
- [x] Set up Obsidian project structure
- [x] Create GitHub repo

## Notas

- hypr-user.lua: `natural_scroll = false`, scroll_factor = 1.0
- input.lua: `kb_layout = "latam,us"`, `kb_options = ""`
- Copilot key: XF86Assistant (keycode 201)
- Menu key: also mapped to layout switch

## Done
