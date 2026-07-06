---
tags: [caso05, packet-tracer, ips, terminales]
---

# Paso 5: Terminales — Asignar IPs

Asignar IP estática a cada equipo. En red plana, todos usan gateway `192.168.10.1` y máscara `255.255.255.0`.

## PCs

Cada PC-PT: click → **Desktop** → **IP Configuration**:

| PC | IP | Mask | Gateway |
|----|-----|------|---------|
| PC-1 | 192.168.10.2 | 255.255.255.0 | 192.168.10.1 |
| PC-2 | 192.168.10.3 | 255.255.255.0 | 192.168.10.1 |
| PC-3 | 192.168.10.4 | 255.255.255.0 | 192.168.10.1 |
| PC-4 | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 |
| PC-5 | 192.168.10.11 | 255.255.255.0 | 192.168.10.1 |
| PC-6 | 192.168.10.18 | 255.255.255.0 | 192.168.10.1 |
| PC-7 | 192.168.10.19 | 255.255.255.0 | 192.168.10.1 |
| PC-8 | 192.168.10.20 | 255.255.255.0 | 192.168.10.1 |

## Laptops

Mismo procedimiento: click → **Desktop** → **IP Configuration**:

| Laptop | IP | Mask | Gateway |
|--------|-----|------|---------|
| LAP-1 | 192.168.10.12 | 255.255.255.0 | 192.168.10.1 |
| LAP-2 | 192.168.10.13 | 255.255.255.0 | 192.168.10.1 |
| LAP-3 | 192.168.10.37 | 255.255.255.0 | 192.168.10.1 |

## Impresoras

| Impresora | IP | Mask | Gateway |
|-----------|-----|------|---------|
| IMP-1 | 192.168.10.5 | 255.255.255.0 | 192.168.10.1 |
| IMP-2 | 192.168.10.21 | 255.255.255.0 | 192.168.10.1 |
| IMP-3 | 192.168.10.38 | 255.255.255.0 | 192.168.10.1 |
| MFP | 192.168.10.35 | 255.255.255.0 | 192.168.10.1 |

## Server y TV

| Dispositivo | IP | Mask | Gateway |
|-------------|-----|------|---------|
| SRV | 192.168.10.34 | 255.255.255.0 | 192.168.10.1 |
| TV-CORP | 192.168.10.36 | 255.255.255.0 | 192.168.10.1 |

## TEL-IP (Home VoIP)

El teléfono obtiene IP por DHCP. No asignar manual:

1. Click en **Home VoIP0** → **Desktop** → **IP Configuration**
2. Seleccionar **DHCP**
3. La IP debe aparecer como `192.168.10.39` (la única disponible en el pool)

> Si no aparece, verificar que el router tenga el pool DHCP configurado y que la interfaz Fa0/0 esté `no shutdown`.

## Verificar IPs

En cualquier PC/Laptop: **Desktop** → **Command Prompt** → `ipconfig`

```
PC-1> ipconfig
IP Address: 192.168.10.2
Subnet Mask: 255.255.255.0
Default Gateway: 192.168.10.1
```
