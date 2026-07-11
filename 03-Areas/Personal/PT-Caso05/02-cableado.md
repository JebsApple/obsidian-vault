---
tags: [caso05, packet-tracer, cableado]
---

# Paso 2: Cableado — Conexiones físicas

Conectar todos los dispositivos. Usar cable **Straight** (cobre directo) para todas las conexiones (no hay conexiones seriales ni cross en este diseño).

## Uplinks de switches de acceso a SW-PRINCIPAL

| Desde | Puerto | → | Hacia | Puerto | Cable |
|-------|--------|---|------|--------|-------|
| SW-PRINCIPAL | FastEthernet0/24 | → | SW-A | GigabitEthernet0/1 | Straight |
| SW-PRINCIPAL | GigabitEthernet0/2 | → | SW-B | GigabitEthernet0/1 | Straight |
| SW-PRINCIPAL | GigabitEthernet0/1 | → | SW-C | GigabitEthernet0/1 | Straight |

## Router a SW-PRINCIPAL

| Desde | Puerto | → | Hacia | Puerto | Cable |
|-------|--------|---|------|--------|-------|
| R-PRINCIPAL | FastEthernet0/0 | → | SW-PRINCIPAL | FastEthernet0/7 | Straight |

## Área técnica (conectada directo a SW-PRINCIPAL)

| Puerto SW-PRINCIPAL | Dispositivo |
|---------------------|-------------|
| Fa0/1 | SRV |
| Fa0/2 | MFP |
| Fa0/3 | TEL-IP (Home VoIP-PT) |
| Fa0/4 | LAP-3 |
| Fa0/5 | IMP-3 |
| Fa0/6 | TV-CORP |

## Sector A (conectado a SW-A)

| Puerto SW-A | Dispositivo |
|-------------|-------------|
| Fa0/1 | PC-1 |
| Fa0/2 | PC-2 |
| Fa0/3 | PC-3 |
| Fa0/4 | IMP-1 |

## Sector B (conectado a SW-B)

| Puerto SW-B | Dispositivo |
|-------------|-------------|
| Fa0/1 | PC-4 |
| Fa0/2 | PC-5 |
| Fa0/3 | LAP-1 |
| Fa0/4 | LAP-2 |

## Sector C (conectado a SW-C)

| Puerto SW-C | Dispositivo |
|-------------|-------------|
| Fa0/1 | PC-6 |
| Fa0/2 | PC-7 |
| Fa0/3 | PC-8 |
| Fa0/4 | IMP-2 |

## Verificar conexiones

Pasar el mouse sobre cada cable. PT debe mostrar **[green link up]**. Si aparece rojo (link down), el dispositivo o puerto no existe o está mal escrito.
