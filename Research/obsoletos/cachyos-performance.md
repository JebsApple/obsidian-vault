---
tags: [research, linux, performance, cachyos]
---

# CachyOS Performance Tips 2026

## Kernel variants (cachyos-kernel-manager)
- `linux-cachyos` — EEVDF scheduler (default, balanceado)
- `linux-cachyos-bore` — BORE scheduler (menor latencia, gaming)
- `linux-cachyos-lts` — Long-term support

## Repositorios optimizados
El diferencial real de CachyOS:
- `x86-64-v3` — 5-20% uplift vs genérico
- `x86-64-v4` — requiere AVX512 (Intel 12th gen NO, reporta pero no corre)
- `znver4` — Ryzen 7000+

Migrar entre repos: editar `/etc/pacman.conf` y cambiar `cachyos-v3` por `cachyos-v4` (si el CPU lo soporta).

## Herramientas nativas
- `game-performance %command%` — launch option de Steam para perfil performance
- **Ananicy-Cpp** — auto-nice de procesos en background (viene activo)
- **SCX (sched-ext)** — schedulers extensibles

## ChwD (CachyOS Hardware Detection)
Manejo automático de drivers gráficos:
```bash
sudo chwd -h -a nvidia  # cambiar a NVIDIA
sudo chwd -h -a amd     # cambiar a AMD
```

## Links
- https://wiki.cachyos.org
- https://discuss.cachyos.org
