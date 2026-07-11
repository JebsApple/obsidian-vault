# Instrucciones — Simulación en Cisco Packet Tracer (Caso 07)

> Topología: **estrella jerárquica** — 4 switches de acceso/distribución conectados a 1 switch principal + 1 router de borde. Total: **17 puntos terminales** (12 estaciones cliente + 2 impresoras + 3 servidores). Red `192.168.0.0/24` dividida en subredes por sector.

---

## 0. Antes de empezar

Vas a construir esta red:

```
 PC1 ─┐                    ┌─ SRV1
 PC2 ─┤                    ├─ SRV2
 PC3 ─┤   ┌──────────┐     ├─ SRV3
 IMP1 ─┴───┤  SW-A    │     └─ LAP2
           └────┬─────┘
                │
 PC4 ─┐        │          ┌───────┐
 PC5 ─┤   ┌────┴─────┐    │       │          ┌────────┐
 PC6 ─┤   │  SW-B    ├────┤  SW-  ├──────────┤  RTR-  │
 LAP1 ─┴───┘          │    │ PRIN- │          │ PRINCI-│
           └────┬─────┘    │ CIPAL │          │ PAL   │
                │          └───────┘          └────────┘
 PC7 ─┐        │
 PC8 ─┤   ┌────┴─────┐
 PC9 ─┤   │  SW-C    │
 PC10─┤   └──────────┘
 IMP2 ─┘
```

- **SW-A, SW-B, SW-C**: switches de acceso (concentran equipos de su sector)
- **SW-PRINCIPAL**: switch de distribución central (recibe a todos los sectores + servidores)
- **RTR-PRINCIPAL**: router de borde (conecta la LAN institucional)

---

## 1. Crear el proyecto

1. Abre **Cisco Packet Tracer**
2. Menú **File** → **New**
3. Menú **File** → **Save As...**
4. Escribe: `Caso07_Herrera_Soncco.pkt`
5. Clic en **Save**

---

## 2. Mostrar puertos en los dispositivos

1. Menú **Options** → **Preferences**
2. Pestaña **Interface**
3. Marca **Always Show Port Labels**
4. Clic en **OK**

---

## 3. Agregar los switches (5 en total)

En la barra izquierda → **Network Devices** → **Switches**. Busca **2960-24TT**.

### SW-PRINCIPAL (1 unidad) — el switch central

Arrástralo al lienzo. Renómbralo: clic en el nombre `Switch0` arriba a la derecha → escribe `SW-PRINCIPAL`

### SW-A, SW-B, SW-C (3 unidades de acceso)

Arrastra 3 switches 2960-24TT más. Renómbralos: `SW-A`, `SW-B`, `SW-C`

Total: **4 switches** en el lienzo.

---

## 4. Agregar el router

1. **Network Devices** → **Routers**
2. Busca **1841** (router con 2 puertos FastEthernet)
3. Arrástralo al lienzo
4. Renómbralo: `RTR-PRINCIPAL`

---

## 5. Agregar los equipos finales (17 puntos terminales)

Barra izquierda → **End Devices** → **End Devices**.

### PC1 a PC10 (10 estaciones de trabajo)

1. Busca **PC-PT** y arrastra 10 veces
2. Renómbralos: `PC1` a `PC10`

### LAP1, LAP2 (2 laptops corporativas)

1. Busca **Laptop-PT** y arrastra 2 veces
2. Renómbralos: `LAP1`, `LAP2`

### IMP1, IMP2 (2 impresoras de red)

1. Busca **Printer-PT** y arrastra 2 veces
2. Renómbralos: `IMP1`, `IMP2`

### SRV1, SRV2, SRV3 (3 servidores)

1. Busca **Server-PT** y arrastra 3 veces
2. Renómbralos: `SRV1`, `SRV2`, `SRV3`

### Verificación final

Debes tener en el lienzo:

| Tipo | Cantidad | Nombres |
|------|----------|---------|
| Switch 2960-24TT | 4 | SW-PRINCIPAL, SW-A, SW-B, SW-C |
| Router 1841 | 1 | RTR-PRINCIPAL |
| PC-PT | 10 | PC1 a PC10 |
| Laptop-PT | 2 | LAP1, LAP2 |
| Printer-PT | 2 | IMP1, IMP2 |
| Server-PT | 3 | SRV1, SRV2, SRV3 |

Total: **22 dispositivos** + **17 puntos terminales**

