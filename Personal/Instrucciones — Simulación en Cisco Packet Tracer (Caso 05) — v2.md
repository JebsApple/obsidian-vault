# Instrucciones — Simulación en Cisco Packet Tracer (Caso 05)

> Topología: **estrella jerárquica segmentada** — 3 switches de acceso conectados a 1 switch principal. Total: 18 equipos finales (puntos terminales). Red `192.168.10.0/24` dividida en subredes por sector.

---

## 0. Antes de empezar

Vas a construir esta red:

```
 PC1 ─┐                  ┌─ SRV
 PC2 ─┤                  ├─ MFP
 PC3 ─┤   ┌──────────┐   ├─ TEL-IP
 IMP1 ─┴───┤  SW-A    ├───┤─ TV-CORP
           └────┬─────┘   ├─ LAP3
                │         └─ IMP3
 PC4 ─┐        │         ┌───────┐
 PC5 ─┤   ┌────┴─────┐   │       │
 LAP1 ─┴───┤  SW-B    ├───┤  SW-  │
 LAP2 ─┘   └────┬─────┘   │ PRIN- │
                │         │ CIPAL │
 PC6 ─┐        │         │       │
 PC7 ─┤   ┌────┴─────┐   └───────┘
 PC8 ─┤   │          │
 IMP2 ─┴───┤  SW-C    │
           └──────────┘
```

- **SW-A, SW-B, SW-C** son switches de acceso (concentran equipos de su sector)
- **SW-PRINCIPAL** es el switch central (recibe a todos los sectores + área técnica)

---

## 1. Crear el proyecto

1. Abre **Cisco Packet Tracer**
2. Arriba a la izquierda → menú **File** → clic **New**
3. Menú **File** → **Save As...**
4. En la ventana que aparece, escribe: `Caso05_Herrera_Soncco.pkt`
5. Clic en **Save**

---

## 2. Configurar Packet Tracer para que muestre los puertos

1. Arriba → menú **Options** → clic **Preferences**
2. En la ventana que se abre, pestaña **Interface**
3. Busca la opción **Always Show Port Labels** y márcala (clic en el cuadrito)
4. Clic en el botón **OK** (abajo a la derecha)

Ahora cuando pases el mouse por un dispositivo o lo conectes, verás el nombre del puerto (Fa0/1, Gig0/1, etc.)

---

## 3. Agregar los switches (primero los switches)

A la izquierda de la pantalla hay una barra con íconos. El tercer ícono (de arriba hacia abajo) tiene forma de router o switch → se llama **Network Devices**.

### SW-PRINCIPAL (1 unidad)

1. Clic en el ícono **Network Devices** (tercero desde arriba)
2. Aparece una fila con subcategorías. Clic en **Switches**
3. Se despliega una lista de modelos. Busca **2960-24TT** (puedes escribir 2960 en el buscador)
4. Arrástralo al lienzo (zona blanca grande del centro)
5. Verás un switch con 24 puertos FastEthernet (abajo) y 2 puertos Gigabit (arriba)
6. Aparece con el nombre `Switch0` por defecto

### SW-A, SW-B, SW-C (3 unidades iguales)

1. Repite el paso 3-4 arriba: arrastra otro **2960-24TT** al lienzo
2. Repite **3 veces más** para tener 3 switches secundarios

En total debes tener **4 switches** en el lienzo.

### Renombrar los switches (ponerles nombres)

Para cambiar el nombre de cada switch:

1. Clic en el primer switch (el que está seleccionado, se marca con borde punteado)
2. Arriba a la derecha hay un cuadro de texto que dice `Switch0`. Clic dentro y escribe: `SW-PRINCIPAL`
3. Clic en cualquier parte del lienzo para confirmar
4. Clic en el segundo switch → escribe `SW-A`
5. Clic en el tercero → `SW-B`
6. Clic en el cuarto → `SW-C`

---

## 4. Agregar los equipos finales (18 en total)

A la izquierda, el último ícono (forma de computador) se llama **End Devices**. Clic ahí.

Dentro de End Devices hay una fila con subcategorías. La primera es **End Devices** (por defecto).

### PC1 a PC8 (8 estaciones de trabajo)

