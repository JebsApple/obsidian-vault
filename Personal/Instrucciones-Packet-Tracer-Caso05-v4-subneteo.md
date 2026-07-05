# Instrucciones Packet Tracer — Caso 05 — v4 (SUBNETEO + VLANs) ★ VERSIÓN VIGENTE

> Diseño definitivo: **4 VLANs con subneteo** y router-on-a-stick. Reemplaza a la v3 (red plana, descartada) y **corrige 4 errores de la versión con subredes que circulaba antes** — ver Registro de cambios al final.

---

## Plan de subredes CORREGIDO

| VLAN | Sector | Subred | Máscara | Gateway | Hosts |
|---|---|---|---|---|---|
| 10 | A (SW-A) | 192.168.10.0/29 | 255.255.255.248 | 192.168.10.1 | .2–.6 |
| 20 | B (SW-B) | 192.168.10.8/29 | 255.255.255.248 | 192.168.10.9 | .10–.14 |
| 30 | C (SW-C) | 192.168.10.16/29 | 255.255.255.248 | 192.168.10.17 | .18–.22 |
| 40 | Área técnica | **192.168.10.32/28** | 255.255.255.240 | **192.168.10.33** | .34–.46 |

> ⚠️ **Por qué cambió el área técnica:** `192.168.10.24/28` NO es una subred válida (los bloques /28 empiezan en múltiplos de 16: .0, .16, .32…). Con máscara /28, las IPs .25–.31 caían en el bloque `192.168.10.16/28`, que se **solapa con el Sector C** (`.16/29`) — el router rechaza la subinterfaz VLAN 40 con error `overlaps`. El área técnica se mueve al bloque válido `.32/28`. Los enlaces "/30" de la versión anterior se eliminan: los enlaces entre switches son trunks de capa 2, no llevan subred.

## Tabla de IPs por dispositivo

**Sectores A/B/C — SIN CAMBIOS** (lo que ya configuraste sigue válido):

| Sector A (gw .1) | | Sector B (gw .9) | | Sector C (gw .17) | |
|---|---|---|---|---|---|
| PC-1 | .2 | PC-4 | .10 | PC-6 | .18 |
| PC-2 | .3 | PC-5 | .11 | PC-7 | .19 |
| PC-3 | .4 | LAP-1 | .12 | PC-8 | .20 |
| IMP-1 | .5 | LAP-2 | .13 | IMP-2 | .21 |
| SW-A | .6 | SW-B | .14 | SW-C | .22 |

**Área técnica — RE-CONFIGURAR con las IPs nuevas** (máscara 255.255.255.240, gateway 192.168.10.33, DNS 192.168.10.34):

| Dispositivo | IP nueva | Dónde |
|---|---|---|
| SRV | 192.168.10.34 | Desktop → IP Configuration |
| MFP | 192.168.10.35 | Config → FastEthernet0 |
| TV-CORP | 192.168.10.36 | Desktop → IP Configuration |
| LAP-3 | 192.168.10.37 | Desktop → IP Configuration |
| IMP-3 | 192.168.10.38 | Config → FastEthernet0 |
| TEL-IP | 192.168.10.40 — **no se toca, la entrega el router por DHCP** | — |
| SW-PRINCIPAL | 192.168.10.46 | CLI (sección B) |

*(Opcional: en los equipos de los sectores A/B/C, actualizar el campo DNS de .26 a .34 — solo necesario para la prueba web por nombre.)*

---

## A. VLANs y trunks en los switches (si ya lo hiciste, solo verifica)

Igual que la versión anterior — esto estaba correcto:

- **SW-PRINCIPAL:** crear VLANs 10/20/30/40 · trunks en Gig0/1, Gig0/2, el puerto hacia SW-C y **Fa0/7 (hacia el router)** con `switchport trunk allowed vlan 10,20,30,40` · Fa0/1–0/6 en `switchport mode access` + `switchport access vlan 40`.
- **SW-A / SW-B / SW-C:** Fa0/1–0/4 en access VLAN 10 / 20 / 30 respectivamente · Gig0/1 en trunk.

Verificar con `show vlan brief` y `show interfaces trunk` en cada switch.

## B. IP de gestión de los switches — CORREGIDO (SVI en su propia VLAN)

> ⚠️ El error de la versión anterior: ponía la IP de gestión en `interface vlan 1`, pero los puertos están en VLAN 10/20/30/40 → la IP quedaba inalcanzable. La SVI debe estar en la VLAN del switch.

**SW-A** (repetir análogo en B y C):

```
enable
configure terminal
interface vlan 1
 no ip address
 shutdown
exit
interface vlan 10
 ip address 192.168.10.6 255.255.255.248
 no shutdown
exit
ip default-gateway 192.168.10.1
end
copy running-config startup-config
```

- SW-B → `interface vlan 20`, IP `192.168.10.14`, gateway `192.168.10.9`
- SW-C → `interface vlan 30`, IP `192.168.10.22`, gateway `192.168.10.17`
- SW-PRINCIPAL → `interface vlan 40`, IP `192.168.10.46 255.255.255.240`, gateway `192.168.10.33`

