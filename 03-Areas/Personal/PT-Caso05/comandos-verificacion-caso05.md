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

Output:  

R-PRINCIPAL>enable

R-PRINCIPAL#show ip interface brief

Interface IP-Address OK? Method Status Protocol

FastEthernet0/0 unassigned YES unset up up

FastEthernet0/0.10 192.168.10.1 YES manual up up

FastEthernet0/0.20 192.168.10.9 YES manual up up

FastEthernet0/0.30 192.168.10.17 YES manual up up

FastEthernet0/0.40 192.168.10.33 YES manual up up

FastEthernet0/1 unassigned YES unset administratively down down

Vlan1 unassigned YES unset administratively down down

R-PRINCIPAL#show ip route

Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP

D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area

N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2

E1 - OSPF external type 1, E2 - OSPF external type 2, E - EGP

i - IS-IS, L1 - IS-IS level-1, L2 - IS-IS level-2, ia - IS-IS inter area

* - candidate default, U - per-user static route, o - ODR

P - periodic downloaded static route

  

Gateway of last resort is not set

  

192.168.10.0/24 is variably subnetted, 8 subnets, 3 masks

C 192.168.10.0/29 is directly connected, FastEthernet0/0.10

L 192.168.10.1/32 is directly connected, FastEthernet0/0.10

C 192.168.10.8/29 is directly connected, FastEthernet0/0.20

L 192.168.10.9/32 is directly connected, FastEthernet0/0.20

C 192.168.10.16/29 is directly connected, FastEthernet0/0.30

L 192.168.10.17/32 is directly connected, FastEthernet0/0.30

C 192.168.10.32/28 is directly connected, FastEthernet0/0.40

L 192.168.10.33/32 is directly connected, FastEthernet0/0.40

  

R-PRINCIPAL#show arp

  

R-PRINCIPAL#show ip dhcp binding

IP address Client-ID/ Lease expiration Type

Hardware address

R-PRINCIPAL#show running-config | section dhcp

ip dhcp excluded-address 192.168.10.33 192.168.10.39

ip dhcp excluded-address 192.168.10.41 192.168.10.46

ip dhcp excluded-address 192.168.10.40

ip dhcp pool VOZ

network 192.168.10.32 255.255.255.240

default-router 192.168.10.33

option 150 ip 192.168.10.33

R-PRINCIPAL#show running-config | section telephony

telephony-service

max-ephones 1

max-dn 1

ip source-address 192.168.10.33 port 2000

auto assign 1 to 1

R-PRINCIPAL#show telephony-service

^

% Invalid input detected at '^' marker.

R-PRINCIPAL#

R-PRINCIPAL#show ephone

R-PRINCIPAL#show ephone registered

^

% Invalid input detected at '^' marker.

R-PRINCIPAL#show running-config | section interface

interface FastEthernet0/0

no ip address

duplex auto

speed auto

interface FastEthernet0/0.10

encapsulation dot1Q 10

ip address 192.168.10.1 255.255.255.248

interface FastEthernet0/0.20

encapsulation dot1Q 20

ip address 192.168.10.9 255.255.255.248

interface FastEthernet0/0.30

encapsulation dot1Q 30

ip address 192.168.10.17 255.255.255.248

interface FastEthernet0/0.40

encapsulation dot1Q 40

ip address 192.168.10.33 255.255.255.240

interface FastEthernet0/1

no ip address

duplex auto

speed auto

shutdown

interface Vlan1

no ip address

shutdown

R-PRINCIPAL#

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


Output: 
SW-PRINCIPAL:
SW-PRINCIPAL>enable

SW-PRINCIPAL#show vlan

  

VLAN Name Status Ports

---- -------------------------------- --------- -------------------------------

1 default active Fa0/8, Fa0/9, Fa0/10, Fa0/11

Fa0/12, Fa0/13, Fa0/14, Fa0/15

Fa0/16, Fa0/17, Fa0/18, Fa0/19

Fa0/20, Fa0/21, Fa0/22, Fa0/23

10 SECTOR-A active

20 SECTOR-B active

30 SECTOR-C active

40 AREA-TECNICA active Fa0/1, Fa0/2, Fa0/3, Fa0/4

Fa0/5, Fa0/6

1002 fddi-default active

1003 token-ring-default active

1004 fddinet-default active

1005 trnet-default active

  

VLAN Type SAID MTU Parent RingNo BridgeNo Stp BrdgMode Trans1 Trans2

---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------

1 enet 100001 1500 - - - - - 0 0

10 enet 100010 1500 - - - - - 0 0

20 enet 100020 1500 - - - - - 0 0

  

SW-PRINCIPAL#how interfaces trunk

^

% Invalid input detected at '^' marker.

SW-PRINCIPAL#show mac address-table dynamic

Mac Address Table

-------------------------------------------

  

Vlan Mac Address Type Ports

---- ----------- -------- -----

  

10 0050.0f07.9c19 DYNAMIC Fa0/24

20 00d0.bc9a.ae19 DYNAMIC Gig0/2

30 00e0.8f98.6a19 DYNAMIC Gig0/1

40 0002.4ad9.044b DYNAMIC Fa0/3

SW-PRINCIPAL#show running-config | include switchport access vlan

switchport access vlan 40

switchport access vlan 40

switchport access vlan 40

switchport access vlan 40

switchport access vlan 40

switchport access vlan 40

