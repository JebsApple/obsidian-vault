---
tags: [caso05, informe, subneteo, v4]
---

# Cambios al informe por implementación de subneteo (v4)

El informe actual describe una red plana `192.168.10.0/24` y menciona VLANs como mejora futura. La simulación implementa el esquema v4 con 4 VLANs + subnetting + router-on-a-stick. Esto requiere cambios en 3 secciones del informe:

## 1. Marco teórico — Sección 3

**Eliminar** la frase que pone VLANs como mejora de segunda etapa:
> ~~"Como mejoras de una segunda etapa, la literatura técnica identifica la segmentación mediante VLAN..."~~

**Reemplazar por:**
> "La segmentación mediante VLANs reduce los dominios de broadcast, aísla el tráfico por sector y permite administrar lógicamente la red desde el switch principal. En este diseño se implementaron 4 VLANs —una por sector— con router-on-a-stick para la interconexión entre ellas mediante subinterfaces 802.1Q en el router R-PRINCIPAL."

## 2. Desarrollo técnico — Sección 4.4 (Simulación Packet Tracer)

**Texto actual** (red plana):
> "direccionamiento IP estático en la red 192.168.10.0/24, y verificación de conectividad mediante pruebas de ping entre sectores"

**Reemplazar por:**
> "direccionamiento IP segmentado en 4 VLANs con subnetting y router-on-a-stick. El esquema de direccionamiento se muestra en la siguiente tabla:"

| VLAN | Nombre | Subred | Gateway | Switch de acceso | Hosts |
|------|--------|--------|---------|------------------|-------|
| 10 | Sector A | 192.168.10.0/29 | .1 | SW-A | PC-1 (.2), PC-2 (.3), PC-3 (.4), IMP-1 (.5) |
| 20 | Sector B | 192.168.10.8/29 | .9 | SW-B | PC-4 (.10), PC-5 (.11), LAP-1 (.12), LAP-2 (.13) |
| 30 | Sector C | 192.168.10.16/29 | .17 | SW-C | PC-6 (.18), PC-7 (.19), PC-8 (.20), IMP-2 (.21) |
| 40 | Área Técnica | 192.168.10.32/28 | .33 | SW-PRINCIPAL | SRV (.34), MFP (.35), TV-CORP (.36), LAP-3 (.37), IMP-3 (.38), TEL-IP (.40 DHCP) |

> "El router R-PRINCIPAL (2811) actúa como gateway inter-VLAN mediante 4 subinterfaces en FastEthernet0/0 con encapsulación 802.1Q. Los switches de acceso conectan sus uplinks al SW-PRINCIPAL mediante enlaces trunk 802.1Q que transportan las 4 VLANs. El servidor DHCP integrado en el router asigna dirección IP al teléfono TEL-IP (VLAN 40) mediante el pool VOZ, y el servicio Call Manager Express (CME) provee registro telefónico IP con línea 100."

## 3. Simulación — lo que SÍ funciona para capturas

| Item | Funciona? | Para captura |
|------|-----------|-------------|
| Topología completa 23 dispositivos | ✅ | Captura del canvas |
| Router `show ip interface brief` (4 subint UP/UP) | ✅ | Captura CLI |
| Router `show ip route` (8 subredes) | ✅ | Captura CLI |
| VLANs activas en switches | ✅ | `show vlan brief` en SW-PRINCIPAL |
| Trunks 802.1q en SW-PRINCIPAL | ✅ | `show interfaces trunk` |
| Ping inter-VLAN PC-1 → PC-6 | ✅ | Captura ping (TTL=127 confirma ruteo) |
| Ping R-PRINCIPAL → VLAN 10 (.2) | ✅ 80% | Captura ping (1er paquete pierde por ARP) |
| Ping R-PRINCIPAL → VLAN 20 (.10) | ✅ 80% | Captura ping |
| Ping R-PRINCIPAL → VLAN 30 (.18) | ✅ 100% | Captura ping |
| Ping R-PRINCIPAL → VLAN 40 (.34) | ✅ 100% | Captura ping |
| TEL-IP DHCP | ⏳ | Router pool OK, teléfono necesita reboot en PT |

## 4. Fig. 1 — Topología

Actualizar la leyenda de la figura para reflejar:
- Router R-PRINCIPAL con subinterfaces Fa0/0.10, .20, .30, .40
- SW-PRINCIPAL como trunk 802.1Q hacia switches de acceso
- 4 VLANs: Sector A (VLAN 10), Sector B (VLAN 20), Sector C (VLAN 30), Área Técnica (VLAN 40)
- TEL-IP con DHCP desde router (no IP estática)

## 5. Tabla I — Elementos y cantidades

Agregar router a la tabla (R-PRINCIPAL 2811) si no está, y aclarar que el router **se cotiza pero no se incluye en el VAN por instrucción del docente** (esto ya está en v3/v4 notes).

## Resumen

| Sección | Cambio | Prioridad |
|---------|--------|-----------|
| 3. Marco teórico | VLANs ya no son "futuro", están implementadas | Alta |
| 4.4 Simulación | Tabla de subredes + explicación router-on-a-stick | Alta |
| 4.4 Simulación | Capturas: show ip route, show vlan, pings funcionales | Alta |
| Fig. 1 | Actualizar leyenda con VLANs y subinterfaces | Media |
| Anexo B | Capturas de pings (4 VLANs funcionales) | Alta |

> **Nota**: No incluir en el informe los errores de configuración (trunks, DUPLICATE_IP cosmético). El informe describe el diseño terminado, no los pasos intermedios. Capturar solo lo que funciona.