---

## 6. Posicionar los dispositivos

| ¿Dónde? | Dispositivos |
|---------|-------------|
| **Arriba a la izquierda** | SW-A, PC1, PC2, PC3, IMP1 |
| **Centro izquierda** | SW-B, PC4, PC5, PC6, LAP1 |
| **Abajo a la izquierda** | SW-C, PC7, PC8, PC9, PC10, IMP2 |
| **Arriba a la derecha** | SW-PRINCIPAL, SRV1, SRV2, SRV3, LAP2 |
| **Abajo a la derecha** | RTR-PRINCIPAL |

Deja 5-10 cm entre dispositivos para cablear.

---

## 7. Cableado — conectar todo

### 7.1 Tipo de cable

**Connections** (ícono de rayo) → **Copper Straight-Through** (cable recto).
Si un enlace entre switches sale **rojo**, cámbialo a **Copper Cross-Over**.

### 7.2 Sector A (SW-A)

| Desde | Puerto | Hacia | Puerto |
|-------|--------|-------|--------|
| PC1 | FastEthernet0 | SW-A | FastEthernet0/1 |
| PC2 | FastEthernet0 | SW-A | FastEthernet0/2 |
| PC3 | FastEthernet0 | SW-A | FastEthernet0/3 |
| IMP1 | FastEthernet0 | SW-A | FastEthernet0/4 |

### 7.3 Sector B (SW-B)

| Desde | Puerto | Hacia | Puerto |
|-------|--------|-------|--------|
| PC4 | FastEthernet0 | SW-B | FastEthernet0/1 |
| PC5 | FastEthernet0 | SW-B | FastEthernet0/2 |
| PC6 | FastEthernet0 | SW-B | FastEthernet0/3 |
| LAP1 | FastEthernet0 | SW-B | FastEthernet0/4 |

### 7.4 Sector C (SW-C)

| Desde | Puerto | Hacia | Puerto |
|-------|--------|-------|--------|
| PC7 | FastEthernet0 | SW-C | FastEthernet0/1 |
| PC8 | FastEthernet0 | SW-C | FastEthernet0/2 |
| PC9 | FastEthernet0 | SW-C | FastEthernet0/3 |
| PC10 | FastEthernet0 | SW-C | FastEthernet0/4 |
| IMP2 | FastEthernet0 | SW-C | FastEthernet0/5 |

### 7.5 Área servidores (SW-PRINCIPAL)

| Desde | Puerto | Hacia | Puerto |
|-------|--------|-------|--------|
| SRV1 | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/1 |
| SRV2 | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/2 |
| SRV3 | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/3 |
| LAP2 | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/4 |

### 7.6 Router (RTR-PRINCIPAL)

| Desde | Puerto | Hacia | Puerto |
|-------|--------|-------|--------|
| RTR-PRINCIPAL | **FastEthernet0/0** | SW-PRINCIPAL | **GigabitEthernet0/1** |

### 7.7 Enlaces entre switches (troncales)

| Desde | Puerto | Hacia | Puerto |
|-------|--------|-------|--------|
| SW-A | GigabitEthernet0/1 | SW-PRINCIPAL | GigabitEthernet0/2 |
| SW-B | GigabitEthernet0/1 | SW-PRINCIPAL | GigabitEthernet0/3 |
| SW-C | GigabitEthernet0/1 | SW-PRINCIPAL | **FastEthernet0/24** |

**⚠️ Si algún enlace sale ROJO**: bórralo y usa **Copper Cross-Over**.
**⚠️ Si sale NARANJO**: espera 30 segundos (STP), se pondrá verde solo.

---

## 8. Subredes (para el informe)

| Sector | Subred | Máscara | Gateway | Hosts |
|--------|--------|---------|---------|-------|
| A (SW-A) | 192.168.0.0/28 | 255.255.255.240 | 192.168.0.1 | 14 |
| B (SW-B) | 192.168.0.16/28 | 255.255.255.240 | 192.168.0.17 | 14 |
| C (SW-C) | 192.168.0.32/28 | 255.255.255.240 | 192.168.0.33 | 14 |
| Área servidores | 192.168.0.48/28 | 255.255.255.240 | 192.168.0.49 | 14 |
| Enlace RTR→SW-PPAL | 192.168.0.64/30 | 255.255.255.252 | — | 2 |

---

## 9. Tabla completa de IP por dispositivo

