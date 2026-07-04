# Instrucciones — Simulación en Cisco Packet Tracer (Caso 05) — v2

Topología: **estrella jerárquica segmentada** — 3 switches de acceso → 1 switch principal. 18 puntos terminales. Red 192.168.10.0/24 **subneteada por sector** según hosts reales (bits robados exactos).

> ⚠️ La imagen referencial del caso y la tabla del enunciado **no coinciden**: la imagen muestra 19 puntos, el enunciado define 18. La simulación se construye **según la tabla del profesor**.

---

## 1. Crear proyecto
- **File → New**, guardar como `Caso05_Herrera_Soncco.pkt`
- **Options → Preferences →** marcar *Always Show Port Labels*

## 2. Agregar dispositivos

| Categoría PT               | Modelo        | Cant. | Nombres          |
| -------------------------- | ------------- | ----- | ---------------- |
| Network Devices → Switches | 2960-24TT     | 1     | SW-PRINCIPAL     |
| Network Devices → Switches | 2960-24TT     | 3     | SW-A, SW-B, SW-C |
| End Devices                | PC-PT         | 8     | PC1 a PC8        |
| End Devices                | Laptop-PT     | 3     | LAP1, LAP2, LAP3 |
| End Devices                | Printer-PT    | 3     | IMP1, IMP2, IMP3 |
| End Devices                | Printer-PT    | 1     | MFP              |
| End Devices                | Server-PT     | 1     | SRV              |
| End Devices                | IP Phone 7960 | 1     | TEL-IP           |
| End Devices                | PC-PT         | 1     | TV-CORP          |

Total: **18 puntos terminales** ✔

## 3. ⚡ Encender TEL-IP (error #1 del caso)
El IP Phone 7960 **aparece apagado por defecto**. No responderá ping sin esto:
1. Clic en TEL-IP → pestaña **Physical**
2. Abajo a la derecha hay un **cubo negro con cable** (adaptador de corriente)
3. **Arrastrarlo** al **puerto redondo** del panel trasero del teléfono
4. La pantalla debe iluminarse — si no, repetir el arrastre
5. Al cablear, usar el puerto RJ45 etiquetado **"Switch"** (no "PC")
6. IP: **Config → Interface** → Static → `192.168.10.28 /255.255.255.240` (subred área técnica)

## 4. Distribución en el lienzo

| Sector | Switch | Dispositivos |
|---|---|---|
| A (superior) | SW-A | PC1, PC2, PC3, IMP1 |
| B (central) | SW-B | PC4, PC5, LAP1, LAP2 |
| C (inferior) | SW-C | PC6, PC7, PC8, IMP2 |
| Área técnica (derecha) | SW-PRINCIPAL | SRV, MFP, TEL-IP, TV-CORP, LAP3, IMP3 |

## 5. Cableado

### 5.1 Dispositivos finales → switch
- Cable: **Copper Straight-Through**
- Puertos: **FastEthernet0/1–0/4** en SW-A/B/C, **Fa0/1–0/6** en SW-PRINCIPAL

### 5.2 Enlaces entre switches (troncales)
- SW-A **Gig0/1** → SW-PRINCIPAL **Gig0/1**
- SW-B **Gig0/1** → SW-PRINCIPAL **Gig0/2**
- SW-C **Gig0/1** → SW-PRINCIPAL **Fa0/24**
- Si el enlace queda **rojo** → cambiar a **Copper Cross-Over**
- Si queda **naranjo** → esperar ~30s (STP)

## 6. Diseño de subredes (subnetting con bits robados exactos)

Se parte de `192.168.10.0/24`. Se subnetwork asigna **exactamente los hosts que cada sector necesita**, sin desperdicio.

### 6.0 Cálculo de subredes