## C. Router R-PRINCIPAL — subinterfaces + DHCP + CME (pegar completo)

Conexión física: **R-PRINCIPAL Fa0/0 → SW-PRINCIPAL Fa0/7** (trunk, sección A). En la CLI del router (`no` al diálogo inicial):

```
enable
configure terminal
hostname R-PRINCIPAL
interface FastEthernet0/0
 no shutdown
exit
interface FastEthernet0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.248
exit
interface FastEthernet0/0.20
 encapsulation dot1Q 20
 ip address 192.168.10.9 255.255.255.248
exit
interface FastEthernet0/0.30
 encapsulation dot1Q 30
 ip address 192.168.10.17 255.255.255.248
exit
interface FastEthernet0/0.40
 encapsulation dot1Q 40
 ip address 192.168.10.33 255.255.255.240
exit
ip dhcp excluded-address 192.168.10.33 192.168.10.39
ip dhcp excluded-address 192.168.10.41 192.168.10.46
ip dhcp pool VOZ
 network 192.168.10.32 255.255.255.240
 default-router 192.168.10.33
 option 150 ip 192.168.10.33
exit
telephony-service
 max-ephones 1
 max-dn 1
 ip source-address 192.168.10.33 port 2000
 auto assign 1 to 1
exit
ephone-dn 1
 number 100
end
copy running-config startup-config
```

> ⚠️ Cambio clave vs. la versión anterior: **el DHCP vive en el router, no en el SRV** — se elimina el pool en SRV → Services → DHCP (apágalo si lo activaste) y los `ip helper-address`. Menos piezas, menos fallas. Las exclusiones dejan disponible **solo la .40**, así el teléfono recibe exactamente esa IP; `option 150` apunta al CME del propio router y `auto assign` registra la línea **100** sin escribir la MAC.

## D. Verificación

1. `show ip interface brief` en el router: las 4 subinterfaces **up/up**.
2. Esperar ~1 min → cursor sobre TEL-IP: IP `192.168.10.40`; pantalla con línea **100**.
3. Pings obligatorios (el primero puede perder 1 paquete por ARP — repetir):

| Prueba | Comando | Nota |
|---|---|---|
| Intra-sector | PC-1: `ping 192.168.10.5` (IMP-1) | No pasa por el router |
| Sector → servidor | PC-1: `ping 192.168.10.34` (SRV) | Cruza VLAN 10 → 40 |
| Entre sectores | PC-4: `ping 192.168.10.18` (PC-6) | Cruza VLAN 20 → 30 |
| Área técnica | LAP-3: `ping 192.168.10.36` (TV-CORP) | Misma VLAN 40 |
| Teléfono | SRV: `ping 192.168.10.40` | Requiere sección C |

4. Extra Simulation: PDU de PC-1 a SRV → el recorrido muestra PC-1 → SW-A → SW-PRINCIPAL → **R-PRINCIPAL** → SW-PRINCIPAL → SRV (router-on-a-stick en acción — captura ideal para anexos).

## Errores frecuentes (subneteo)

| Problema | Causa probable | Solución |
|---|---|---|
| `% ... overlaps with ...` al configurar el router | Subredes solapadas (el bug del plan viejo) | Usar el plan corregido de arriba |
| Ping entre sectores falla, intra-sector funciona | Trunk sin la VLAN permitida, o subinterfaz caída | `show interfaces trunk` y `show ip int brief` |
| Ping falla solo hacia área técnica | Equipos aún con IPs viejas .26–.31 | Re-IP según tabla (bloque .32/28) |
| TEL-IP sin IP | DHCP del SRV aún activo compitiendo, o falta option 150 | Apagar DHCP en SRV; revisar sección C |
| Gestión del switch no responde | SVI en VLAN 1 | Sección B: SVI en la VLAN propia |

---

## Registro de cambios

### v4 (05-07-2026) — subneteo corregido
1. **Área técnica movida a 192.168.10.32/28** (el `.24/28` anterior no es frontera válida y solapaba con Sector C → el router rechazaba la subinterfaz VLAN 40). Nuevas IPs: gw .33, SRV .34, MFP .35, TV .36, LAP-3 .37, IMP-3 .38, TEL-IP .40 (DHCP), SW-PRINCIPAL .46.
2. **SVI de gestión en la VLAN propia** de cada switch (antes: VLAN 1, inalcanzable) + `ip default-gateway`.
3. **DHCP movido del SRV al router** (se eliminan pool en SRV y `ip helper-address`); exclusiones dejan solo la .40 para el teléfono.
4. **Eliminadas las pseudo-subredes /30 de los enlaces** entre switches: son trunks de capa 2.
5. Se adopta oficialmente el diseño con subneteo/VLANs (coherente con la materia del curso); la v3 de red plana queda obsoleta. **Pendiente: actualizar el informe** (direccionamiento, topología lógica y sección de mejoras futuras).
