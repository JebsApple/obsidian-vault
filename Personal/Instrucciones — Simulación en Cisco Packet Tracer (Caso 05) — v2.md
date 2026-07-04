# Instrucciones — Simulación en Cisco Packet Tracer (Caso 05) — v2

Topología: **estrella jerárquica segmentada** — 3 switches de acceso → 1 switch principal. 18 puntos terminales. Red 192.168.10.0/24 **subneteada por sector** según hosts reales (bits robados exactos).

> ⚠️ La imagen referencial del caso y la tabla del enunciado **no coinciden**: la imagen muestra 19 puntos, el enunciado define 18. La simulación se construye **según la tabla del profesor**.

---

## 1. Crear proyecto
- **File → New**, guardar como `Caso05_Herrera_Soncco.pkt`
- **Options → Preferences →** marcar *Always Show Port Labels*

## 2. Agregar dispositivos

| Categoría PT | Modelo | Cant. | Nombres |
|---|---|---|---|
| Network Devices → Switches | 2960-24TT | 1 | SW-PRINCIPAL |
| Network Devices → Switches | 2960-24TT | 3 | SW-A, SW-B, SW-C |
| End Devices | PC-PT | 8 | PC1 a PC8 |
| End Devices | Laptop-PT | 3 | LAP1, LAP2, LAP3 |
| End Devices | Printer-PT | 3 | IMP1, IMP2, IMP3 |
| End Devices | Printer-PT | 1 | MFP |
| End Devices | Server-PT | 1 | SRV |
| End Devices | IP Phone 7960 | 1 | TEL-IP |
| End Devices | PC-PT | 1 | TV-CORP |

Total: **18 puntos terminales**

## 3. Rol de cada dispositivo en la red corporativa

| Dispositivo | Rol en la empresa | Función en la simulación |
|---|---|---|
| PC1–PC8 | Estaciones de trabajo de escritorio (usuarios por sector) | Generan tráfico, prueban conectividad, acceden a servidor |
| LAP1–LAP3 | Equipos portátiles corporativos (usuarios móviles internos) | Misma función que PC pero en formato laptop |
| IMP1–IMP3 | Impresoras de red (una por sector de acceso) | Servicio de impresión compartido por sector |
| MFP | Equipo multifuncional central (impresora + scanner + copiadora) | Servicio de impresión central en área técnica |
| TEL-IP | Teléfono IP corporativo (VoIP) | Servicio de telefonía sobre la red IP |
| SRV | Servidor de intranet corporativa | Provee HTTP (página interna) y DNS (resolución `intranet.oficina.cl`) |
| TV-CORP | Monitor informativo / TV corporativa (visualización en red) | Equipo de despliegue visual conectado a la red (se simula con PC-PT) |
| SW-A/B/C | Switches de acceso secundarios | Concentran los puntos de cada sector y se uplinkean al switch principal |
| SW-PRINCIPAL | Switch principal de concentración (en rack) | Concentra todos los sectores y equipos del área técnica |

## 4. Encender TEL-IP (error #1 del caso)
El IP Phone 7960 **aparece apagado por defecto**. No responderá ping sin esto:
1. Clic en TEL-IP → pestaña **Physical**
2. Abajo a la derecha hay un **cubo negro con cable** (adaptador de corriente)
3. **Arrastrarlo** al **puerto redondo** del panel trasero del teléfono
4. La pantalla debe iluminarse — si no, repetir el arrastre
5. Al cablear, usar el puerto RJ45 etiquetado **"Switch"** (no "PC")
6. IP: **Config → Interface** → Static → `192.168.10.28 /255.255.255.240`

## 5. Distribución en el lienzo

| Sector | Switch | Dispositivos |
|---|---|---|
| A (superior) | SW-A | PC1, PC2, PC3, IMP1 |
| B (central) | SW-B | PC4, PC5, LAP1, LAP2 |
| C (inferior) | SW-C | PC6, PC7, PC8, IMP2 |
| Área técnica (derecha) | SW-PRINCIPAL | SRV, MFP, TEL-IP, TV-CORP, LAP3, IMP3 |

## 6. Cableado

### 6.1 Dispositivos finales → switch
- Cable: **Copper Straight-Through**
- Puertos: **FastEthernet0/1–0/4** en SW-A/B/C, **Fa0/1–0/6** en SW-PRINCIPAL

### 6.2 Enlaces entre switches (troncales)
- SW-A **Gig0/1** → SW-PRINCIPAL **Gig0/1**
- SW-B **Gig0/1** → SW-PRINCIPAL **Gig0/2**
- SW-C **Gig0/1** → SW-PRINCIPAL **Fa0/24**
- Si el enlace queda **rojo** → cambiar a **Copper Cross-Over**
- Si queda **naranjo** → esperar ~30s (STP)

