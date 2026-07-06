---
tags: [caso05, packet-tracer, guia]
---

# PT Caso 05 — Instructivo paso a paso

Basado en el PDF del profesor "Trabajo de Investigación Técnico-Económico". Refleja todo lo aprendido durante la implementación.

## Principios rectores

- **Red plana** `192.168.10.0/24` — sin VLANs, sin subnetting. El PDF menciona VLANs solo como mejora futura (sección 8, pregunta 10).
- **Router solo para teléfono** — DHCP + CME. Opcional según el diseño. Se incluye porque el IP Phone 7960 no acepta IP manual y necesita DHCP + Call Manager.
- **Foco en cableado estructurado** — el trabajo evalúa cotizaciones, VAN/TIR y cableado UTP Cat6, no configuraciones avanzadas de red.

## Pasos

| # | Paso | Descripción |
|---|------|-------------|
| 01 | [Topología](01-topologia.md) | Agregar todos los dispositivos al canvas |
| 02 | [Cableado](02-cableado.md) | Conectar físicamente los dispositivos |
| 03 | [Router](03-router.md) | Configurar CLI del R-PRINCIPAL |
| 04 | [Switches](04-switches.md) | Configurar CLI de los switches |
| 05 | [Terminales](05-terminales.md) | Asignar IPs estáticas + DHCP |
| 06 | [Teléfono](06-telefono.md) | Home VoIP + CME + registro |
| 07 | [Verificación](07-verificacion.md) | Comprobar conectividad |
| 08 | [Capturas](08-capturas.md) | Screenshots para el informe |
| 09 | [Tutoriales](09-tutoriales.md) | Videos y tutoriales de referencia |

## Lecciones aprendidas (no repetir errores)

1. **No usar MCP para configurar** — el bridge es frágil, los schemas cambian, los timeouts cortan. Hacer CLI directa en PT.
2. **TEL-IP 7960 no sirve** — no tiene Desktop tab. Reemplazar por Home VoIP-PT siempre.
3. **Home VoIP usa puerto "Ethernet"** — no "FastEthernet0". pt_set_pc con "FastEthernet0" falla.
4. **PC-PT no tiene CLI Cisco** — usan `ipconfig` en Desktop → Command Prompt.
5. **Switch necesita `enable` primero** — arranca en modo usuario `>`.
6. **Red plana = sin trunks, sin SVIs** — todos los puertos en access vlan 1 (default).
7. **DHCP excluded-range crítico** — no excluir la IP que va a tomar el teléfono.
8. **CME necesita `ip source-address`** — el teléfono busca el TFTP en esa IP.