| Sector | Hosts | Máscara | Bits robados | Prefijo | Red | Broadcast | Rango útil |
|---|---|---|---|---|---|---|---|
| A (SW-A) | 4 | 255.255.255.248 | 3 → /29 | .0/29 | .0 | .7 | .1 – .6 |
| B (SW-B) | 4 | 255.255.255.248 | 3 → /29 | .8/29 | .8 | .15 | .9 – .14 |
| C (SW-C) | 4 | 255.255.255.248 | 3 → /29 | .16/29 | .16 | .23 | .17 – .22 |
| Área técnica (SW-PPAL) | 6 | 255.255.255.240 | 4 → /28 | .24/28 | .24 | .39 | .25 – .38 |
| Enlace SA ↔ PPAL | 2 | 255.255.255.252 | 6 → /30 | .40/30 | .40 | .43 | .41 – .42 |
| Enlace SB ↔ PPAL | 2 | 255.255.255.252 | 6 → /30 | .44/30 | .44 | .47 | .45 – .46 |
| Enlace SC ↔ PPAL | 2 | 255.255.255.252 | 6 → /30 | .48/30 | .48 | .51 | .49 – .50 |

### 6.1 Asignación por subred

#### Sector A — SW-A (192.168.10.0/29)
Máscara: `255.255.255.248` — Gateway: `192.168.10.1`
| Dispositivo | IP | Puerto SW-A |
|---|---|---|
| PC1 | .2 | Fa0/1 |
| PC2 | .3 | Fa0/2 |
| PC3 | .4 | Fa0/3 |
| IMP1 | .5 | Fa0/4 |
| SW-A (mgmt) | .6 | — |

#### Sector B — SW-B (192.168.10.8/29)
Máscara: `255.255.255.248` — Gateway: `192.168.10.9`
| Dispositivo | IP | Puerto SW-B |
|---|---|---|
| PC4 | .10 | Fa0/1 |
| PC5 | .11 | Fa0/2 |
| LAP1 | .12 | Fa0/3 |
| LAP2 | .13 | Fa0/4 |
| SW-B (mgmt) | .14 | — |

#### Sector C — SW-C (192.168.10.16/29)
Máscara: `255.255.255.248` — Gateway: `192.168.10.17`
| Dispositivo | IP | Puerto SW-C |
|---|---|---|
| PC6 | .18 | Fa0/1 |
| PC7 | .19 | Fa0/2 |
| PC8 | .20 | Fa0/3 |
| IMP2 | .21 | Fa0/4 |
| SW-C (mgmt) | .22 | — |

#### Área técnica — SW-PRINCIPAL (192.168.10.24/28)
Máscara: `255.255.255.240` — Gateway: `192.168.10.25`
| Dispositivo | IP | Puerto SW-PPAL |
|---|---|---|
| SRV | .26 | Fa0/1 |
| MFP | .27 | Fa0/2 |
| TEL-IP | .28 | Fa0/3 |
| TV-CORP | .29 | Fa0/4 |
| LAP3 | .30 | Fa0/5 |
| IMP3 | .31 | Fa0/6 |
| SW-PPAL (mgmt) | .32 | — |

#### Enlaces entre switches (punto a punto /30)
| Enlace | Subred | IP SW-A/B/C | IP SW-PRINCIPAL |
|---|---|---|---|
| SW-A ↔ SW-PRINCIPAL | 192.168.10.40/30 | .41 | .42 |
| SW-B ↔ SW-PRINCIPAL | 192.168.10.44/30 | .45 | .46 |
| SW-C ↔ SW-PRINCIPAL | 192.168.10.48/30 | .49 | .50 |

> **Nota sobre enlaces:** los switches 2960-24TT son L2, no pueden ruteo entre VLANs. Las IPs de enlace son para gestión/administración. La conectividad entre subredes requiere un router o switch L3 (mejora futura documentada en el informe).

### 6.2 Cómo configurar cada tipo de dispositivo

#### PC (PC1–PC8) y TV-CORP
1. Clic en el dispositivo → pestaña **Desktop**
2. Clic en **IP Configuration**
3. Marcar **Static**
4. IPv4 Address: IP según tabla de su sector
5. Subnet Mask: según su subred (248, 240, etc. — lo dice cada tabla)
6. Default Gateway: según su sector (el .1, .9, .17 o .25)
7. DNS: `192.168.10.26` (SRV, opcional)
8. Cerrar — queda guardado

#### Laptop (LAP1–LAP3)
1. Desktop → **IP Configuration** → Static
2. IP + Máscara + Gateway + DNS (según sector)
3. **Verificar:** Config → **FastEthernet0** prendido, **Wireless0** apagado