## 7. Diseño de subredes (subnetting con bits robados exactos)

Se parte de `192.168.10.0/24` y se subnetworka asignando **exactamente los hosts que cada sector necesita**, sin desperdicio.

### 7.0 Cálculo de subredes

| Sector | Hosts | Máscara | Bits robados | Red | Broadcast | Rango útil |
|---|---|---|---|---|---|---|
| A (SW-A) | 4 | 255.255.255.248 | 3 bits → /29 | .0/29 | .7 | .1 – .6 |
| B (SW-B) | 4 | 255.255.255.248 | 3 bits → /29 | .8/29 | .15 | .9 – .14 |
| C (SW-C) | 4 | 255.255.255.248 | 3 bits → /29 | .16/29 | .23 | .17 – .22 |
| Área técnica | 6 | 255.255.255.240 | 4 bits → /28 | .24/28 | .39 | .25 – .38 |
| Enlace SA-PPAL | 2 | 255.255.255.252 | 6 bits → /30 | .40/30 | .43 | .41 – .42 |
| Enlace SB-PPAL | 2 | 255.255.255.252 | 6 bits → /30 | .44/30 | .47 | .45 – .46 |
| Enlace SC-PPAL | 2 | 255.255.255.252 | 6 bits → /30 | .48/30 | .51 | .49 – .50 |

### 7.1 Asignación por subred

#### Sector A — SW-A (192.168.10.0/29)
Máscara: `255.255.255.248` — Gateway: `192.168.10.1`

| Dispositivo | Rol | IP | Puerto SW-A | Método |
|---|---|---|---|---|
| PC1 | Estación trabajo | .2 | Fa0/1 | Desktop → IP Config |
| PC2 | Estación trabajo | .3 | Fa0/2 | Desktop → IP Config |
| PC3 | Estación trabajo | .4 | Fa0/3 | Desktop → IP Config |
| IMP1 | Impresora red | .5 | Fa0/4 | Config → FastEthernet0 → Static |
| SW-A (mgmt) | Switch acceso | .6 | — | CLI o Config → VLAN1 |

#### Sector B — SW-B (192.168.10.8/29)
Máscara: `255.255.255.248` — Gateway: `192.168.10.9`

| Dispositivo | Rol | IP | Puerto SW-B | Método |
|---|---|---|---|---|
| PC4 | Estación trabajo | .10 | Fa0/1 | Desktop → IP Config |
| PC5 | Estación trabajo | .11 | Fa0/2 | Desktop → IP Config |
| LAP1 | Portátil | .12 | Fa0/3 | Desktop → IP Config |
| LAP2 | Portátil | .13 | Fa0/4 | Desktop → IP Config |
| SW-B (mgmt) | Switch acceso | .14 | — | CLI o Config → VLAN1 |

#### Sector C — SW-C (192.168.10.16/29)
Máscara: `255.255.255.248` — Gateway: `192.168.10.17`

| Dispositivo | Rol | IP | Puerto SW-C | Método |
|---|---|---|---|---|
| PC6 | Estación trabajo | .18 | Fa0/1 | Desktop → IP Config |
| PC7 | Estación trabajo | .19 | Fa0/2 | Desktop → IP Config |
| PC8 | Estación trabajo | .20 | Fa0/3 | Desktop → IP Config |
| IMP2 | Impresora red | .21 | Fa0/4 | Config → FastEthernet0 → Static |
| SW-C (mgmt) | Switch acceso | .22 | — | CLI o Config → VLAN1 |

#### Área técnica — SW-PRINCIPAL (192.168.10.24/28)
Máscara: `255.255.255.240` — Gateway: `192.168.10.25`

| Dispositivo | Rol | IP | Puerto SW-PPAL | Método |
|---|---|---|---|---|
| SRV | Servidor intranet | .26 | Fa0/1 | Desktop → IP Config |
| MFP | Multifuncional | .27 | Fa0/2 | Config → FastEthernet0 → Static |
| TEL-IP | Teléfono IP | .28 | Fa0/3 | Config → Interface → Static |
| TV-CORP | TV corporativa | .29 | Fa0/4 | Desktop → IP Config |
| LAP3 | Portátil | .30 | Fa0/5 | Desktop → IP Config |
| IMP3 | Impresora red | .31 | Fa0/6 | Config → FastEthernet0 → Static |
| SW-PPAL (mgmt) | Switch principal | .32 | — | CLI o Config → VLAN1 |

#### Enlaces entre switches (punto a punto /30)

| Enlace | Subred | IP SW acceso | IP SW-PRINCIPAL |
|---|---|---|---|
| SW-A ↔ SW-PRINCIPAL | 192.168.10.40/30 | .41 | .42 |
| SW-B ↔ SW-PRINCIPAL | 192.168.10.44/30 | .45 | .46 |
| SW-C ↔ SW-PRINCIPAL | 192.168.10.48/30 | .49 | .50 |

