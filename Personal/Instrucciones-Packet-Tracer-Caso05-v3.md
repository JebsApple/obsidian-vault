# Instrucciones — Simulación Packet Tracer (Caso 05) — v3

> Topología: **estrella jerárquica segmentada** — 3 switches de acceso conectados a 1 switch principal. 18 puntos terminales. **Una sola red plana `192.168.10.0/24`** (sin subredes ni VLANs: el informe las declara como *mejora futura*, así que la simulación NO debe implementarlas).

> ⚠️ **Nota v3 — por qué se descartó la versión con VLANs/subredes:** circulaba una versión de este instructivo que dividía la red en subredes /29 por sector con VLANs y router-on-a-stick. Esa configuración **contradice el informe** (que describe una red plana con VLAN/PoE como mejoras de segunda etapa, sección de análisis) y agrega horas de configuración innecesaria. Esta v3 es la versión coherente con el informe entregado.

---

## ✔ Estado actual (según tu avance del 04-07-2026)

Ya completaste:

- [x] Proyecto creado (`Caso05_Herrera_Soncco.pkt`)
- [x] 4 switches (SW-PRINCIPAL, SW-A, SW-B, SW-C) + 18 terminales colocados
- [x] Teléfono **7960 real** conectado (mejor que simularlo con PC — mantenlo así)
- [x] Todo el cableado hecho, enlaces verdes

Lo que falta, en orden:

- [ ] **A.** IPs estáticas en los 17 equipos configurables
- [ ] **B.** IP de gestión en los 4 switches (opcional, suma nota)
- [ ] **C.** Router R-BORDE (DHCP + telefonía para el TEL-IP) ← **lo del router**
- [ ] **D.** Verificar registro del teléfono
- [ ] **E.** Servicios HTTP/DNS en SRV (opcional, suma nota)
- [ ] **F.** Pings de prueba + capturas

---

## A. Asignar IPs estáticas (17 equipos)

**Plan de direccionamiento (red plana):** máscara `255.255.255.0` en TODO, gateway `192.168.10.1` en TODO (será la IP del router), DNS `192.168.10.10` (el SRV).

| Dispositivo | IP | ¿Dónde se configura? |
|---|---|---|
| SRV | 192.168.10.10 | Desktop → IP Configuration |
| PC-1 … PC-8 | 192.168.10.11 … 192.168.10.18 | Desktop → IP Configuration |
| LAP-1 … LAP-3 | 192.168.10.21 … 192.168.10.23 | Desktop → IP Configuration |
| IMP-1 … IMP-3 | 192.168.10.31 … 192.168.10.33 | Config → FastEthernet0 → Static |
| MFP | 192.168.10.34 | Config → FastEthernet0 → Static |
| TV-CORP | 192.168.10.40 | Desktop → IP Configuration |
| TEL-IP | 192.168.10.50 — **NO se configura a mano** | La entrega el router por DHCP (sección C) |

### A.1 PC, Laptop, Servidor y TV-CORP (13 equipos)

1. Clic en el equipo → pestaña **Desktop** → **IP Configuration**
2. Marcar **Static** (por defecto está en DHCP)
3. Llenar: **IPv4 Address** según tabla · **Subnet Mask** `255.255.255.0` · **Default Gateway** `192.168.10.1` · **DNS Server** `192.168.10.10`
4. Cerrar la ventana (se guarda solo)

**Extra solo para laptops:** pestaña **Config** → verificar **FastEthernet0 = Port Status On** y **Wireless0 = Off**. Si el WiFi no se apaga desde Config, hazlo desde Physical con el botón físico.

### A.2 Impresoras y MFP (4 equipos — no tienen Desktop)

1. Clic en la impresora → pestaña **Config**
2. Columna izquierda → **FastEthernet0**
3. En IP Configuration marcar **Static** → IP según tabla, máscara `255.255.255.0`
4. En la columna izquierda, clic en **Settings** (arriba) → campo **Gateway/DNS** → Static → Gateway `192.168.10.1`
5. Cerrar

### A.3 TEL-IP — solo el adaptador de corriente

