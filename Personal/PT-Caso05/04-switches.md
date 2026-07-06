---
tags: [caso05, packet-tracer, switches, CLI]
---

# Paso 4: Switches — Configuración CLI

Configurar los 4 switches. Todos en **access vlan 1** (red plana, sin VLANs).

## SW-PRINCIPAL

Click → **CLI**:

```
enable
configure terminal
hostname SW-PRINCIPAL
!
interface FastEthernet0/7
 description Enlace al router
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
end
write memory
```

## SW-A

```
enable
configure terminal
hostname SW-A
!
interface GigabitEthernet0/1
 description Uplink a SW-PRINCIPAL
 switchport mode access
!
interface FastEthernet0/1
 description Sector A - PC-1
 switchport mode access
!
interface FastEthernet0/2
 description Sector A - PC-2
 switchport mode access
!
interface FastEthernet0/3
 description Sector A - PC-3
 switchport mode access
!
interface FastEthernet0/4
 description Sector A - IMP-1
 switchport mode access
!
end
write memory
```

## SW-B

```
enable
configure terminal
hostname SW-B
!
interface GigabitEthernet0/1
 description Uplink a SW-PRINCIPAL
 switchport mode access
!
interface FastEthernet0/1
 description Sector B - PC-4
 switchport mode access
!
interface FastEthernet0/2
 description Sector B - PC-5
 switchport mode access
!
interface FastEthernet0/3
 description Sector B - LAP-1
 switchport mode access
!
interface FastEthernet0/4
 description Sector B - LAP-2
 switchport mode access
!
end
write memory
```

## SW-C

```
enable
configure terminal
hostname SW-C
!
interface GigabitEthernet0/1
 description Uplink a SW-PRINCIPAL
 switchport mode access
!
interface FastEthernet0/1
 description Sector C - PC-6
 switchport mode access
!
interface FastEthernet0/2
 description Sector C - PC-7
 switchport mode access
!
interface FastEthernet0/3
 description Sector C - PC-8
 switchport mode access
!
interface FastEthernet0/4
 description Sector C - IMP-2
 switchport mode access
!
end
write memory
```

## Notas importantes

- **No configurar trunks** — en red plana todos los puertos están en VLAN 1 (default). No se necesita 802.1Q.
- **No configurar SVIs** — las SVIs son para enrutamiento entre VLANs. Acá no hay VLANs.
- **`switchport mode access`** explícito asegura que el puerto no negocie trunk automáticamente.
- Las **descriptions** no son obligatorias pero ayudan a identificar qué está conectado dónde.
- `write memory` graba la config para que sobreviva un reinicio de PT.