1. En la lista de dispositivos finales, busca **PC-PT** (tiene forma de computador de escritorio)
2. Arrástralo al lienzo
3. Repite hasta tener 8 PC-PT
4. Renómbralos: clic en cada uno → arriba a la derecha escribe `PC1`, `PC2`, ..., `PC8`

### LAP1 a LAP3 (3 laptops)

1. Busca **Laptop-PT** (tiene forma de notebook abierto)
2. Arrástralo 3 veces
3. Renómbralos: `LAP1`, `LAP2`, `LAP3`

### IMP1, IMP2, IMP3 (3 impresoras de red)

1. Busca **Printer-PT** (tiene forma de impresora)
2. Arrástralo 3 veces
3. Renómbralos: `IMP1`, `IMP2`, `IMP3`

### MFP (1 multifuncional)

1. Busca **Printer-PT** nuevamente
2. Arrástralo 1 vez
3. Renómbralo: `MFP`

### SRV (1 servidor)

1. Busca **Server-PT** (tiene forma de torre de servidor)
2. Arrástralo 1 vez
3. Renómbralo: `SRV`

### TEL-IP (1 teléfono IP)

1. Busca **IP Phone 7960** (tiene forma de teléfono)
2. Arrástralo 1 vez
3. Renómbralo: `TEL-IP`

### TV-CORP (1 TV corporativa — se simula con PC-PT)

1. Busca **PC-PT** nuevamente
2. Arrástralo 1 vez
3. Renómbralo: `TV-CORP`

### Verificación final

Debes tener en el lienzo:
- **4 switches** (SW-PRINCIPAL, SW-A, SW-B, SW-C)
- **8 PC-PT** (PC1 a PC8)
- **3 Laptop-PT** (LAP1 a LAP3)
- **3 Printer-PT** (IMP1, IMP2, IMP3)
- **1 Printer-PT** (MFP) → sí, son 4 Printer-PT en total
- **1 Server-PT** (SRV)
- **1 IP Phone 7960** (TEL-IP)
- **1 PC-PT** (TV-CORP)

Total: **22 dispositivos** (4 switches + 18 terminales)

---

## 5. Posicionar los dispositivos en el lienzo

Arrastra cada dispositivo para ordenarlos visualmente. Esta distribución ayuda a entender la topología:

| ¿Dónde? | Dispositivos |
|---|---|
| **Arriba a la izquierda** | SW-A, PC1, PC2, PC3, IMP1 |
| **Centro izquierda** | SW-B, PC4, PC5, LAP1, LAP2 |
| **Abajo a la izquierda** | SW-C, PC6, PC7, PC8, IMP2 |
| **Derecha** | SW-PRINCIPAL, SRV, MFP, TEL-IP, TV-CORP, LAP3, IMP3 |

Deja espacio entre los dispositivos para poder hacer las conexiones después (unos 5-10 cm en pantalla).

---

## 6. Encender el teléfono IP (paso IMPORTANTE que muchos olvidan)

El teléfono IP Phone 7960 en Packet Tracer **aparece apagado por defecto**. Hay que encenderlo manualmente:

1. **Clic en TEL-IP** → se abre una ventana con 3 pestañas arriba: **Physical**, **Config**, **Desktop**
2. Clic en la pestaña **Physical** (primera)
3. Verás la imagen del teléfono. A la derecha del teléfono hay una imagen de un **cubo negro con un cable** (es el adaptador de corriente)
4. **Arrastra ese cubo negro** al **puerto redondo** que está en la parte trasera del teléfono (en la imagen)
5. Al soltarlo, el teléfono debería encenderse (la pantalla se ilumina)
6. Si no se enciende, repite: vuelve a arrastrar el cubo al puerto redondo. A veces hay que hacerlo 2-3 veces
7. **Importante al cablear después**: el teléfono tiene 2 puertos RJ45. El de arriba dice **"Switch"**, el de abajo dice **"PC"**. Siempre usa **"Switch"**

---

## 7. Distribución de puertos y roles por dispositivo

### ¿Qué hace cada dispositivo en esta empresa?

