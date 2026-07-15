---
name: "Networking Lab PT"
description: "Use when building or referencing Cisco Packet Tracer lab exercises, network topologies, or VoIP configs. Triggers: Packet Tracer, Caso 05, router CLI, switch config, VoIP CME, network topology. Skip if unrelated to networking or PT labs."
user-invocable: false
---

# Networking Lab PT

## Domain
Step-by-step Cisco Packet Tracer lab exercise (Caso 05): building a flat network from scratch — devices, cabling, router/switch CLI config, IP assignment, VoIP home setup, verification, and screenshot documentation.

## Core Concepts
- **Topology (Paso 1)**: Place devices on canvas. Foundation for all subsequent steps.
- **Cableado (Paso 2)**: Physical connections between devices. Must match topology plan.
- **Router CLI (Paso 3)**: R-PRINCIPAL configuration via CLI — interfaces, routing, hostname.
- **Switches CLI (Paso 4)**: Switch configuration — VLANs, port security if needed.
- **Terminales IP (Paso 5)**: Assign IPs to end devices. Depends on router/switch being configured first.
- **VoIP Phone (Paso 6)**: Home VoIP setup with Cisco Call Manager Express (CME). Last config step.
- **Verificación (Paso 7)**: Connectivity tests — ping, call test. Validates all prior steps.
- **Capturas (Paso 8)**: Screenshots for the lab report/informe.

## Key Relationships
- Índice → references → all 8 Pasos (master table of contents)
- Topology → references → Cableado (devices must exist before cabling)
- Cableado → references → Router CLI (cables in place before CLI config)
- Instrucciones desde cero → semantically_similar_to → Índice (alternative complete walkthrough)
- Nota pendiente → conceptually_related_to → Índice (pending items tracked alongside main guide)
- Reporte Lab Switch → standalone walkthrough of SW-LAB-01 config

## Mental Models
- **Sequential dependency**: Each Paso depends on the previous. Skip Paso 2 → Paso 3 won't work. Build linearly.
- **Configure bottom-up**: Physical → Data Link → Network. Cables first, then CLI, then IPs, then apps (VoIP).
- **Verify after each layer**: Ping after IP assignment. Call test after VoIP. Don't stack unverified changes.

## When NOT to use
- Skip for non-Cisco networking (Juniper, Mikrotik have different CLI).
- Skip for production network design (this is a learning lab environment).
- Skip for software-only projects without networking components.
