# Instrucciones — Simulación en Cisco Packet Tracer (Caso 05) — v2

Topología: **estrella jerárquica segmentada** — 3 switches de acceso → 1 switch principal. 18 puntos terminales. Una sola red plana 192.168.10.0/24.

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
6. IP: **Config → Interface** → Static → `192.168.10.50 /24`

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

## 6. Direccionamiento IP (estático)

Red: `192.168.10.0/24` — Máscara: `255.255.255.0` — Gateway: `192.168.10.1`

| Dispositivo | IP | Cómo se configura |
|---|---|---|
| SRV | .10 | Desktop → IP Configuration → Static |
| PC1–PC8 | .11 – .18 | Ídem |
| LAP1–LAP3 | .21 – .23 | Ídem |
| IMP1–IMP3 | .31 – .33 | Config → FastEthernet0 |
| MFP | .34 | Config → FastEthernet0 |
| TV-CORP | .40 | Desktop → IP Configuration → Static |
| TEL-IP | .50 | Config → Interface → Static |

### IPs de administración de switches (opcional, suma nota)
En cada switch, pestaña CLI:
```
enable
configure terminal
hostname SW-PRINCIPAL
interface vlan 1
 ip address 192.168.10.2 255.255.255.0
 no shutdown
end
copy running-config startup-config
```
Repetir con .3, .4, .5 en SW-A/B/C y su hostname.

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

### v2.1 (04-07-2026)
- Reestructuración completa como instrucciones "a prueba de tontos" con pasos numerados
- Tabla de IPs con columna "Cómo se configura"
- Procedimiento TEL-IP expandido y destacado como advertencia temprana
- Sección de errores frecuentes al final

### v2 (04-07-2026)
- Documentada discrepancia imagen ↔ enunciado (19 vs 18 puntos)
- Se adoptó formalmente la tabla del profesor
- Archivo renombrado a `Caso05_Herrera_Soncco.pkt`