| Dispositivo | Rol real | ¿Para qué se usa en la simulación? |
|---|---|---|
| **PC1 a PC8** | Escritorio de usuario (Office, navegación) | Generar pings de prueba, acceder al servidor web |
| **LAP1 a LAP3** | Notebook corporativo (movilidad interna) | Lo mismo que un PC pero en laptop |
| **IMP1, IMP2, IMP3** | Impresora de red de sector (compartida) | Servicio de impresión local por sector |
| **MFP** | Impresora multifuncional central (imprime, escanea, copia) | Equipo grande en área técnica |
| **TEL-IP** | Teléfono IP corporativo (VoIP) | Llamadas sobre la red IP |
| **SRV** | Servidor de intranet | Página web interna + DNS de la empresa |
| **TV-CORP** | TV/monitor informativo en red | Muestra información corporativa |
| **SW-A, SW-B, SW-C** | Switch de acceso (en cada sector) | Conecta los equipos de su sector |
| **SW-PRINCIPAL** | Switch central (en el rack) | Conecta todos los sectores y el área técnica |

---

## 8. Cableado — conectar todo con cables

### 8.1 Elegir el tipo de cable correcto

En Packet Tracer, abajo a la izquierda hay una sección llamada **Connections** (ícono de rayo o cable). Clic ahí.

Verás varios tipos de cable. El que usarás casi siempre es:

- **Copper Straight-Through** → cable recto. Puerto gris con 8 pines. Es el **más común**
- **Copper Cross-Over** → cable cruzado. Puerto con dos colores. Solo si el recto no funciona (enlace rojo)

### 8.2 Cómo conectar dos dispositivos (método general)

1. Clic en el cable **Copper Straight-Through** (en Connections)
2. Clic en el **primer dispositivo** (ej: PC1)
3. Al hacer clic, se abre una lista de puertos. Clic en el puerto correcto (ej: **FastEthernet0** o **Fa0**)
4. Aparece un cable siguiendo el mouse. Lleva el mouse al **segundo dispositivo** y clic
5. Se abre la lista de puertos del segundo dispositivo. Clic en el puerto correcto
6. Aparece el cable conectado entre ambos

### 8.3 Conectar cada equipo a su switch

Cada sector tiene sus propios equipos. Usa cable **Copper Straight-Through** para todo.

#### Sector A (SW-A)

Conecta en este orden:

| Desde | Puerto | Hacia | Puerto |
|---|---|---|---|
| PC1 | FastEthernet0 | SW-A | FastEthernet0/1 |
| PC2 | FastEthernet0 | SW-A | FastEthernet0/2 |
| PC3 | FastEthernet0 | SW-A | FastEthernet0/3 |
| IMP1 | FastEthernet0 | SW-A | FastEthernet0/4 |

**Paso a paso para PC1 → SW-A:**
1. Clic en **Copper Straight-Through**
2. Clic en **PC1**
3. En la lista, clic en **FastEthernet0**
4. Aparece cable siguiendo el mouse. Llévalo hasta **SW-A** y clic
5. En la lista del switch, clic en **FastEthernet0/1**
6. Ya está conectado. Verás un punto **verde** o **naranjo** en los extremos
7. Repite para PC2→Fa0/2, PC3→Fa0/3, IMP1→Fa0/4

#### Sector B (SW-B)

| Desde | Puerto | Hacia | Puerto |
|---|---|---|---|
| PC4 | FastEthernet0 | SW-B | FastEthernet0/1 |
| PC5 | FastEthernet0 | SW-B | FastEthernet0/2 |
| LAP1 | FastEthernet0 | SW-B | FastEthernet0/3 |
| LAP2 | FastEthernet0 | SW-B | FastEthernet0/4 |

Conecta uno por uno igual que arriba.

#### Sector C (SW-C)

| Desde | Puerto | Hacia | Puerto |
|---|---|---|---|
| PC6 | FastEthernet0 | SW-C | FastEthernet0/1 |
| PC7 | FastEthernet0 | SW-C | FastEthernet0/2 |
| PC8 | FastEthernet0 | SW-C | FastEthernet0/3 |
| IMP2 | FastEthernet0 | SW-C | FastEthernet0/4 |

#### Área técnica (SW-PRINCIPAL)

| Desde | Puerto | Hacia | Puerto |
|---|---|---|---|
| SRV | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/1 |
| MFP | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/2 |
| TEL-IP | **Switch** (no "PC") | SW-PRINCIPAL | FastEthernet0/3 |
| TV-CORP | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/4 |
| LAP3 | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/5 |
| IMP3 | FastEthernet0 | SW-PRINCIPAL | FastEthernet0/6 |

