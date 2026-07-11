---
tags: [caso05, packet-tracer, instrucciones]
---

# Instrucciones PT Caso 05 — desde cero (coherente con PDF del profesor)

Basado en el PDF original del profesor (Trabajo_investigacion_tecnico_economico_Caso_05.pdf). Sin VLANs, sin subnetting — red plana `/24`. Router solo para DHCP + CME del teléfono.

## Topología

### Dispositivos (23 total)

| Tipo | Cant | Dispositivos | Modelo |
|------|------|-------------|--------|
| Switch core | 1 | SW-PRINCIPAL | 2960-24TT |
| Switch acceso | 3 | SW-A, SW-B, SW-C | 2960-24TT |
| Router | 1 | R-PRINCIPAL | 2811 |
| PC | 8 | PC-1 a PC-8 | PC-PT |
| Laptop | 3 | LAP-1, LAP-2, LAP-3 | Laptop-PT |
| Impresora | 3 | IMP-1, IMP-2, IMP-3 | Printer-PT |
| MFP | 1 | MFP | Printer-PT |
| Server | 1 | SRV | Server-PT |
| Teléfono IP | 1 | TEL-IP | 7960 (cambiado a Home VoIP-PT) |
| TV corporativa | 1 | TV-CORP | PC-PT |

### Conexiones físicas

**Uplinks de switches de acceso a SW-PRINCIPAL:**
- SW-PRINCIPAL Fa0/24 — SW-A Gig0/1 (cable straight)
- SW-PRINCIPAL Gig0/2 — SW-B Gig0/1 (cable straight)
- SW-PRINCIPAL Gig0/1 — SW-C Gig0/1 (cable straight)

**Router a SW-PRINCIPAL:**
- R-PRINCIPAL Fa0/0 — SW-PRINCIPAL Fa0/7 (cable straight)

**Teléfono a SW-PRINCIPAL:**
- SW-PRINCIPAL Fa0/3 — TEL-IP (Home VoIP-PT) Fa0 (cable straight)

**Área técnica (Fa0/1 a Fa0/6 de SW-PRINCIPAL):**
- SW-PRINCIPAL Fa0/1 — SRV
- SW-PRINCIPAL Fa0/2 — MFP
- SW-PRINCIPAL Fa0/3 — TEL-IP
- SW-PRINCIPAL Fa0/4 — LAP-3
- SW-PRINCIPAL Fa0/5 — IMP-3
- SW-PRINCIPAL Fa0/6 — TV-CORP

**SW-A acceso (Fa0/1 a Fa0/4):** PC-1, PC-2, PC-3, IMP-1
**SW-B acceso (Fa0/1 a Fa0/4):** PC-4, PC-5, LAP-1, LAP-2
**SW-C acceso (Fa0/1 a Fa0/4):** PC-6, PC-7, PC-8, IMP-2

### Rack / Patch Panel

En el Packet Tracer:
1. Agregar un **rack vacío** por cada switch (Generic → Rack) o usar **Patch Panel** si hay disponibles en PT (WAN Components → Patch Panel)
2. Conectar cada punto terminal al patch panel correspondiente
3. Del patch panel al switch (cable straight)

Esto representa visualmente la infraestructura de cableado estructurado para las capturas del informe. En el rack: SW-PRINCIPAL + 3 patch panels (uno por sector) + router.

## IP Addressing — Red plana /24

| Dispositivo | IP | Gateway | Sector |
|------------|-----|---------|--------|
| **Router Fa0/0** | 192.168.10.1/24 | — | Zaguán (todos) |
| PC-1 | 192.168.10.2/24 | .1 | Sector A |
| PC-2 | 192.168.10.3/24 | .1 | Sector A |
| PC-3 | 192.168.10.4/24 | .1 | Sector A |
| IMP-1 | 192.168.10.5/24 | .1 | Sector A |
| PC-4 | 192.168.10.10/24 | .1 | Sector B |
| PC-5 | 192.168.10.11/24 | .1 | Sector B |
| LAP-1 | 192.168.10.12/24 | .1 | Sector B |
| LAP-2 | 192.168.10.13/24 | .1 | Sector B |
| PC-6 | 192.168.10.18/24 | .1 | Sector C |
| PC-7 | 192.168.10.19/24 | .1 | Sector C |
| PC-8 | 192.168.10.20/24 | .1 | Sector C |
| IMP-2 | 192.168.10.21/24 | .1 | Sector C |
| SRV | 192.168.10.34/24 | .1 | Área técnica |
| MFP | 192.168.10.35/24 | .1 | Área técnica |
| LAP-3 | 192.168.10.37/24 | .1 | Área técnica |
| IMP-3 | 192.168.10.38/24 | .1 | Área técnica |
| TV-CORP | 192.168.10.36/24 | .1 | Área técnica |
| TEL-IP | DHCP desde router | .1 | Área técnica |

