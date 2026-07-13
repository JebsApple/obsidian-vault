---
tags:
  - homelab
  - self-hosting
  - Referencia
created: 2026-07-12
---

# Homelab — Guía Completa

## Hardware mínimo

- 1 mini PC o laptop vieja (mejor que Raspberry Pi)
- Laptops viejas > RPi: más RAM upgradeable, pantalla/teclado incluidos, más potencia
- UPS para protección contra cortes

## Stack de servicios

| Servicio | Alternativa | Propósito |
|----------|-------------|-----------|
| Proxmox VE | — | Hypervisor, VMs y containers |
| Docker | Podman | Container runtime |
| Pi-hole / AdGuard | — | DNS con ad-blocking |
| Nextcloud | — | Files, calendar, contacts |
| Jellyfin | Plex | Media server (FOSS) |
| Home Assistant | — | Domótica |
| Traefik / Caddy | — | Reverse proxy con SSL automático |
| Uptime Kuma | — | Monitoring de servicios |

## Red

- VLANs para segmentar: IoT, trusted, guest
- Firewall real: OPNsense o pfSense
- DNS interno con Pi-hole/AdGuard

## Backup

- 3-2-1: 3 copias, 2 medios, 1 offsite
- Proxmox Backup Server para VMs
- `borgbackup` o `restic` para archivos
- Test restoration regularmente

## Old Laptops como servidores

1. Instalar Debian/Ubuntu Server (sin GUI)
2. Deshabilitar suspend/hibernate
3. Conectar por SSH
4. Instalar Docker
5. Deshabilitar servicios innecesarios (bluetooth, power management)
6. Usar `tlp` solo para limitar carga de batería si aplica

```bash
# Prevenir suspend
sudo systemctl mask sleep.target suspend.target hibernate.target
```

## Raspberry Pi

- Raspberry Pi 5 (2024) es viable como servidor ligero
- Pi-hole, WireGuard, surveillance cameras
- SD card = punto de fallo → usar USB boot con SSD
- Cooler obligatorio bajo carga
