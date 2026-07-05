---
tags: [caso05, packet-tracer, verificacion]
---

# Comandos de verificación — Caso 05

## R-PRINCIPAL (router)

```
enable
show ip interface brief
show ip route
show arp
show ip dhcp binding
show running-config | section dhcp
show running-config | section telephony
show telephony-service
show ephone
show ephone registered
show running-config | section interface
```

## Switches (SW-PRINCIPAL, SW-A, SW-B, SW-C)

```
enable
show vlan
show interfaces trunk
show mac address-table dynamic
show running-config | include switchport access vlan
show running-config | include interface Vlan
show running-config | include switchport mode
```

## PCs (PC-1 a PC-8)

```
ipconfig
ping 192.168.10.1       (gateway VLAN 10)
ping 192.168.10.9       (gateway VLAN 20)
ping 192.168.10.17      (gateway VLAN 30)
ping 192.168.10.33      (gateway VLAN 40)
```

Ping cruzado desde PC-1 (VLAN 10, .2):
```
ping 192.168.10.10   (PC-4 VLAN 20)
ping 192.168.10.18   (PC-6 VLAN 30)
ping 192.168.10.34   (SRV VLAN 40)
```

## Área Técnica

```
ipconfig
ping 192.168.10.33   (gateway)
ping 192.168.10.2    (PC-1 VLAN 10)
```

## Fix pendiente

En R-PRINCIPAL:
```
configure terminal
no ip dhcp excluded-address 192.168.10.40
end
write memory
```

## Tabla de IPs por dispositivo

### VLAN 10 — SW-A
PC-1 .2, PC-2 .3, PC-3 .4, IMP-1 .5 — gw .1

### VLAN 20 — SW-B
PC-4 .10, PC-5 .11, LAP-1 .12, LAP-2 .13 — gw .9

### VLAN 30 — SW-C
PC-6 .18, PC-7 .19, PC-8 .20, IMP-2 .21 — gw .17

### VLAN 40 — SW-PRINCIPAL
SRV .34, MFP .35, TV-CORP .36, LAP-3 .37, IMP-3 .38, TEL-IP .40(DHCP) — gw .33