⚠️ **Para TEL-IP**: cuando hagas clic en TEL-IP para conectarlo, verás 2 puertos:
- **FastEthernet0** → NO usar
- **FastEthernet0/1 (Switch)** → **este es el correcto**

### 8.4 Conectar los switches entre sí (enlaces troncales)

Estas conexiones usan los puertos **Gigabit** de los switches (van más rápido y es más realista).

| Desde | Puerto | Hacia | Puerto |
|---|---|---|---|
| SW-A | **GigabitEthernet0/1** | SW-PRINCIPAL | **GigabitEthernet0/1** |
| SW-B | **GigabitEthernet0/1** | SW-PRINCIPAL | **GigabitEthernet0/2** |
| SW-C | **GigabitEthernet0/1** | SW-PRINCIPAL | **FastEthernet0/24** |

**Paso a paso para SW-A → SW-PRINCIPAL:**
1. Clic en **Copper Straight-Through**
2. Clic en **SW-A**
3. En la lista, elige **GigabitEthernet0/1** (está arriba separado de los FastEthernet)
4. Cable al mouse. Clic en **SW-PRINCIPAL**
5. Elige **GigabitEthernet0/1**

**⚠️ Si al conectar el cable aparece ROJO:**
1. Borra el cable (clic derecho sobre él → **Delete**)
2. Usa cable **Copper Cross-Over** en vez de Straight-Through
3. Conecta los mismos puertos de nuevo

**⚠️ Si al conectar aparece NARANJO:**
1. No es error. Espera unos 30 segundos
2. El switch está haciendo STP (Spanning Tree Protocol) para evitar bucles
3. Debería ponerse verde automáticamente

---

## 9. Asignar direcciones IP (configurar la red)

### 9.1 Las subredes

La red general es `192.168.10.0/24`. Se divide en subredes más pequeñas para separar los sectores:

| Sector         | Subred           | Máscara         | Puerta de enlace (Gateway) |
| -------------- | ---------------- | --------------- | -------------------------- |
| A (SW-A)       | 192.168.10.0/29  | 255.255.255.248 | 192.168.10.1               |
| B (SW-B)       | 192.168.10.8/29  | 255.255.255.248 | 192.168.10.9               |
| C (SW-C)       | 192.168.10.16/29 | 255.255.255.248 | 192.168.10.17              |
| Área técnica   | 192.168.10.24/28 | 255.255.255.240 | 192.168.10.25              |
| Enlace SA→PPAL | 192.168.10.40/30 | 255.255.255.252 | —                          |
| Enlace SB→PPAL | 192.168.10.44/30 | 255.255.255.252 | —                          |
| Enlace SC→PPAL | 192.168.10.48/30 | 255.255.255.252 | —                          |

**No te asustes con los números.** Cada equipo recibe una IP fija de su subred, según la tabla de más abajo. Solo debes copiar los valores.

### 9.2 Tabla completa de IPs por dispositivo

Cada dispositivo tiene asignada una IP fija. La IP del switch es solo para gestión administrativa (no la necesitas para que la red funcione entre los equipos).

#### Sector A (SW-A) — Máscara: 255.255.255.248 — Gateway: 192.168.10.1

| Dispositivo | IP           | ¿Cómo se configura?             |
| ----------- | ------------ | ------------------------------- |
| PC1         | 192.168.10.2 | Desktop → IP Configuration      |
| PC2         | 192.168.10.3 | Desktop → IP Configuration      |
| PC3         | 192.168.10.4 | Desktop → IP Configuration      |
| IMP1        | 192.168.10.5 | Config → FastEthernet0 → Static |
| SW-A        | 192.168.10.6 | CLI (terminal del switch)       |

#### Sector B (SW-B) — Máscara: 255.255.255.248 — Gateway: 192.168.10.9

| Dispositivo | IP | ¿Cómo se configura? |
|---|---|---|
| PC4 | 192.168.10.10 | Desktop → IP Configuration |
| PC5 | 192.168.10.11 | Desktop → IP Configuration |
| LAP1 | 192.168.10.12 | Desktop → IP Configuration |
| LAP2 | 192.168.10.13 | Desktop → IP Configuration |
| SW-B | 192.168.10.14 | CLI (terminal del switch) |

