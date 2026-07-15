---
name: "Config & Code Snippets"
description: "Use when debugging Go/PostgreSQL issues, Hyprland 0.55+ Lua config quirks, GTK3 scaling, nginx proxying, or auth guard patterns. Triggers: Go Scan NULL, Hyprland config Lua, GDK_SCALE, bcrypt migration, nginx proxy, auth guard, sidebar dedup. Skip if working on pure CSS/layout or CI/CD pipelines."
user-invocable: false
---

# Config & Code Snippets

## Domain
Hard-won lessons and bite-sized code patterns from real debugging sessions. Covers Go backend bugs, Hyprland 0.55+ Lua migration quirks, GTK3 scaling, nginx config, Vue auth guards, and tooling pitfalls. The "I learned this the hard way" collection.

## Core Concepts
- **Hyprland 0.55+ Lua Migration**: Config is now `hyprland.lua`, not `.conf`. Dispatchers interpret args as Lua expressions. GtkLayerShell is the correct way to float GTK windows. NEVER launch/kill hyprlock in a live session for testing.
- **GTK3 Fractional Scaling**: Export `GDK_SCALE=1` when running GTK3 apps under Hyprland fractional scaling — the toolkit doesn't handle it natively.
- **Go + PostgreSQL NULL Handling**: `Scan()` fails on NULL columns. Use `COALESCE` in SQL or `sql.Null*` types in Go.
- **Auth Guard Pattern**: Router `meta.requiresAuth` → guard checks JWT. Login with plaintext passwords must migrate to bcrypt.
- **nginx Proxy Setup**: Symlink in `sites-enabled` to activate; proxy `/uploads/` to backend for images.
- **UI Deduplication**: SideBar and NavBar must not duplicate navigation logic.
- **PipeWire Virtual Mic**: Permanent loopback for audio routing without physical mic.
- **opencode-sandbox**: Test MCP configs without breaking production opencode.json.

## Key Relationships
- Hyprland config Lua → references → GtkLayerShell → references → GDK_SCALE fix (config chain for GTK on Wayland)
- Go Scan NULL → references → nginx proxy → references → schema mismatch (backend data flow pitfalls)
- Auth guard → conceptually_related_to → bcrypt migration (security hardening progression)
- Lecciones generales MiNegocio MOC → references → most nodes (the central hub for lessons learned)
- opencode-sandbox → references → WhatsApp MCP crash (sandbox prevents config corruption)

## Mental Models
- **"Config migration breaks everything"**: When a tool major-bumps (Hyprland 0.55), assume ALL assumptions about config format are wrong. Read changelog first.
- **"NULL is not a value, it's the absence of one"**: In Go+PostgreSQL, every nullable column needs explicit handling — the driver won't guess.
- **"Proxy the proxy"**: nginx must proxy static assets too, not just API routes — images, uploads, everything the backend serves.

## When NOT to use
- Skip for MiNegocio UI component work (community 12)
- Skip for comic translation tool (community 13)
- Skip for full Hyprland desktop architecture (community 14 has the big picture)
