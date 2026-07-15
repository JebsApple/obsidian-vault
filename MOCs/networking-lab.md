---
tags:
  - moc
  - networking
created: 2026-07-14
aliases: [MOC Networking Lab]
---

# Networking Lab

> Laboratorios de redes Cisco Packet Tracer: Caso 05 (red plana + VoIP CME), MCP bridge de Packet Tracer y skill de dominio.

## Caso 05 — PT (guía paso a paso)
- [[00-indice|Índice PT Caso 05]]
- [[01-topologia|01 Topología]]
- [[02-cableado|02 Cableado]]
- [[03-router|03 Router CLI]]
- [[04-switches|04 Switches CLI]]
- [[05-terminales|05 Terminales IP]]
- [[06-telefono|06 Teléfono VoIP/CME]]
- [[07-verificacion|07 Verificación]]
- [[08-capturas|08 Capturas]]
- [[09-tutoriales|09 Tutoriales]]
- [[comandos-verificacion-caso05|Comandos de verificación]]
- [[Instrucciones-PT-Caso05-desde-cero|Walkthrough completo desde cero]]

## Tooling
- [[mcp-packet-tracer|MCP Packet Tracer]] — bridge frágil: preferir CLI directa en PT (lección 1 del índice)

## Related Skills
- [[18-networking-lab-pt|Skill: Networking Lab PT]]

## Lecciones clave (resumen)
- CLI directa en PT, no MCP para configurar
- Home VoIP-PT en vez de TEL-IP 7960; puerto "Ethernet"
- Red plana = sin trunks/SVIs; DHCP excluded-range no debe pisar la IP del teléfono
- CME necesita `ip source-address`

## Status
- [ ] Review completeness
- [ ] Add missing edges