#### Sector C (SW-C) — Máscara: 255.255.255.248 — Gateway: 192.168.10.17

| Dispositivo | IP | ¿Cómo se configura? |
|---|---|---|
| PC6 | 192.168.10.18 | Desktop → IP Configuration |
| PC7 | 192.168.10.19 | Desktop → IP Configuration |
| PC8 | 192.168.10.20 | Desktop → IP Configuration |
| IMP2 | 192.168.10.21 | Config → FastEthernet0 → Static |
| SW-C | 192.168.10.22 | CLI (terminal del switch) |

#### Área técnica (SW-PRINCIPAL) — Máscara: 255.255.255.240 — Gateway: 192.168.10.25

| Dispositivo | IP | ¿Cómo se configura? |
|---|---|---|
| SRV | 192.168.10.26 | Desktop → IP Configuration |
| MFP | 192.168.10.27 | Config → FastEthernet0 → Static |
| TEL-IP | 192.168.10.28 | Config → Interface → Static |
| TV-CORP | 192.168.10.29 | Desktop → IP Configuration |
| LAP3 | 192.168.10.30 | Desktop → IP Configuration |
| IMP3 | 192.168.10.31 | Config → FastEthernet0 → Static |
| SW-PRINCIPAL | 192.168.10.33 | CLI (terminal del switch) |

---

## 10. Cómo configurar cada tipo de dispositivo (paso a paso)

### 10.1 Configurar un PC (PC1 a PC8, TV-CORP)

**¿Dónde?** En el mismo dispositivo PC, desde la ventana que se abre al hacer clic.

**Pasos:**

1. **Clic en el PC que quieres configurar** (ej: PC1)
2. Se abre una ventana con 3 pestañas arriba: **Physical**, **Config**, **Desktop**
3. Clic en la pestaña **Desktop**
4. Aparece una pantalla con íconos (como un escritorio de computador)
5. Busca el ícono que dice **IP Configuration** y clic en él
6. Se abre una ventana nueva. Arriba dice **IP Configuration**
7. Verás "DHCP" seleccionado por defecto (significa que asigna IP automática). **Debes cambiarlo**
8. Clic en el círculo **Static** (abajo de DHCP)
9. Ahora los campos se vuelven editables (blancos):

| Campo | Escribir |
|---|---|
| **IPv4 Address** | IP según tabla de arriba |
| **Subnet Mask** | 255.255.255.248 (en sector A/B/C) o 255.255.255.240 (área técnica) |
| **Default Gateway** | IP del gateway de su sector (.1, .9, .17 o .25) |
| **DNS Server** | 192.168.10.26 (es la IP del SRV, opcional) |

10. **Ejemplo PC1** (Sector A): escribe `192.168.10.2`, Tab, `255.255.255.248`, Tab, `192.168.10.1`, Tab, `192.168.10.26`
11. Cuando termines, cierra la ventana (clic en la X arriba a la derecha)
12. La IP queda guardada automáticamente

**Repite para cada PC y TV-CORP.** Son 9 dispositivos en total.

### 10.2 Configurar una Laptop (LAP1 a LAP3)

**Pasos:**

1. **Clic en la laptop** → se abre la ventana
2. Clic en pestaña **Desktop**
3. Clic en **IP Configuration**
4. Marcar **Static**
5. Escribir IP, Máscara, Gateway y DNS según su sector (igual que PC)
6. **Pero hay un problema**: las laptops en Packet Tracer a veces tienen el WiFi encendido y el cable de red apagado
7. Para verificarlo, cierra IP Configuration y en Desktop busca **Terminal** o vuelve a Config
8. En realidad: cierra la ventana de IP Config. Clic en pestaña **Config** (no Desktop)
9. En la columna izquierda, busca **FastEthernet0** y clic
10. Al lado derecho debe decir **Port Status: On** (encendido). Si está en Off, clic en el botón **On**
11. Luego clic en **Wireless0** en la columna izquierda
12. Al lado derecho debe decir **Port Status: Off** (apagado). Si está en On, clic en **Off**
13. Si está en Off, ok. Si no puedes apagarlo desde Config, ve a **Physical** y haz clic en el botón físico de la laptop (verde) hasta que apague la luz del WiFi

