---
tags: [caso05, packet-tracer, verificacion]
---

# Paso 7: Verificación — Probar conectividad

Comprobar que la red funcione antes de tomar capturas.

## Router

```
R-PRINCIPAL# show ip interface brief
Interface             IP-Address      OK? Method Status          Protocol
FastEthernet0/0       192.168.10.1    YES manual up              up
FastEthernet0/1       unassigned      YES unset  administratively down down
```

Solo Fa0/0 debe estar `up/up`. Fa0/1 puede quedar `down` (no se usa).

## DHCP (si el teléfono tiene DHCP)

```
R-PRINCIPAL# show ip dhcp binding
Bindings from all pools not associated with VRF:
IP address       Client-ID/            Lease expiration        Type
                 Hardware address/
                 User name
192.168.10.39    0001.1234.5678         --                     Automatic
```

## CME (si el teléfono registró)

```
R-PRINCIPAL# show ephone
ephone-1  Mac: 0001.1234.5678  TCP socket: [1] 192.168.10.39:50855
  line: 1   DN 1  100   CHANNEL 1  0
```

## Pings

Desde el router:

```
R-PRINCIPAL# ping 192.168.10.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.10.2, timeout is 2 seconds:
!!!!!
Success rate is 80 percent (4/5)

R-PRINCIPAL# ping 192.168.10.11
!!!!!
Success rate is 80 percent (4/5)

R-PRINCIPAL# ping 192.168.10.18
!!!!!
Success rate is 100 percent (5/5)

R-PRINCIPAL# ping 192.168.10.34
!!!!!
Success rate is 100 percent (5/5)
```

> Si algún ping da 0%, ese sector no tiene conectividad. Revisar:
> - Cableado físico (leds verdes)
> - IP del dispositivo (Desktop → IP Configuration)
> - Switch: `show interfaces status` para ver si el puerto está `up`
> - Que el dispositivo esté encendido (en PT los dispositivos arrancan encendidos)

## Estado de switches

```
SW-PRINCIPAL# show interfaces status
Port      Name               Status       Vlan       Duplex  Speed Type
Fa0/1     Area tecnica - SRV connected    1          a-full  a-100 10/100BaseTX
Fa0/7     Enlace al router   connected    1          a-full  a-100 10/100BaseTX
Fa0/24    Enlace SW-A        connected    1          a-full  a-100 10/100BaseTX
Gig0/1    Enlace SW-C        connected    1          a-full  a-1000 10/100/1000BaseTX
Gig0/2    Enlace SW-B        connected    1          a-full  a-1000 10/100/1000BaseTX
```

Todos los puertos deben mostrar **connected**.
