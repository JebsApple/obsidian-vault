---
name: "Vault Sync Strategies"
description: "Use when syncing Obsidian vaults across devices or setting up Mihon/Suwayomi. Triggers: vault sync, Syncthing, Tailscale, obsidian-sync timer, vault-sync script. Skip for single-device vault setups or unrelated sync tools."
user-invocable: false
---

# Vault Sync Strategies

## Domain
Multi-device synchronization strategies for Obsidian vaults and manga reader (Mihon/Suwayomi) using Git, Syncthing, Tailscale, and systemd timers.

## Core Concepts
- **Plugin Obsidian Git**: Auto-commit every 10min, auto-push every 30min — cloud backup layer
- **systemd timer obsidian-sync.timer**: Syncs vault even when Obsidian is closed (every 30min)
- **vault-sync / vsync script**: Manual sync trigger for on-demand pushes
- **Syncthing**: Peer-to-peer real-time sync, no central server, ideal for LAN
- **Tailscale**: WireGuard-based VPN connecting machines outside LAN
- **MCP servers remotos vía Tailscale**: Centralize MCP servers on one machine, access via HTTP/SSE from clients
- **Mihon ↔ Suwayomi**: Manga reader sync — Suwayomi as server, Mihon as client via extension (implicit tracker, no SyncYomi needed)
- **Syncthing bidireccional**: PC ↔ celular notes sync via Tailscale IP (avoids public relays)

## Key Relationships
- Obsidian Git → provides → cloud backup (GitHub)
- systemd timer + vault-sync script → provide → local Git sync independent of Obsidian running
- Syncthing → provides → real-time P2P file sync (complements Git's snapshot model)
- Tailscale → enables → Syncthing + MCP access across networks (not just LAN)
- Mihon → syncs with → Suwayomi server via Tailscale connection

## Mental Models
- **Layered sync**: Git for version history + Syncthing for real-time + Tailscale for reach
- **Server-centric manga**: Suwayomi runs on always-on machine; Mihon is just a client
- **LAN-first, Tailscale fallback**: Syncthing works great on LAN; Tailscale adds WAN without port forwarding

## When NOT to use
- Skip for single-device vault setups (no sync needed)
- Skip for general Syncthing/Tailscale tutorials (only vault-specific patterns)
- Skip for unrelated manga tools (Anilist, etc.)
