---
name: "Self-Hosted Media & VPN Tools"
description: "Use when setting up self-hosted manga/comic servers or VPN/tunneling for remote access. Triggers: manga server, comic reader, Tailscale, Headscale, VPN self-hosted, reverse proxy. Skip if unrelated to self-hosted media or network tunneling."
user-invocable: false
---

# Self-Hosted Media & VPN Tools

## Domain
Self-hosted manga/comic reading servers and VPN/tunneling tools for secure remote access to homelab services.

## Core Concepts
- **Komga**: Open-source media server for manga/comic reading with web UI
- **Kavita**: Fast, feature-rich manga/comic server with OPDS support
- **Suwayomi Server**: Server that reads manga directly from extensions (Mihon-compatible)
- **Mihon**: Android manga reader whose extensions work with Suwayomi server
- **Tailscale**: Mesh VPN using WireGuard for secure device-to-device connectivity
- **Headscale**: Self-hosted open-source alternative to Tailscale control server
- **Tailscale Funnel**: Exposes local services to the public internet via Tailscale
- **Pangolin**: Reverse proxy/tunneling alternative to Tailscale Funnel
- **NetBird**: Self-hosted peer-to-peer VPN, alternative to Tailscale

## Key Relationships
- NetBird → selfhosted_peer → Pangolin (similar tunneling approach)
- NetBird → alternatives → Tailscale (competing VPN solutions)
- Tailscale → open_source_alternative → Headscale (self-hosted control plane)
- Tailscale → provides → Tailscale Funnel (public exposure feature)
- Pangolin → alternatives → Tailscale Funnel (competing tunnel products)
- Suwayomi → compatible_extensions → Mihon (shares extension ecosystem)
- Suwayomi → alternatives → Kavita, Komga (competing manga servers)
- Suwayomi → connectivity_solution → Tailscale (remote access)

## Mental Models
- **VPN choice**: Tailscale (managed) vs Headscale (self-hosted control) vs NetBird (full self-host)
- **Manga server choice**: Komga/Kavita (file-based) vs Suwayomi (extension-based, Mihon-compatible)
- **Tunneling**: Tailscale Funnel vs Pangolin for public exposure of homelab services

## When NOT to use
- Skip for cloud-hosted SaaS solutions (not self-hosted context)
- Skip for video/media streaming (this is manga/comic-specific)
- Skip for general networking without VPN/tunneling component