### Sector A — Máscara: 255.255.255.240 — Gateway: 192.168.0.1

| Dispositivo | IP | Cómo configurar |
|-------------|----|-----------------|
| PC1 | 192.168.0.2 | Desktop → IP Configuration → Static |
| PC2 | 192.168.0.3 | Desktop → IP Configuration → Static |
| PC3 | 192.168.0.4 | Desktop → IP Configuration → Static |
| IMP1 | 192.168.0.5 | Config → FastEthernet0 → Static |
| SW-A | 192.168.0.6 | CLI (o Config → VLAN1 → Static) |

### Sector B — Máscara: 255.255.255.240 — Gateway: 192.168.0.17

| Dispositivo | IP | Cómo configurar |
|-------------|----|-----------------|
| PC4 | 192.168.0.18 | Desktop → IP Configuration → Static |
| PC5 | 192.168.0.19 | Desktop → IP Configuration → Static |
| PC6 | 192.168.0.20 | Desktop → IP Configuration → Static |
| LAP1 | 192.168.0.21 | Desktop → IP Configuration → Static |
| SW-B | 192.168.0.22 | CLI (o Config → VLAN1 → Static) |

### Sector C — Máscara: 255.255.255.240 — Gateway: 192.168.0.33

| Dispositivo | IP | Cómo configurar |
|-------------|----|-----------------|
| PC7 | 192.168.0.34 | Desktop → IP Configuration → Static |
| PC8 | 192.168.0.35 | Desktop → IP Configuration → Static |
| PC9 | 192.168.0.36 | Desktop → IP Configuration → Static |
| PC10 | 192.168.0.37 | Desktop → IP Configuration → Static |
| IMP2 | 192.168.0.38 | Config → FastEthernet0 → Static |
| SW-C | 192.168.0.39 | CLI (o Config → VLAN1 → Static) |

### Área servidores — Máscara: 255.255.255.240 — Gateway: 192.168.0.49

| Dispositivo | IP | Cómo configurar |
|-------------|----|-----------------|
| SRV1 | 192.168.0.50 | Desktop → IP Configuration → Static |
| SRV2 | 192.168.0.51 | Desktop → IP Configuration → Static |
| SRV3 | 192.168.0.52 | Desktop → IP Configuration → Static |
| LAP2 | 192.168.0.53 | Desktop → IP Configuration → Static |
| SW-PRINCIPAL | 192.168.0.54 | CLI (o Config → VLAN1 → Static) |

### Router — Enlace con SW-PRINCIPAL

| Interfaz | IP / Máscara | Conectado a |
|----------|-------------|-------------|
| FastEthernet0/0 | 192.168.0.65 / 255.255.255.252 | SW-PRINCIPAL Gig0/1 |

---

## 10. Configurar cada tipo de dispositivo

### 10.1 PC (PC1 a PC10) — Desktop → IP Configuration

1. Clic en el PC → pestaña **Desktop**
2. Clic en **IP Configuration**
3. Marcar **Static**
4. Escribir IP, Mask (`255.255.255.240`), Gateway (según sector), DNS (`192.168.0.50`)
5. Cerrar

### 10.2 Laptop (LAP1, LAP2) — mismo método + verificar FastEthernet

1. Igual que PC: Desktop → IP Configuration → Static
2. Luego ve a pestaña **Config** → **FastEthernet0** → **Port Status: On**
3. Clic en **Wireless0** → **Port Status: Off**

### 10.3 Servidor (SRV1, SRV2, SRV3) — Desktop → IP Configuration

Mismo método que PC. Usar gateway del área servidores: `192.168.0.49`.

### 10.4 Impresora (IMP1, IMP2) — Config → FastEthernet0 → Static

1. Clic en impresora → pestaña **Config**
2. Columna izquierda → **FastEthernet0**
3. Clic en **Static** y escribir IP, Mask, Gateway según su sector

### 10.5 Switches — CLI (opción recomendada)

Clic en el switch → pestaña **CLI**. Escribe:

#### SW-A:
```
enable
configure terminal
hostname SW-A
interface vlan 1
 ip address 192.168.0.6 255.255.255.240
 no shutdown
end
copy running-config startup-config
```
(Enter en la pregunta)

#### SW-B:
```
enable
configure terminal
hostname SW-B
interface vlan 1
 ip address 192.168.0.22 255.255.255.240
 no shutdown
end
copy running-config startup-config
```