Si aún no lo hiciste: clic en TEL-IP → **Physical** → arrastrar el **adaptador de corriente** (cubo negro, abajo a la derecha del área) al **puerto redondo** trasero → la pantalla se enciende. La IP la recibirá sola cuando exista el router (sección C). Verifica también que el cable esté en el puerto **"Switch"** del teléfono, no en "PC".

---

## B. IP de gestión de los switches (opcional, recomendado)

Clic en cada switch → pestaña **CLI** → Enter hasta ver `Switch>` → pegar:

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

(Enter cuando pregunte el nombre de archivo.) Repetir cambiando hostname e IP: **SW-A → .3**, **SW-B → .4**, **SW-C → .5**.

---

## C. Router R-BORDE — DHCP + telefonía para el TEL-IP ★

**¿Por qué un router si la red es plana?** No es para enrutar (todo está en la misma red): es porque el 7960 de Packet Tracer **no acepta IP manual** — solo obtiene IP por DHCP y necesita registrarse contra un **Call Manager Express (CME)**, y ambas cosas viven en un router. El enunciado lo permite: *"Router o equipo de borde… si el diseño lo requiere"* (secciones 5 y 6 del caso) — y aquí lo requiere el servicio de telefonía IP (sección 7.3). **No se cotiza**, por instrucción del docente.

### C.1 Agregar y conectar el router

1. Barra izquierda → **Network Devices** → **Routers** → buscar **2811** → arrastrarlo al lienzo, cerca de SW-PRINCIPAL
2. Renombrarlo: clic en el nombre bajo el ícono → escribir `R-BORDE`
3. Cablear con **Copper Straight-Through**: **R-BORDE FastEthernet0/0** → **SW-PRINCIPAL FastEthernet0/7** (un puerto libre; tus Fa0/1–0/6 ya están ocupados por el área técnica)
4. El enlace queda rojo unos segundos hasta que configures `no shutdown` en C.2 — es normal

### C.2 Configuración completa (pegar todo en la CLI del router)

Clic en R-BORDE → pestaña **CLI** → si pregunta *"Continue with configuration dialog?"* escribir `no` + Enter → luego pegar completo:

```
enable
configure terminal
hostname R-BORDE
interface FastEthernet0/0
 ip address 192.168.10.1 255.255.255.0
 no shutdown
exit
ip dhcp excluded-address 192.168.10.1 192.168.10.49
ip dhcp excluded-address 192.168.10.51 192.168.10.254
ip dhcp pool VOZ
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 option 150 ip 192.168.10.1
exit
telephony-service
 max-ephones 1
 max-dn 1
 ip source-address 192.168.10.1 port 2000
 auto assign 1 to 1
exit
ephone-dn 1
 number 100
end
copy running-config startup-config
```

(Enter cuando pregunte el nombre de archivo.)

### C.3 Qué hace cada bloque (para la defensa)

| Bloque | Función |
|---|---|
| `interface Fa0/0 … ip address 192.168.10.1` | El router toma la puerta de enlace `.1` — la misma que ya pusiste en todos los equipos, así nada cambia |
| `ip dhcp excluded-address …` | Excluye TODAS las IPs excepto la `.50` → el único cliente DHCP (el teléfono) recibe **exactamente 192.168.10.50**, respetando tu plan de IPs |
| `option 150 ip 192.168.10.1` | Le dice al teléfono dónde está el servidor TFTP/CME para descargar su configuración |
| `telephony-service` + `ephone-dn` | El Call Manager Express: registra el teléfono y le asigna la **línea 100** |
| `auto assign 1 to 1` | Asigna la línea automáticamente — no necesitas escribir la MAC del teléfono |

---

## D. Verificar el teléfono

1. Esperar **~1 minuto** después de la configuración (el teléfono pide IP, baja su config por TFTP y se registra)
2. Pasar el cursor sobre TEL-IP (sin clic): debe mostrar **IP 192.168.10.50**
3. La pantalla del teléfono debe mostrar la **línea 100** registrada
4. Desde SRV: Desktop → Command Prompt → `ping 192.168.10.50` → 4 respuestas

**Si no registra:** ¿adaptador de corriente puesto? ¿cable en el puerto "Switch" del teléfono? ¿enlace router–switch verde? Si todo eso está bien, esperar otro minuto y repetir el ping (el primer intento suele perder 1 paquete por ARP).