**Resumen para laptops: FastEthernet0 = On, Wireless0 = Off**

### 10.3 Configurar el Servidor (SRV)

1. Clic en **SRV**
2. Pestaña **Desktop**
3. Clic en **IP Configuration**
4. Marcar **Static**
5. Escribir:
   - IPv4 Address: `192.168.10.26`
   - Subnet Mask: `255.255.255.240`
   - Default Gateway: `192.168.10.25`
   - DNS Server: `192.168.10.26` (es él mismo)
6. Cerrar

### 10.4 Configurar una Impresora o MFP (IMP1, IMP2, IMP3, MFP)

**Las impresoras NO tienen escritorio (Desktop). Solo tienen Config.**

**Pasos:**

1. Clic en la impresora (ej: IMP1)
2. Pestaña **Config** (la del medio)
3. En la columna izquierda (INTERFACE), busca **FastEthernet0** y clic
4. A la derecha aparece **IP Configuration**. Arriba dice **DHCP** por defecto
5. Clic en **Static** (el círculo)
6. Aparecen los campos. Escribir:
   - **IP Address**: IP según tabla
   - **Subnet Mask**: 255.255.255.248 (IMP1, IMP2) o 255.255.255.240 (IMP3, MFP)
   - **Default Gateway**: IP del gateway de su sector
7. Cerrar

**Ejemplo IMP1 (Sector A):** IP = `192.168.10.5`, Mask = `255.255.255.248`, Gateway = `192.168.10.1`

### 10.5 Configurar el Teléfono IP (TEL-IP)

**Pasos:**

1. Clic en **TEL-IP**
2. Pestaña **Config**
3. En columna izquierda, busca **Interface** y clic
4. A la derecha aparece **IP Configuration**. Clic en **Static**
5. Escribir:
   - **IP Address**: `192.168.10.28`
   - **Subnet Mask**: `255.255.255.240`
   - **Default Gateway**: `192.168.10.25`
6. Cerrar

### 10.6 Configurar los switches (SW-A, SW-B, SW-C, SW-PRINCIPAL)

Los switches tienen **dos formas** de configurarse. Te explico las dos.

#### Opción 10.6A — Por CLI (recomendada, más rápida)

1. Clic en el switch (ej: SW-A)
2. Pestaña **CLI** (la tercera, al lado de Config)
3. Verás una pantalla negra con texto. Presiona **Enter** varias veces hasta que aparezca `Switch>`
4. El `>` significa que estás en modo usuario (solo puedes ver, no configurar)
5. Escribe exactamente estos comandos (presiona Enter después de cada línea):

```
enable
```