#### SW-C:
```
enable
configure terminal
hostname SW-C
interface vlan 1
 ip address 192.168.0.39 255.255.255.240
 no shutdown
end
copy running-config startup-config
```

#### SW-PRINCIPAL:
```
enable
configure terminal
hostname SW-PRINCIPAL
interface vlan 1
 ip address 192.168.0.54 255.255.255.240
 no shutdown
end
copy running-config startup-config
```

### 10.6 Router RTR-PRINCIPAL — CLI

1. Clic en **RTR-PRINCIPAL** → pestaña **CLI**
2. Escribe:

```
enable
configure terminal
hostname RTR-PRINCIPAL
interface fastEthernet 0/0
 ip address 192.168.0.65 255.255.255.252
 no shutdown
end
copy running-config startup-config
```

(Enter en la pregunta)

**Para que el router pueda llegar a todas las subredes**, agrega una ruta estática:

```
enable
configure terminal
ip route 192.168.0.0 255.255.255.0 192.168.0.66
end
copy running-config startup-config
```

> **Nota:** Como los switches 2960 son L2 (no rutean), para la simulación práctica usa máscara **/24 (255.255.255.0)** en todos los equipos y configura el gateway como `192.168.0.65` (la IP del router). El subnetting real (/28) úsalo solo en el informe del trabajo.

---

## 11. Servicios del servidor (opcional — suma puntos)

Activa servicios en SRV1:

1. Clic en **SRV1** → pestaña **Services**
2. **HTTP** → clic en **On**
3. **DNS** → clic en **On** → Name: `intranet.instituto.cl` → Address: `192.168.0.50` → **Add**
4. **DHCP** → clic en **On** → configurar pool por sector (opcional)

Pruébalo desde cualquier PC: Desktop → **Web Browser** → `http://intranet.instituto.cl`

---

## 12. Probar la red con ping

Desde un PC: Desktop → **Command Prompt** → `ping IP_destino`

| Prueba | Desde | Hacia | Resultado |
|--------|-------|-------|-----------|
| Mismo sector | PC1 (192.168.0.2) | PC3 (192.168.0.4) | ✅ 4 respuestas |
| Entre sectores | PC1 | PC5 (192.168.0.19) | ✅ (con /24) |
| Hacia servidores | PC7 | SRV1 (192.168.0.50) | ✅ |
| Hacia router | PC4 | RTR (192.168.0.65) | ✅ |
| Entre servidores | SRV1 | SRV2 (192.168.0.51) | ✅ |

**⚠️ El primer ping suele fallar (ARP). Repite siempre una segunda vez.**

---

## 13. Capturas para el informe

- **Topología completa**: Ctrl+D → Alt+PrintScreen
- **Configuración IP de 3 equipos** (PC1, LAP1, IMP1)
- **Pings exitosos** (mínimo 3 pruebas)
- **Animación Simulation**: modo Simulation → Edit Filters → solo ICMP → Add Simple PDU → Auto Capture / Play

---

## 14. Rotular

Presiona **N** → clic en el lienzo → escribe texto. Recomendado:
- Nombre de cada sector al lado de su switch
- Nota grande: **"17 puntos terminales. 4 switches. 1 router. UTP Cat6. Topología estrella jerárquica."**

---

## Errores frecuentes

| Problema | Causa | Solución |
|----------|-------|----------|
| Cable rojo entre switches | Cable recto ↔ necesita cruzado | Usar Copper Cross-Over |
| Cable naranjo | STP | Esperar 30 segundos |
| Ping entre sectores falla | Switches L2 no rutean | Usar máscara /24 para simulación |
| Laptop no funciona | WiFi encendido, Ethernet apagado | FastEthernet0 = On, Wireless0 = Off |
| Router no responde | Falta `no shutdown` | Verificar en CLI: `no shutdown` en Fa0/0 |

---

## Resumen rápido

| Acción | Pasos |
|--------|-------|
| Configurar PC/Laptop/Servidor | Desktop → IP Configuration → Static |
| Configurar impresora | Config → FastEthernet0 → Static |
| Configurar switch (CLI) | CLI → `enable` → `configure terminal` → ... |
| Configurar router (CLI) | CLI → `enable` → `configure terminal` → `interface fa0/0` → ... |
| Hacer ping | Desktop → Command Prompt → `ping IP` |
| Activar HTTP/DNS | Clic en servidor → Services → HTTP/DNS → On |
| Rotular | Presionar N → clic → escribir |