---

## E. Servicios en SRV (opcional, suma calidad)

1. Clic en **SRV** → pestaña **Services** → **HTTP** → **On**
2. **DNS** → **On** → Name: `intranet.oficina.cl` → Address: `192.168.10.10` → **Add**
3. Probar desde PC-1: Desktop → **Web Browser** → `http://intranet.oficina.cl` → debe cargar la página

---

## F. Pruebas de conectividad (evidencias obligatorias)

Desde Desktop → Command Prompt del equipo indicado:

| Prueba | Comando | Resultado esperado |
|---|---|---|
| Sector A → servidor | PC-1: `ping 192.168.10.10` | 4 respuestas |
| Entre sectores (B→C) | PC-4: `ping 192.168.10.16` (PC-6) | 4 respuestas |
| Sector C → impresora A | PC-8: `ping 192.168.10.31` (IMP-1) | 4 respuestas |
| Área técnica | LAP-3: `ping 192.168.10.40` (TV-CORP) | 4 respuestas |
| Multifuncional | SRV: `ping 192.168.10.34` (MFP) | 4 respuestas |
| **Teléfono IP** | SRV: `ping 192.168.10.50` | 4 respuestas |
| Registro telefónico | Pantalla del TEL-IP con línea 100 | Captura |

Si el primer ping pierde 1 paquete, repítelo — es el ARP inicial, no un error.

**Extra (modo Simulation):** botón **Simulation** (abajo a la derecha) → Edit Filters → solo **ICMP** → Add Simple PDU → clic PC-1, clic SRV → Play. Captura el recorrido PC-1 → SW-A → SW-PRINCIPAL → SRV: demuestra la jerarquía.

---

## G. Rotulación y capturas finales

Con **Place Note (N)**, rotular: "Sector A – 4 puntos", "Sector B – 4 puntos", "Sector C – 4 puntos", "Rack principal – 6 puntos", los 3 enlaces troncales "Enlace 28 m Cat6", y una nota general: **"Diseño según tabla del enunciado Caso 05: 18 puntos terminales, red plana 192.168.10.0/24. Router de borde para DHCP/telefonía (§5-§6 del enunciado), no cotizado."**

Capturas para los anexos: topología completa (View → Zoom to Fit), IP Configuration de 2–3 equipos, cada ping exitoso, pantalla del teléfono registrado, recorrido en Simulation. Guardar el `.pkt`.

> Packet Tracer no modela longitudes de cable: las distancias (10 m, 16 m, 28 m, total 360 m) viven en el cálculo del informe y en las notas del lienzo.

---

## Errores frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Enlace rojo entre switches | Cable recto donde va cruzado | Borrar y usar **Copper Cross-Over** |
| Enlace router–switch rojo | Falta `no shutdown` | Ejecutar la CLI de C.2 completa |
| Cable naranjo | STP detectando bucles | Esperar 30 s, se pone verde solo |
| Ping falla | Máscara distinta de 255.255.255.0 o IP duplicada | Revisar IP Configuration del origen y destino |
| TEL-IP sin IP | Adaptador de corriente sin poner, o router sin configurar | Physical → adaptador; luego sección C |
| TEL-IP con IP pero sin línea | Falta `option 150` o `telephony-service` | Repasar C.2; esperar 1 min |
| Laptop no conecta | WiFi On, Ethernet Off | FastEthernet0 = On, Wireless0 = Off |
| Primer ping pierde 1 paquete | ARP inicial | Repetir el ping |

---

## Registro de cambios

### v3 (04-07-2026)
- Se descarta la variante con VLANs/subredes /29 y router-on-a-stick por contradecir el informe (red plana; VLANs solo como mejora futura) y agregar complejidad innecesaria.
- Instructivo reordenado según el avance real: dispositivos y cableado ya completos; foco en IPs, router y pruebas.
- Sección C (router R-BORDE) con configuración de una sola pegada: DHCP con exclusiones que entrega exactamente la .50 al teléfono + CME con línea 100 y `auto assign` (sin necesidad de MAC).
- Nombres alineados al lienzo real (PC-1…PC-8, IMP-1…IMP-3, LAP-1…LAP-3) y teléfono 7960 real (no PC-PT).