Aparece `Switch#` (el # significa modo privilegiado, puedes configurar).

```
configure terminal
```

Aparece `Switch(config)#` (modo configuración global).

```
hostname SW-A
```

Verás que el prompt cambia a `SW-A(config)#`. El switch ahora se llama SW-A.

```
interface vlan 1
```

Aparece `SW-A(config-if)#`. Estás configurando la interfaz virtual VLAN 1 (la IP de gestión).

```
ip address 192.168.10.6 255.255.255.248
```

Le asignas la IP al switch.

```
no shutdown
```

Esto "enciende" la interfaz (importante).

```
end
```

Vuelve a `SW-A#` (modo privilegiado).

```
copy running-config startup-config
```

Pregunta `Destination filename [startup-config]?`. Presiona **Enter** directo.

Ya está. La configuración quedó guardada.

**Comandos completos para SW-A:**
```
enable
configure terminal
hostname SW-A
interface vlan 1
 ip address 192.168.10.6 255.255.255.248
 no shutdown
end
copy running-config startup-config
```
(Enter en la pregunta)

**Comandos completos para SW-B:**
```
enable
configure terminal
hostname SW-B
interface vlan 1
 ip address 192.168.10.14 255.255.255.248
 no shutdown
end
copy running-config startup-config
```

**Comandos completos para SW-C:**
```
enable
configure terminal
hostname SW-C
interface vlan 1
 ip address 192.168.10.22 255.255.255.248
 no shutdown
end
copy running-config startup-config
```

**Comandos completos para SW-PRINCIPAL:**
```
enable
configure terminal
hostname SW-PRINCIPAL
interface vlan 1
 ip address 192.168.10.33 255.255.255.240
 no shutdown
end
copy running-config startup-config
```

#### Opción 10.6B — Por GUI (sin comandos)

1. Clic en el switch
2. Pestaña **Config**
3. En la columna izquierda, busca desplegar **INTERFACE** (clic en el + o en VLAN1)
4. Clic en **VLAN1**
5. A la derecha: en **IP Configuration**, clic en **Static**
6. Escribir IP y Subnet Mask según tabla
7. Cerrar

---

## 11. Servicios del servidor (opcional pero suma puntos)

Puedes hacer que SRV funcione como servidor web y DNS. Así los PCs pueden "navegar" a una página de la empresa.

**Paso a paso para activar HTTP (servidor web):**

1. Clic en **SRV** → pestaña **Services**
2. En la columna izquierda, clic en **HTTP**
3. A la derecha verás un botón **On** / **Off**. Clic en **On**
4. Ya está. El servidor ahora tiene una página web por defecto

**Paso a paso para activar DNS:**

1. En Services (columna izquierda), clic en **DNS**
2. A la derecha, clic en **On**
3. En **Name** escribe: `intranet.oficina.cl`
4. En **Address** escribe: `192.168.10.26` (es la IP del propio SRV)
5. Clic en **Add**
6. También puedes agregar solo `intranet` → `192.168.10.26` (para que funcione sin escribir .oficina.cl)

**Probar desde un PC:**

1. Clic en PC1 → pestaña **Desktop**
2. Clic en **Web Browser** (ícono de globo terráqueo)
3. En la barra de URL escribe: `http://intranet.oficina.cl`
4. Presiona Enter o clic en **Go**
5. Debe aparecer una página web

---

## 12. Probar que la red funciona

Vas a hacer **ping** desde un PC a otro. Ping es un comando que envía 4 paquetes y espera respuesta. Si recibes respuesta, la conexión funciona.

**Cómo hacer ping (desde cualquier PC):**

1. Clic en el PC desde el que quieres probar
2. Pestaña **Desktop**
3. Clic en **Command Prompt** (ícono de pantalla negra con `>_`)
4. Se abre una ventana negra (como la terminal de Windows)
5. Escribe: `ping 192.168.10.X` (donde X es la IP del destino) y presiona Enter

**Pruebas obligatorias:**

| Prueba | ¿Qué escribir? | Resultado esperado |
|---|---|---|
| **PC1 → servidor** | En PC1: `ping 192.168.10.26` | 4 respuestas "Reply from..." |
| **PC4 → PC6** (sector B a C) | En PC4: `ping 192.168.10.18` | 4 respuestas |
| **PC8 → IMP1** (sector C a A) | En PC8: `ping 192.168.10.5` | 4 respuestas |
| **LAP3 → TV-CORP** | En LAP3: `ping 192.168.10.29` | 4 respuestas |
| **SRV → TEL-IP** | En SRV: `ping 192.168.10.28` | 4 respuestas |

**Cómo interpretar el resultado:**

✅ **Respuesta correcta** (funciona):
```
Reply from 192.168.10.26: bytes=32 time=1ms TTL=128
Reply from 192.168.10.26: bytes=32 time=1ms TTL=128
Reply from 192.168.10.26: bytes=32 time=1ms TTL=128
Reply from 192.168.10.26: bytes=32 time=1ms TTL=128
```

❌ **Respuesta incorrecta** (no funciona):
```
Request timed out.
Request timed out.
Request timed out.
Request timed out.
```

**⚠️ Cosas que debes saber sobre el ping:**
- El **primer ping** a veces falla aunque la red esté bien. Es normal: el equipo está preguntando "¿quién tiene esa IP?" (ARP). Siempre **repite el ping** una segunda vez
- Si estás usando subredes separadas (con máscaras /29, /28, etc.), los pings **entre sectores diferentes fallarán** porque los switches 2960 son L2 y no pueden pasar tráfico entre subredes. Para la simulación práctica puedes poner máscara /24 en todos los equipos y usar el subnetting real solo en el informe del trabajo

---

## 13. Capturas para el informe

Tienes que entregar un informe con evidencias. Captura estas pantallas:

### Topología completa
1. Presiona **Ctrl+D** o menú **View** → **Zoom to Fit** para ver todo en una pantalla
2. Presiona **Alt+PrintScreen** (o la tecla que haga captura en tu sistema)
3. Pégalo en tu informe

### Configuración IP de 2-3 equipos
1. Clic en PC1 → Desktop → IP Configuration (ya configurado)
2. Captura (Alt+PrintScreen)
3. Haz lo mismo con PC5 y con IMP1 (Config → FastEthernet0)

### Pings exitosos
1. Desde PC1 haz ping a SRV: `ping 192.168.10.26`
2. Cuando veas las 4 respuestas, captura
3. Repite con otras pruebas de la tabla

### Recorrido Simulation (extra)
1. Clic en modo **Simulation** (abajo a la derecha, junto a "Realtime")
2. Clic en **Edit Filters** → marcar solo **ICMP**
3. Clic en **Add Simple PDU** (sobre del sobre)
4. Clic en PC1, luego clic en SRV
5. Clic en **Auto Capture / Play** (botón de play)
6. Se anima el paquete viajando: PC1 → SW-A → SW-PRINCIPAL → SRV
7. Captura esta animación

---

## 14. Rotular todo (con etiquetas)

En Packet Tracer hay una herramienta de notas. Sirve para escribir texto en el lienzo.

1. Clic en la herramienta **Place Note** (abajo a la izquierda, ícono de nota adhesiva o presiona **N** en el teclado)
2. Clic en el lienzo donde quieras poner la nota
3. Aparece un cuadro de texto. Escribe, por ejemplo: **"Sector A - 4 equipos"**
4. Clic fuera para fijarla
5. Puedes moverla arrastrándola

**Etiquetas recomendadas:**
- Al lado de cada switch: nombre del sector
- Sobre cada cable de enlace entre switches: "Enlace 28 m Cat6"
- Arriba de todo: nota grande que diga: **"18 puntos terminales. Topología estrella jerárquica segmentada. Cable UTP Cat6."**

---

## Errores frecuentes (revisa esto si algo no funciona)

| Problema | Causa | Solución |
|---|---|---|
| Cable **rojo** entre switches | Cable recto cuando necesita cruzado | Borrar cable y usar **Copper Cross-Over** |
| Cable **naranjo** | STP haciendo loop detection | Esperar 30 segundos, se pone verde solo |
| Ping entre sectores falla | Switches L2 no rutean entre subredes | Usar máscara /24 en todos para la simulación, subnetting en el informe |
| TEL-IP no responde ping | Falta encenderlo (viene apagado) | Sección 6: arrastrar adaptador de corriente en Physical |
| Laptop no funciona | WiFi encendido, Ethernet apagado | FastEthernet0 = On, Wireless0 = Off |
| Máscara incorrecta | Poner 255.255.255.0 en todo | Cada sector tiene su propia máscara: /29 = 248, /28 = 240 |
| Gateway equivocado | Poner el mismo gateway en todos | Cada sector tiene su gateway: .1, .9, .17, .25 |
| Primer ping falla | ARP (el equipo pregunta quién tiene la IP) | Repetir el ping una segunda vez |

---

## Resumen rápido (cheat sheet)

| Acción | Pasos |
|---|---|
| **Configurar PC/Laptop/SRV** | Clic en equipo → Desktop → IP Configuration → Static |
| **Configurar impresora/MFP** | Clic en equipo → Config → FastEthernet0 → Static |
| **Configurar TEL-IP** | Clic en TEL-IP → Config → Interface → Static |
| **Configurar switch (GUI)** | Clic en switch → Config → VLAN1 → Static |
| **Configurar switch (CLI)** | Clic en switch → CLI → `enable` → `configure terminal` → ... |
| **Hacer ping** | Clic en PC → Desktop → Command Prompt → `ping IP` |
| **Activar HTTP en SRV** | Clic en SRV → Services → HTTP → On |
| **Activar DNS en SRV** | Clic en SRV → Services → DNS → On → Add |
| **Encender TEL-IP** | Clic en TEL-IP → Physical → arrastrar adaptador al puerto |
| **Rotular** | Presionar **N** → clic en lienzo → escribir texto |
