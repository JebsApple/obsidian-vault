# Instrucciones — Simulación en Cisco Packet Tracer (Caso 05)

Topología: **estrella jerárquica segmentada** — 3 switches de acceso → 1 switch principal. 18 puntos terminales. Una sola red plana 192.168.10.0/24 (las VLAN se mencionan solo como mejora futura en el informe).

---

## Paso 1 — Crear el proyecto

1. Abrir Packet Tracer → File → New. Guardar de inmediato como `Caso05_Apellido.pkt`.
2. Activar etiquetas: Options → Preferences → marcar *Always Show Port Labels*.

## Paso 2 — Agregar dispositivos

Desde la bandeja inferior (categoría → modelo), colocar y **renombrar** (clic en el nombre bajo el ícono):

| Categoría PT | Modelo | Cantidad | Nombres |
|---|---|---|---|
| Network Devices → Switches | 2960-24TT | 1 | SW-PRINCIPAL |
| Network Devices → Switches | 2960-24TT | 3 | SW-A, SW-B, SW-C |
| End Devices | PC-PT | 8 | PC1 … PC8 |
| End Devices | Laptop-PT | 3 | LAP1, LAP2, LAP3 |
| End Devices | Printer-PT | 4 | IMP1, IMP2, IMP3, MFP (multifuncional) |
| End Devices | Server-PT | 1 | SRV |
| End Devices | IP Phone (7960) | 1 | TEL-IP |
| End Devices | PC-PT (o TV si tu versión la trae) | 1 | TV-CORP |

Distribuir en el lienzo imitando la imagen del caso: 3 sectores a la izquierda (arriba, centro, abajo) y área técnica a la derecha (SW-PRINCIPAL abajo a la derecha).

> TEL-IP: el 7960 requiere alimentación — en su pestaña *Physical*, arrastrar el **adaptador de corriente** al conector del teléfono.

## Paso 3 — Asignación de puntos por sector

| Sector | Switch | Dispositivos (4 c/u) |
|---|---|---|
| A (superior) | SW-A | PC1, PC2, PC3, IMP1 |
| B (central) | SW-B | PC4, PC5, LAP1, LAP2 |
| C (inferior) | SW-C | PC6, PC7, PC8, IMP2 |
| Área técnica | SW-PRINCIPAL | SRV, MFP, TEL-IP, TV-CORP, LAP3, IMP3 (6 puntos) |

Total: 12 + 6 = **18 puntos terminales** ✔

## Paso 4 — Cableado

Usar Connections (rayo):

1. **Cobre directo (Copper Straight-Through):** cada dispositivo final → FastEthernet0/x de su switch. Usar puertos Fa0/1–Fa0/4 en switches de acceso y Fa0/1–Fa0/6 en SW-PRINCIPAL.
2. **Enlaces entre switches (los 3 enlaces de 28 m del caso):** SW-A, SW-B y SW-C → SW-PRINCIPAL usando los puertos **GigabitEthernet0/1** de cada switch de acceso hacia **Gig0/1, Gig0/2 y Fa0/24** (o Gig0/1–0/2 y un Fa libre) del principal. Si el enlace queda rojo, cambiar a **Copper Cross-Over**.
3. Esperar a que todos los puntos de enlace queden **verdes** (STP tarda ~30 s).

## Paso 5 — Direccionamiento IP (estático)

Red 192.168.10.0/24 · Máscara 255.255.255.0 · Gateway 192.168.10.1 (referencial).
En cada dispositivo: Desktop → IP Configuration → Static.

| Dispositivo | IP |
|---|---|
| SRV | 192.168.10.10 |
| PC1–PC8 | 192.168.10.11 – 192.168.10.18 |
| LAP1–LAP3 | 192.168.10.21 – 23 |
| IMP1–IMP3 | 192.168.10.31 – 33 (pestaña Config → FastEthernet0) |
| MFP | 192.168.10.34 |
| TV-CORP | 192.168.10.40 |
| TEL-IP | 192.168.10.50 (Config → Interface) |

Administración de switches (opcional, recomendado para nota): en cada switch, pestaña CLI:

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

(Repetir con .3, .4, .5 en SW-A/B/C y su hostname.)

## Paso 6 — Servicios en el servidor (opcional, suma calidad)

SRV → Services: activar **HTTP** (simula intranet) y **DNS** (registro `intranet.oficina.cl → 192.168.10.10`). Luego desde un PC: Desktop → Web Browser → `192.168.10.10`.

## Paso 7 — Pruebas de conectividad (evidencias obligatorias)

Desde Desktop → Command Prompt:

| Prueba | Comando | Resultado esperado |
|---|---|---|
| PC de sector A a servidor | PC1: `ping 192.168.10.10` | 4 respuestas |
| Entre sectores | PC4: `ping 192.168.10.16` (PC6) | 4 respuestas |
| A impresora | PC8: `ping 192.168.10.31` (IMP1) | 4 respuestas |
| Área técnica | LAP3: `ping 192.168.10.40` (TV) | 4 respuestas |
| Teléfono IP | SRV: `ping 192.168.10.50` | 4 respuestas |

Extra: modo **Simulation** → enviar un PDU simple de PC1 a SRV y capturar el recorrido PC1 → SW-A → SW-PRINCIPAL → SRV (demuestra la jerarquía).

> El primer ping puede perder 1 paquete por ARP; repetir el comando.

## Paso 8 — Rotulación y evidencias

1. Con la herramienta **Place Note (N)**, rotular sectores: "Sector A – 4 puntos", "Rack principal – 6 puntos", y los 3 enlaces troncales "Enlace 28 m Cat6".
2. Capturas para el informe/anexos: topología completa, IP Configuration de 2–3 equipos, cada ping exitoso, recorrido en modo Simulation.
3. Guardar el `.pkt` final.

> Nota para el informe: Packet Tracer no modela longitudes de cable; las distancias (10 m, 16 m, 28 m, total 360 m) se documentan en el cálculo del informe y en las notas del lienzo.

## Errores frecuentes

Enlace rojo entre switches → usar Cross-Over. Ping falla → revisar máscara 255.255.255.0 y que la IP no esté duplicada. Teléfono apagado → falta adaptador de corriente en Physical. Puertos naranjos → esperar STP.