> **Nota sobre enlaces:** los switches 2960-24TT son L2, no soportan ruteo entre VLANs. Las IPs de enlace son para gestión. La conectividad entre subredes requiere un router o switch L3 (mejora futura).

### 7.2 Cómo configurar cada tipo de dispositivo — paso a paso

#### PC (PC1 a PC8) y TV-CORP — solo GUI
**Método: Desktop → IP Configuration**

1. Clic en el dispositivo → pestaña **Desktop**
2. Clic en **IP Configuration**
3. Marcar **Static**
4. IPv4 Address: IP según tabla de su sector
5. Subnet Mask: según su subred (`248` para /29, `240` para /28)
6. Default Gateway: según su sector (`.1`, `.9`, `.17` o `.25`)
7. DNS: `192.168.10.26` (SRV, opcional)
8. Cerrar — queda guardado

#### Laptop (LAP1 a LAP3) — solo GUI
**Método: Desktop → IP Configuration**

1. Desktop → **IP Configuration** → Static
2. IP + Máscara + Gateway + DNS (según sector)
3. Verificar: Config → **FastEthernet0** prendido (verde), **Wireless0** apagado
4. Si Wireless0 está encendido, hacer clic en el botón **Off** (puerto circular) en Physical

#### Servidor (SRV) — solo GUI
**Método: Desktop → IP Configuration**

1. Desktop → **IP Configuration** → Static
2. IP: `192.168.10.26` · Mask: `255.255.255.240` · Gateway: `192.168.10.25`
3. DNS: `192.168.10.26` (se apunta a sí mismo)

#### Impresora y MFP — solo GUI (NO tienen Desktop)
**Método: Config → FastEthernet0 → Static**

1. Clic en IMPx/MFP → pestaña **Config**
2. En la columna izquierda, clic en **FastEthernet0**
3. Marcar **Static** (arriba)
4. IP + Mask + Gateway según sector
5. IMP1 (A): Mask `248` · IMP2 (C): Mask `248` · IMP3: Mask `240` · MFP: Mask `240`

#### Teléfono IP (TEL-IP) — solo GUI
**Método: Config → Interface → Static**

1. Clic en TEL-IP → pestaña **Config**
2. En columna izquierda, clic en **Interface**
3. Marcar **Static**
4. IP: `192.168.10.28` · Mask: `255.255.255.240` · Gateway: `192.168.10.25`

#### Switch (SW-A, SW-B, SW-C, SW-PRINCIPAL) — dos métodos

**Opción A — GUI (Config → VLAN 1):**
1. Clic en switch → pestaña **Config**
2. Columna izquierda → **VLAN 1** (dentro de INTERFACE)
3. Marcar **Static**
4. Ingresar IP + Mask según tabla
5. Clic en **FastEthernet0/1–24** uno por uno → **Port Status: On** (no son POE pero deben estar activos)

**Opción B — CLI (terminal):**
1. Clic en switch → pestaña **CLI**
2. Escribir comandos Cisco IOS directamente

### 7.3 Configuración CLI completa de switches

**SW-PRINCIPAL:**
```
enable
configure terminal
hostname SW-PRINCIPAL
interface vlan 1
 ip address 192.168.10.32 255.255.255.240
 no shutdown
exit
interface vlan 100
 ip address 192.168.10.42 255.255.255.252
 no shutdown
exit
interface vlan 200
 ip address 192.168.10.46 255.255.255.252
 no shutdown
exit
interface vlan 300
 ip address 192.168.10.50 255.255.255.252
 no shutdown
end
copy running-config startup-config
```

**SW-A (acceso):**
```
enable
configure terminal
hostname SW-A
interface vlan 1
 ip address 192.168.10.6 255.255.255.248
 no shutdown
exit
interface vlan 100
 ip address 192.168.10.41 255.255.255.252
 no shutdown
end
copy running-config startup-config
```

**SW-B:**
```
enable
configure terminal
hostname SW-B
interface vlan 1
 ip address 192.168.10.14 255.255.255.248
 no shutdown
exit
interface vlan 200
 ip address 192.168.10.45 255.255.255.252
 no shutdown
end
copy running-config startup-config
```

**SW-C:**
```
enable
configure terminal
hostname SW-C
interface vlan 1
 ip address 192.168.10.22 255.255.255.248
 no shutdown
exit
interface vlan 300
 ip address 192.168.10.49 255.255.255.252
 no shutdown
end
copy running-config startup-config
```

> **Para la simulación en Packet Tracer:** como los 2960 son L2, los dispositivos dentro de una misma subred se comunican bien, pero **entre subredes distintas no** sin un router. Para que la simulación funcione end-to-end, configura todo con máscara /24 (subred única) y adjunta el diseño de subredes como anexo del informe.

