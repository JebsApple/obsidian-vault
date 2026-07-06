---
tags: [audit, caso05, packet-tracer, informe]
---

# Auditoría Caso05 — Estado real de la simulación (julio 2026)

> **Propósito:** Documentar la configuración REAL aplicada en el .pkt para que el compañero encargado del informe actualice las secciones de red plana (v3, obsoleta) por la configuración con subneteo y VLANs (v4).

---

## Topología implementada

**23 dispositivos** en Packet Tracer 9.0:

| Dispositivo | Modelo | Rol |
|---|---|---|
| R-PRINCIPAL | 2811 | Router-on-a-stick, DHCP, CME |
| SW-PRINCIPAL | 2960-24TT | Switch core |
| SW-A | 2960-24TT | Switch acceso — Sector A |
| SW-B | 2960-24TT | Switch acceso — Sector B |
| SW-C | 2960-24TT | Switch acceso — Sector C |
| PC-1 a PC-8 | PC-PT | Estaciones de trabajo |
| LAP-1, LAP-2, LAP-3 | Laptop-PT | Laptops |
| IMP-1, IMP-2, IMP-3, MFP | Printer-PT | Impresoras |
| SRV | Server-PT | Servidor |
| TEL-IP | 7960 | Teléfono IP |
| TV-CORP | PC-PT | TV corporativa |

---

## Esquema de direccionamiento (subneteo + VLANs)

| VLAN | Nombre | Subred | Máscara | Gateway | Hosts disponibles |
|---|---|---|---|---|---|
| 10 | SECTOR-A | 192.168.10.0/29 | 255.255.255.248 | 192.168.10.1 | .2 a .6 |
| 20 | SECTOR-B | 192.168.10.8/29 | 255.255.255.248 | 192.168.10.9 | .10 a .14 |
| 30 | SECTOR-C | 192.168.10.16/29 | 255.255.255.248 | 192.168.10.17 | .18 a .22 |
| 40 | AREA-TECNICA | 192.168.10.32/28 | 255.255.255.240 | 192.168.10.33 | .34 a .46 |

### Asignación de IPs por dispositivo

| Dispositivo | IP | VLAN | Método |
|---|---|---|---|
| R-PRINCIPAL Fa0/0.10 | 192.168.10.1/29 | 10 | Manual |
| R-PRINCIPAL Fa0/0.20 | 192.168.10.9/29 | 20 | Manual |
| R-PRINCIPAL Fa0/0.30 | 192.168.10.17/29 | 30 | Manual |
| R-PRINCIPAL Fa0/0.40 | 192.168.10.33/28 | 40 | Manual |
| PC-1 | 192.168.10.2/29 | 10 | Manual |
| PC-2 | 192.168.10.3/29 | 10 | Manual |
| PC-3 | 192.168.10.4/29 | 10 | Manual |
| IMP-1 | 192.168.10.5/29 | 10 | Manual |
| PC-4 | 192.168.10.10/29 | 20 | Manual |
| PC-5 | 192.168.10.11/29 | 20 | Manual |
| LAP-1 | 192.168.10.12/29 | 20 | Manual |
| LAP-2 | 192.168.10.13/29 | 20 | Manual |
| PC-6 | 192.168.10.18/29 | 30 | Manual |
| PC-7 | 192.168.10.19/29 | 30 | Manual |
| PC-8 | 192.168.10.20/29 | 30 | Manual |
| IMP-2 | 192.168.10.21/29 | 30 | Manual |
| SRV | 192.168.10.34/28 | 40 | Manual |
| MFP | 192.168.10.35/28 | 40 | Manual |
| TV-CORP | 192.168.10.36/28 | 40 | Manual |
| LAP-3 | 192.168.10.37/28 | 40 | Manual |
| IMP-3 | 192.168.10.38/28 | 40 | Manual |
| TEL-IP | 192.168.10.40/28 | 40 | DHCP del router |
| SW-PRINCIPAL (SVI Vlan40) | 192.168.10.46/28 | 40 | Manual |

---

## Estado de configuración por dispositivo

### R-PRINCIPAL (Router 2811) — ✅ CONFIGURADO

**Subinterfaces** (router-on-a-stick):
| Interfaz | VLAN | IP | Estado |
|---|---|---|---|
| Fa0/0.10 | 10 | 192.168.10.1/29 | up/up |
| Fa0/0.20 | 20 | 192.168.10.9/29 | up/up |
| Fa0/0.30 | 30 | 192.168.10.17/29 | up/up |
| Fa0/0.40 | 40 | 192.168.10.33/28 | up/up |

**DHCP** — Pool `VOZ`:
- Red: 192.168.10.32/28
- Default-router: 192.168.10.33
- Option 150: 192.168.10.33 (CME)
- Exclusiones: .33-.39 y .41-.46 (solo la .40 disponible para TEL-IP)

**CME (Call Manager Express)**:
- max-ephones 1, max-dn 1
- ip source-address 192.168.10.33 port 2000
- auto assign 1 to 1
- ephone-dn 1: number 100