## Router — Configuración

Solo configuración mínima: IP en Fa0/0, DHCP pool para el teléfono, CME.

```
enable
configure terminal
hostname R-PRINCIPAL
!
interface FastEthernet0/0
 ip address 192.168.10.1 255.255.255.0
 no shutdown
!
ip dhcp pool VOZ
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 option 150 ip 192.168.10.1
!
ip dhcp excluded-address 192.168.10.1 192.168.10.38
ip dhcp excluded-address 192.168.10.40 192.168.10.254
!
telephony-service
 max-ephones 1
 max-dn 1
 ip source-address 192.168.10.1 port 2000
 auto assign 1
!
ephone-dn 1
 number 100
!
end
```

> El pool VOZ excluye todas las IPs fijas (.1-.38) más .40 en adelante. TEL-IP recibe .39 por DHCP.

## Switches — Configuración

Mínima: solo hostname y un uplink trunk opcional (si no, quedan como default VLAN 1 — funciona igual en red plana).

```
enable
configure terminal
hostname SW-A
interface GigabitEthernet0/1
 switchport mode access
 switchport access vlan 1
!
interface range FastEthernet0/1-4
 switchport mode access
 switchport access vlan 1
!
end
```

Repetir para SW-B y SW-C cambiando hostname.

### SW-PRINCIPAL

```
enable
configure terminal
hostname SW-PRINCIPAL
!
interface FastEthernet0/7
 description Enlace al router
 switchport mode access
 switchport access vlan 1
!
interface FastEthernet0/1
 description Area tecnica - SRV
 switchport mode access
!
interface FastEthernet0/2
 description Area tecnica - MFP
 switchport mode access
!
interface FastEthernet0/3
 description Area tecnica - TEL-IP
 switchport mode access
 switchport voice vlan 1
!
interface FastEthernet0/4
 description Area tecnica - LAP-3
 switchport mode access
!
interface FastEthernet0/5
 description Area tecnica - IMP-3
 switchport mode access
!
interface FastEthernet0/6
 description Area tecnica - TV-CORP
 switchport mode access
!
interface FastEthernet0/24
 description Enlace SW-A
 switchport mode access
!
interface GigabitEthernet0/1
 description Enlace SW-C
 switchport mode access
!
interface GigabitEthernet0/2
 description Enlace SW-B
 switchport mode access
!
end
```

## Verificación básica

```
R-PRINCIPAL# show ip interface brief
R-PRINCIPAL# show ip dhcp binding
R-PRINCIPAL# show ephone
R-PRINCIPAL# ping 192.168.10.2
R-PRINCIPAL# ping 192.168.10.11
R-PRINCIPAL# ping 192.168.10.18
```

## TEL-IP — Configuración final

En Home VoIP0 → Desktop → **CIPC** (Cisco IP Communicator):
1. Configurar TFTP server: `192.168.10.1`
2. El teléfono debe registrar línea 100 automáticamente
3. Verificar con `show ephone` en el router

## Para el informe

**Capturas necesarias:**
1. Topología completa en Packet Tracer (mostrando todos los dispositivos + conexiones)
2. `show ip interface brief` del router
3. `show ip dhcp binding` (ver TEL-IP .39 asignado)
4. `show ephone` (ver teléfono registrado)
5. Ping de router a PC en cada sector (funcional)
6. Canvas de PT mostrando el rack con patch panels y switches

> Coherente con el PDF del profesor: red plana sin VLANs, router solo para telefono, foco en cableado estructurado y cotizaciones.
