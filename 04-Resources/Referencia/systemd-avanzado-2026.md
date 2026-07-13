---
tags:
  - linux/systemd
  - services
  - timers
  - Referencia
created: 2026-07-12
---

# systemd Avanzado 2026

## Estructura de Unit Files

```
/etc/systemd/system/          # Custom units
/usr/lib/systemd/system/      # Vendor units (NUNCA editar)
~/.config/systemd/user/       # User services
```

## Overrides (drop-ins)

```bash
systemctl edit myservice
# Crea /etc/systemd/system/myservice.d/override.conf
# O: systemctl edit --full myservice  (edita unit completa)
```

## Timers > Cron

```ini
# backup.timer
[Unit]
Description=Daily backup

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
```

```ini
# backup.service
[Unit]
Description=Run backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

```bash
systemctl enable --now backup.timer
systemctl list-timers --all
```

### OnCalendar format

| Expresión | Significado |
|-----------|-------------|
| `*-*-* 02:00` | Diario a las 2am |
| `Mon *-*-* 09:00` | Lunes 9am |
| `*-*-01 00:00` | Primer día del mes |
| `*-*-* *:00/15` | Cada 15 minutos |

## Security

```bash
systemd-analyze security myservice
# Score de 0-9.6 (menor = más seguro)
# 60+ checks de exposición
```

```ini
# Hardened service
[Service]
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
NoNewPrivileges=true
ReadWritePaths=/var/lib/myapp
CapabilityBoundingSet=
SystemCallFilter=@system-service
```

## Resource Control (cgroups v2)

```ini
[Service]
MemoryMax=512M
MemoryHigh=256M
CPUQuota=50%
TasksMax=256
```

## Socket Activation

```ini
# myapp.socket
[Socket]
ListenStream=8080

[Install]
WantedBy=sockets.target
```

systemd abre el socket, systemd lo pasa al servicio cuando llega request. Lazy loading real.

## Debug

```bash
systemd-analyze blame          # Qué tarda en boot
systemd-analyze critical-chain # Chain de dependencias
systemd-analyze plot > boot.svg # Visual
journalctl -u myservice -f     # Logs live
journalctl --since "1 hour ago"
```

## Regla

SIEMPRE usar overrides. NUNCA editar vendor unit files.
