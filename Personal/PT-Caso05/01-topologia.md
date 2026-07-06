---
tags: [caso05, packet-tracer, topologia]
---

# Paso 1: Topología — Agregar dispositivos

Agregar los 23 dispositivos al canvas de Packet Tracer.

## Cómo agregar

1. Abrir PT → **New** (o partir del .pkt existente)
2. En la barra inferior, seleccionar cada categoría y arrastrar al canvas
3. Renombrar cada dispositivo (click → **Config** → **Display Name**)

## Lista de dispositivos

| Dispositivo | Modelo | Categoría en PT | Cantidad |
|-------------|--------|-----------------|----------|
| SW-PRINCIPAL | 2960-24TT | Switches → 2960-24TT | 1 |
| SW-A | 2960-24TT | Switches → 2960-24TT | 1 |
| SW-B | 2960-24TT | Switches → 2960-24TT | 1 |
| SW-C | 2960-24TT | Switches → 2960-24TT | 1 |
| R-PRINCIPAL | 2811 | Routers → 2811 | 1 |
| PC-1 a PC-8 | PC-PT | End Devices → PC-PT | 8 |
| LAP-1, LAP-2, LAP-3 | Laptop-PT | End Devices → Laptop-PT | 3 |
| IMP-1, IMP-2, IMP-3 | Printer-PT | End Devices → Printer-PT | 3 |
| MFP | Printer-PT | End Devices → Printer-PT | 1 |
| SRV | Server-PT | End Devices → Server-PT | 1 |
| TV-CORP | PC-PT | End Devices → PC-PT | 1 |
| TEL-IP | Home VoIP-PT | End Devices → Home VoIP-PT (NO 7960) | 1 |

> ⚠️ **No usar IP Phone 7960**. No tiene Desktop tab y no se puede configurar. Usar **Home VoIP-PT** que sí tiene Desktop → CIPC.

## Distribución en el canvas (sugerida)

```
          [R-PRINCIPAL]
               |
          [SW-PRINCIPAL]
         /     |      \
    [SW-A]  [SW-B]  [SW-C]    [Área Técnica: SRV, MFP, LAP-3, IMP-3, TV-CORP, TEL-IP]
     |        |       |
  PC-1..4  PC-4..5  PC-6..8
  IMP-1    LAP-1-2  IMP-2
```

Ubicar SW-PRINCIPAL en el centro. Switches de acceso debajo. Área técnica a la derecha. Router arriba.
