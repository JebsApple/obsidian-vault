---
name: "Zettelkasten Snippets"
description: "Use when working with CachyOS, self-hosted apps, or Linux performance tuning. Triggers: CachyOS, Vaultwarden, Immich, RustDesk, Audiobookshelf, Podman, Ananicy, SCX, ChwD. Skip if unrelated to self-hosted services or Arch-based distros."
user-invocable: false
---

# Zettelkasten Snippets

## Domain
Research notes on CachyOS Linux (performance kernels, schedulers, hardware detection) and curated self-hosted applications. Covers distro optimization and the self-hosted software ecosystem.

## Core Concepts
- **CachyOS**: Arch-based distro tuned for performance with custom kernels and schedulers
- **EEVDF/BORE schedulers**: Linux kernel schedulers optimized for interactive workloads
- **Ananicy-Cpp**: Auto-nice daemon for process priority management
- **SCX sched-ext**: BPF-based extensible scheduler framework
- **ChwD**: CachyOS Hardware Detection tool for auto-configuring drivers
- **Vaultwarden**: Self-hosted Bitwarden-compatible password manager
- **Immich**: Self-hosted photo/video backup (Google Photos alternative)
- **RustDesk**: Self-hosted remote desktop (TeamViewer alternative)
- **Audiobookshelf**: Self-hosted audiobook/podcast server
- **Podman**: Daemonless container engine (Docker alternative, rootless by default)

## Key Relationships
- CachyOS → ships with → EEVDF and BORE kernel variants
- CachyOS → uses → ChwD for hardware auto-detection
- Ananicy-Cpp / SCX → provide → process scheduling control
- Vaultwarden / Immich / RustDesk / Audiobookshelf → run on → Podman containers
- Podman → enables → rootless self-hosted deployment

## Mental Models
- **Performance kernel choice**: EEVDF for fairness, BORE for interactive boost; LTS variant for stability
- **Self-hosted stack**: Container-based deployment (Podman) for all services; no Docker daemon dependency
- **Hardware detection first**: Run ChwD before manual driver configuration on CachyOS

## When NOT to use
- Skip for Ubuntu/Debian-based systems (CachyOS is Arch-specific)
- Skip for cloud-native deployments (these are on-prem/self-hosted tools)
- Skip for non-Linux platforms