#### Servidor (SRV)
1. Desktop → **IP Configuration** → Static
2. IP: `192.168.10.26` · Mask: `255.255.255.240` · Gateway: `192.168.10.25`

#### Impresora y MFP (NO tienen Desktop)
1. Pestaña **Config** → **FastEthernet0** → **Static**
2. IP + Mask + Gateway según sector
3. IMP1: Mask 248 · IMP2: Mask 248 · IMP3: Mask 240 · MFP: Mask 240

#### Teléfono IP (TEL-IP)
1. Pestaña **Config** → **Interface** → **Static**
2. IP: `192.168.10.28` · Mask: `255.255.255.240` · Gateway: `192.168.10.25`

### 6.3 Configurar IPs de enlace en switches (CLI)

Cada switch necesita IP en VLAN 1 para gestión. Los enlaces /30 se configuran así:

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

> **Para la simulación en Packet Tracer:** como los 2960 son L2, los dispositivos dentro de una misma subred se comunican bien, pero **entre subredes distintas no** sin un router. Si en el informe documentas el diseño de subredes y mencionas que la comunicación inter-VLAN queda como mejora futura con router-on-a-stick, es correcto. Para que la simulación funcione end-to-end, puedes configurar todo con la máscara /24 (subred única) y adjuntar el diseño de subredes como anexo del informe.

## 7. Servicios en SRV (opcional, suma calidad)
SRV → Services: activar **HTTP** y **DNS** (`intranet.oficina.cl → 192.168.10.10`). Probar desde un PC: Desktop → Web Browser → `192.168.10.10`.

## 8. Pruebas de conectividad (evidencias obligatorias)

Desde Desktop → Command Prompt:

| Prueba | Comando | Esperado |
|---|---|---|
| PC de sector A al servidor | `ping 192.168.10.10` (PC1) | 4 respuestas |
| Entre sectores | `ping 192.168.10.16` (PC4 → PC6) | 4 respuestas |
| A impresora | `ping 192.168.10.31` (PC8 → IMP1) | 4 respuestas |
| Área técnica | `ping 192.168.10.40` (LAP3 → TV) | 4 respuestas |
| Teléfono IP | `ping 192.168.10.50` (SRV → TEL-IP) | 4 respuestas |

> El primer ping puede perder 1 paquete por ARP — repetir el comando.

Extra: modo **Simulation** → enviar PDU simple de PC1 a SRV y capturar el recorrido (PC1 → SW-A → SW-PRINCIPAL → SRV).

## 9. Rotulación y evidencias
1. Herramienta **Place Note (N)**: rotular sectores, "Enlace 28 m Cat6" en cada troncal, y nota general declarando el criterio de conteo
2. Capturas para el informe: topología completa, IP Config de 2–3 equipos, cada ping exitoso, recorrido Simulation
3. Guardar `.pkt` final

## Errores frecuentes
- **Enlace rojo** entre switches → usar **Cross-Over**
- **Ping falla** → revisar máscara `255.255.255.0` e IP duplicada
- **TEL-IP no responde** → falta adaptador de corriente en **Physical**
- **Puertos naranjos** → esperar ~30s (STP)

---

## Registro de cambios

### v2.2 (04-07-2026)
- Sección 6 expandida con subsecciones por tipo de dispositivo (PC, laptop, impresora, servidor, teléfono)
- Instrucciones detalladas paso a paso para cada tipo, incluyendo pestaña exacta a usar
- Advertencia de que impresoras/MFP no tienen Desktop, se configuran en Config → FastEthernet0
- Nota sobre apagar puerto inalámbrico en laptops
- Tabla resumen completa con las 18 IPs ordenadas
- Sección 6.7 con tabla de administración de switches

### v2.1 (04-07-2026)
- Reestructuración completa como instrucciones "a prueba de tontos" con pasos numerados
- Tabla de IPs con columna "Cómo se configura"
- Procedimiento TEL-IP expandido y destacado como advertencia temprana
- Sección de errores frecuentes al final

### v2 (04-07-2026)
- Documentada discrepancia imagen ↔ enunciado (19 vs 18 puntos)
- Se adoptó formalmente la tabla del profesor
- Archivo renombrado a `Caso05_Herrera_Soncco.pkt`