SW-PRINCIPAL#show running-config | include interface Vlan

interface Vlan1

interface Vlan40

SW-PRINCIPAL#show running-config | include switchport mode

switchport mode trunk

switchport mode trunk

switchport mode trunk

switchport mode trunk

SW-PRINCIPAL#

SW-1: 

SW-A>enable
SW-A#show vlan

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Fa0/5, Fa0/6, Fa0/7, Fa0/8
                                                Fa0/9, Fa0/10, Fa0/11, Fa0/12
                                                Fa0/13, Fa0/14, Fa0/15, Fa0/16
                                                Fa0/17, Fa0/18, Fa0/19, Fa0/20
                                                Fa0/21, Fa0/22, Fa0/23, Fa0/24
                                                Gig0/2
10   SECTOR-A                         active    Fa0/1, Fa0/2, Fa0/3, Fa0/4
1002 fddi-default                     active    
1003 token-ring-default               active    
1004 fddinet-default                  active    
1005 trnet-default                    active    

VLAN Type  SAID       MTU   Parent RingNo BridgeNo Stp  BrdgMode Trans1 Trans2
---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------
1    enet  100001     1500  -      -      -        -    -        0      0
10   enet  100010     1500  -      -      -        -    -        0      0
1002 fddi  101002     1500  -      -      -        -    -        0      0   
1003 tr    101003     1500  -      -      -        -    -        0      0   
1004 fdnet 101004     1500  -      -      -        ieee -        0      0   

SW-A#how interfaces trunk
         ^
% Invalid input detected at '^' marker.
	
SW-A#show mac address-table dynamic
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----

   1    0001.c98d.8218    DYNAMIC      Gig0/1
SW-A#show running-config | include switchport access vlan
 switchport access vlan 10
 switchport access vlan 10
 switchport access vlan 10
 switchport access vlan 10
SW-A#show running-config | include interface Vlan
interface Vlan1
SW-A#show running-config | include switchport mode
SW-A#

sw-b:
****SW-B>enable

SW-B#show vlan

  

VLAN Name Status Ports

---- -------------------------------- --------- -------------------------------

1 default active Fa0/5, Fa0/6, Fa0/7, Fa0/8

Fa0/9, Fa0/10, Fa0/11, Fa0/12

Fa0/13, Fa0/14, Fa0/15, Fa0/16

Fa0/17, Fa0/18, Fa0/19, Fa0/20

Fa0/21, Fa0/22, Fa0/23, Fa0/24

Gig0/2

20 SECTOR-B active Fa0/1, Fa0/2, Fa0/3, Fa0/4

1002 fddi-default active

1003 token-ring-default active

1004 fddinet-default active

1005 trnet-default active

  

VLAN Type SAID MTU Parent RingNo BridgeNo Stp BrdgMode Trans1 Trans2

---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------

1 enet 100001 1500 - - - - - 0 0

20 enet 100020 1500 - - - - - 0 0

1002 fddi 101002 1500 - - - - - 0 0

1003 tr 101003 1500 - - - - - 0 0

1004 fdnet 101004 1500 - - - ieee - 0 0

  

SW-B#how interfaces trunk

^

% Invalid input detected at '^' marker.

SW-B#show mac address-table dynamic

Mac Address Table

-------------------------------------------

  

Vlan Mac Address Type Ports

---- ----------- -------- -----

  

1 0001.c98d.821a DYNAMIC Gig0/1

SW-B#show running-config | include switchport access vlan

switchport access vlan 20

switchport access vlan 20

switchport access vlan 20

switchport access vlan 20

SW-B#show running-config | include interface Vlan

interface Vlan1

SW-B#show running-config | include switchport mode

SW-B#****

sw-c: SW-C>enable

SW-C#show vlan

  

VLAN Name Status Ports

---- -------------------------------- --------- -------------------------------

1 default active Fa0/5, Fa0/6, Fa0/7, Fa0/8

Fa0/9, Fa0/10, Fa0/11, Fa0/12

Fa0/13, Fa0/14, Fa0/15, Fa0/16

Fa0/17, Fa0/18, Fa0/19, Fa0/20

Fa0/21, Fa0/22, Fa0/23, Fa0/24

Gig0/2

30 SECTOR-C active Fa0/1, Fa0/2, Fa0/3, Fa0/4

1002 fddi-default active

1003 token-ring-default active

1004 fddinet-default active

1005 trnet-default active

  

VLAN Type SAID MTU Parent RingNo BridgeNo Stp BrdgMode Trans1 Trans2

---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------

1 enet 100001 1500 - - - - - 0 0

30 enet 100030 1500 - - - - - 0 0

1002 fddi 101002 1500 - - - - - 0 0

1003 tr 101003 1500 - - - - - 0 0

1004 fdnet 101004 1500 - - - ieee - 0 0

  

SW-C#how interfaces trunk

^

% Invalid input detected at '^' marker.

SW-C#show mac address-table dynamic

Mac Address Table

-------------------------------------------

  

Vlan Mac Address Type Ports

---- ----------- -------- -----

  

1 0001.c98d.8219 DYNAMIC Gig0/1

SW-C#show running-config | include switchport access vlan

switchport access vlan 30

switchport access vlan 30

switchport access vlan 30

switchport access vlan 30

SW-C#show running-config | include interface Vlan

interface Vlan1

SW-C#show running-config | include switchport mode

SW-C#
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