### SW-PRINCIPAL (Switch core 2960-24TT) — ✅ CONFIGURADO

**VLANs creadas:**
- VLAN 10 — SECTOR-A (activa)
- VLAN 20 — SECTOR-B (activa)
- VLAN 30 — SECTOR-C (activa)
- VLAN 40 — AREA-TECNICA (activa)

**Puertos de acceso:**
- Fa0/1 a Fa0/6 → VLAN 40 (Área técnica: SRV, MFP, TEL-IP, LAP-3, IMP-3, TV-CORP)

**Puertos troncales (trunk 802.1q):**
- Fa0/7 → R-PRINCIPAL (router)
- Fa0/24 → SW-A Gig0/1
- Gig0/1 → SW-C Gig0/1
- Gig0/2 → SW-B Gig0/1

**SVI (Switch Virtual Interface):**
- Vlan40: 192.168.10.46/28 — gestión

### SW-A, SW-B, SW-C (Switches acceso) — ⚠️ VERIFICACIÓN PENDIENTE

Estos switches están en modo usuario (`>`), requieren acceso enable/configuración para verificar:
- Deberían tener sus puertos Fa0/1-4 en access VLAN correspondiente
- Deberían tener Gig0/1 como trunk
- VLANs deberían estar creadas
- SVI deberían tener IP de gestión en su VLAN propia

> **Nota:** Los accesos de PC-1..PC-4 en SW-A, LAP-1/2 + PC-4/5 en SW-B, PC-6..8 + IMP-2 en SW-C deberían funcionar si la configuración inicial se aplicó correctamente. La topología CDP los muestra conectados.

---

## Servicios implementados

| Servicio | Dispositivo | Detalle |
|---|---|---|
| Enrutamiento inter-VLAN | R-PRINCIPAL | Router-on-a-stick con 4 subinterfaces |
| DHCP | R-PRINCIPAL | Pool VOZ para TEL-IP |
| Telefonía IP (CME) | R-PRINCIPAL | Línea 100, TEL-IP 7960 |
| DNS | SRV | Opcional (192.168.10.34) |

---

## Diferencias clave vs. versión plana (v3)

> Lo que el informe actual describe como red plana DEBE cambiarse a lo siguiente:

| Aspecto | Red plana (v3) — INCORRECTO | Subneteo + VLANs (v4) — REAL |
|---|---|---|
| Segmentación | Una sola subred 192.168.10.0/24 | 4 subredes: /29 para sectores, /28 para área técnica |
| VLANs | Sin VLANs | VLANs 10, 20, 30, 40 |
| Router | Solo para DHCP/CME | Router-on-a-stick con subinterfaces |
| DHCP | En SRV | En R-PRINCIPAL |
| Enlaces switches | /30 redundantes (eliminados) | Trunks 802.1q nativos |
| IP de gestión switches | VLAN 1 (inalcanzable) | SVI en VLAN propia |
| Área técnica | IPs .24/28 (solapamiento) | 192.168.10.32/28 (válido) |
| TEL-IP | DHCP desde SRV | DHCP desde router + CME |

---

## Errores detectados (cosméticos)

1. **DUPLICATE_IP 0.0.0.0** — Múltiples interfaces sin IP (Bluetooth, Vlan1, Fa0/1). Es esperado y no afecta funcionalidad.
2. **TEL-IP no responde CLI** — El teléfono 7960 en PT solo acepta configuración por DHCP/CME, no por CLI. Es normal.

---

## Pruebas de verificación realizadas

| Prueba | Comando | Resultado |
|---|---|---|
| Subinterfaces | `show ip int brief` en R-PRINCIPAL | 4 subinterfaces up/up |
| VLANs | `show vlan brief` en SW-PRINCIPAL | VLANs 10/20/30/40 activas |
| DHCP | `show run \| sec dhcp` en R-PRINCIPAL | Pool VOZ configurado |
| CME | `show run \| sec telephony` en R-PRINCIPAL | CME con línea 100 |

---

## Pendientes (para el informe)

1. **Actualizar el diseño de red** en el informe: cambiar de red plana `/24` a esquema con 4 subredes y VLANs
2. **Incluir tabla de direccionamiento IP** con las 4 subredes
3. **Agregar diagrama de topología lógica** mostrando router-on-a-stick + VLANs
4. **Describir el servicio DHCP** en el router (no en SRV)
5. **Describir CME** para telefonía IP
6. **Verificar y capturar** conectividad:
   - Ping intra-VLAN (ej: PC-1 → IMP-1, misma VLAN 10)
   - Ping inter-VLAN (ej: PC-1 → PC-4, VLAN 10 → 20)
   - Ping a servidor (PC-1 → SRV 192.168.10.34)
   - TEL-IP registrado con línea 100
7. **Agregar justificación** del cambio de red plana a subnetting (coherente con la materia del curso)
8. **Ejecutar pruebas de ping** en cada PC desde PT y capturar pantallazos como evidencia