### 7.4 Método alternativo — configurar switches desde un PC por CLI

En Packet Tracer puedes también acceder vía **telnet** desde cualquier PC si tienes IP de gestión:
1. En PC → Desktop → **Terminal** (o **Command Prompt**)
2. `telnet 192.168.10.6` (SW-A), `telnet 192.168.10.14` (SW-B), etc.
3. Credenciales: si no hay, entra directo
4. Mismos comandos que en la CLI directa del switch

## 8. Servicios en SRV (opcional, suma calidad)
1. Clic en SRV → pestaña **Services**
2. **HTTP**: clic **On**
3. **DNS**: clic **On**
4. Agregar registro **A**: `intranet.oficina.cl` → `192.168.10.26`
5. **DNS**: agregar también `intranet` → `192.168.10.26`
6. Probar: desde PC → Desktop → **Web Browser** → `intranet.oficina.cl`

## 9. Pruebas de conectividad (evidencias obligatorias)

Desde Desktop → Command Prompt:

| Prueba | Comando | Esperado |
|---|---|---|
| PC sector A al servidor | PC1: `ping 192.168.10.26` | 4 respuestas |
| Entre sectores (B a C) | PC4: `ping 192.168.10.18` (PC6) | 4 respuestas |
| A impresora (C a A) | PC8: `ping 192.168.10.5` (IMP1) | 4 respuestas |
| Área técnica | LAP3: `ping 192.168.10.29` (TV) | 4 respuestas |
| Teléfono IP | SRV: `ping 192.168.10.28` | 4 respuestas |

> Si usas subredes separadas, los pings entre subredes fallarán (L2 switches no rutean). Usa /24 en todos para la simulación práctica y subnetting en el informe.

> El primer ping puede perder 1 paquete por ARP — repetir el comando.

Extra: modo **Simulation** → enviar PDU simple de PC1 a SRV y capturar el recorrido (PC1 → SW-A → SW-PRINCIPAL → SRV).

## 10. Rotulación y evidencias
1. Herramienta **Place Note (N)**: rotular sectores, "Enlace 28 m Cat6" en cada troncal, y nota general declarando el criterio de conteo
2. Capturas para el informe: topología completa, IP Config de 2–3 equipos, cada ping exitoso, recorrido Simulation
3. Guardar `.pkt` final

## Errores frecuentes
- **Enlace rojo** entre switches → usar **Cross-Over**
- **Ping falla entre sectores** → los L2 switches no rutean. Solución: /24 plana en PT y subnetting en el informe
- **Máscara incorrecta** → cada subred tiene su propia máscara (/29 = 248, /28 = 240, /30 = 252). No poner 255.255.255.0 en todas
- **Gateway equivocado** → cada subred tiene su propio gateway (.1, .9, .17, .25)
- **TEL-IP no responde** → falta adaptador de corriente en **Physical**
- **Puertos naranjos** → esperar ~30s (STP)
- **Laptop no responde ping** → verificar que FastEthernet0 esté encendido y Wireless0 esté apagado

---

## Registro de cambios

### v2.3 (04-07-2026)
- Agregada sección "Rol de cada dispositivo en la red corporativa"
- Agregada columna "Método" en tablas de asignación IP por sector
- Expandida sección de configuración con método específico (GUI vs CLI) para cada tipo de dispositivo
- Agregada subsección "Método alternativo — configurar switches desde un PC por CLI (telnet)"
- Agregada nota sobre apagar Wireless0 en laptops
- Agregados roles claros: estación trabajo, portátil, impresora red, multifuncional, VoIP, servidor, TV corporativa

### v2.2 (04-07-2026)
- Subnetting completo con bits robados exactos según hosts reales por sector
- Cálculo de subredes: Sector A/B/C a /29, Área técnica a /28, Enlaces a /30
- Tabla de subredes con red, broadcast, rango útil
- Secciones reorganizadas por subred con máscara, gateway y puertos físicos
- IPs de enlaces entre switches (/30) documentadas
- Nota técnica sobre limitación L2 de switches 2960 y recomendación /24 para PT práctico
- Tabla de configuración CLI completa para IPs de gestión y enlaces en switches
- Pruebas de conectividad actualizadas con nuevas IPs

### v2.1 (04-07-2026)
- Reestructuración completa como instrucciones "a prueba de tontos" con pasos numerados
- Tabla de IPs con columna "Cómo se configura"
- Procedimiento TEL-IP expandido y destacado como advertencia temprana
- Sección de errores frecuentes al final

### v2 (04-07-2026)
- Documentada discrepancia imagen versus enunciado (19 vs 18 puntos)
- Se adoptó formalmente la tabla del profesor
- Archivo renombrado a `Caso05_Herrera_Soncco.pkt`
