---
tags: [caso05, packet-tracer, router, CLI]
---

# Paso 3: Router — Configuración CLI

Configurar R-PRINCIPAL (2811) vía CLI.

## Acceder

Hacer click en R-PRINCIPAL → **CLI** tab.

## Comandos

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
write memory
```

## Explicación

| Comando | Qué hace |
|---------|----------|
| `ip address .1 /24` | IP del router como gateway de toda la red |
| `no shutdown` | Activa la interfaz (por default viene apagada) |
| `ip dhcp pool VOZ` | Crea un pool DHCP para el teléfono |
| `network .0 /24` | Rango de IPs que DHCP puede asignar |
| `default-router .1` | Gateway que DHCP le da al teléfono |
| `option 150 ip .1` | TFTP server (el CME) — el teléfono lo necesita para registrarse |
| `excluded-address .1-.38` | Excluye IPs estáticas (no se asignan por DHCP) |
| `excluded-address .40-.254` | Excluye el resto (solo .39 queda disponible) |
| `telephony-service` | Activa Call Manager Express |
| `max-ephones 1` | Soporta 1 teléfono |
| `max-dn 1` | Soporta 1 número (directory number) |
| `ip source-address .1 port 2000` | IP del servidor CME + puerto SCCP |
| `auto assign 1` | Asigna automáticamente el primer DN |
| `ephone-dn 1 / number 100` | Define el número 100 |
| `write memory` | Guarda la config en startup-config |

## Verificar

```
R-PRINCIPAL# show ip interface brief
R-PRINCIPAL# show running-config | section dhcp
R-PRINCIPAL# show running-config | section telephony
```
