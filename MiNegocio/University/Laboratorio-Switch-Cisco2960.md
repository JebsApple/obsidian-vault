---
tags: [universidad, redes, cisco, laboratorio]
---

# Laboratorio Intermedio — Switch Cisco 2960 por Consola

> Administración básica y configuración inicial de un switch Cisco 2960 mediante acceso por consola.

---

## Escenario

El departamento de soporte ha recibido un switch Cisco 2960 recién instalado. No hay administración remota habilitada aún, así que todo se hace por **consola**.

---

## Índice

1. [Conexión física](#parte-1--conexión-física-y-acceso-al-dispositivo)
2. [Exploración inicial](#parte-2--exploración-inicial-del-dispositivo)
3. [Configuración básica](#parte-3--configuración-básica-del-equipo)
4. [Administración de interfaces](#parte-4--administración-de-interfaces)
5. [Monitoreo](#parte-5--monitoreo-del-switch)
6. [Respaldo y cierre](#parte-6--respaldo-y-cierre)

---

## Equipo necesario

### Hardware

| Elemento | Especificación |
|----------|---------------|
| Switch | **Cisco 2960** (modelo típico: WS-C2960-24TT-L) |
| PC de administración | Cualquier computador con puerto USB o DB9 |
| Cable de consola | **Cable serial RJ-45 a DB9** (el cable celeste oscuro que viene con el switch) |
| Adaptador | Si el PC no tiene puerto DB9 → **adaptador USB a Serial (DB9)** |
| Alimentación | Enchufar el switch a la corriente |

### Software

| Programa | Alternativas |
|----------|-------------|
| Terminal serial | PuTTY, SecureCRT, TeraTerm, screen (Linux/Mac) |

---

## Parte 1 — Conexión física y acceso al dispositivo

### Actividad 1 — Conectar el cable de consola

1. Toma el **cable de consola** (RJ-45 celeste oscuro a DB9).
2. Conecta el extremo **RJ-45** (parece plug de red) al puerto **Console** del switch Cisco 2960.
   - El puerto **Console** está en el **panel frontal** del switch, suele estar marcado con un ícono de computador/pantalla.
   - En un 2960-24TT, está a la izquierda, junto al puerto MGMT (si existe).
3. Conecta el extremo **DB9** directamente al puerto serie del PC.
   - Si tu PC **no tiene** puerto DB9: usa el adaptador **USB a Serial**, conecta el DB9 al adaptador y el adaptador al USB.

### Actividad 2 — Configurar el terminal serial

Abre tu programa de terminal con estos parámetros exactos:

| Parámetro | Valor |
|-----------|-------|
| Puerto | COM1/COM3 (Win) o `/dev/ttyUSB0` (Linux) o `/dev/cu.usbserial-*` (Mac) |
| Baud rate | **9600** |
| Data bits | **8** |
| Parity | **None** |
| Stop bits | **1** |
| Flow control | **None** |

> **PuTTY:** Connection type → Serial, Serial line → `COM1`, Speed → `9600`, Open.
> **Linux:** `screen /dev/ttyUSB0 9600`
> **Mac:** `screen /dev/cu.usbserial-XXXX 9600`

### Actividad 3 — Acceder al switch

1. Enchufa el switch a la corriente (enciéndelo si tiene interruptor).
2. Espera 30-60 segundos a que arranque (verás texto del POST y boot).
3. Presiona **Enter** hasta ver:

```
Switch>
```

¡Estás dentro del CLI de Cisco IOS!

### Actividad 4 — Registrar evidencia

Screenshot o copia textual del prompt `Switch>`. Esa es tu evidencia de conexión exitosa.

---

## Parte 2 — Exploración inicial del dispositivo

### Actividad 5 — Modo operativo inicial

`Switch>` → **modo usuario** (User EXEC). Identificado por el `>`.
Solo permite comandos de consulta básica.

### Actividad 6 — Ingresar a modo privilegiado

```
Switch> enable
Switch#
```

`Switch#` → **modo privilegiado** (Privileged EXEC). Identificado por `#`.
Aquí puedes ver toda la config y ejecutar cambios.

### Actividad 7 — Identificar modelo y versión IOS

```
Switch# show version
```

Buscar:
- **Modelo:** `cisco WS-C2960-24TT-L` (o similar)
- **IOS:** `Cisco IOS Software, Version 15.0(2)`
- **Interfaces:** `24 FastEthernet + 2 Gigabit Ethernet`
- **Uptime:** `Switch uptime is ...`

### Actividad 8 — Nombre, estado, uptime y config activa

```
Switch# show running-config
```

| Dato | Valor esperado |
|------|---------------|
| Hostname | `Switch` (valor por defecto) |
| Uptime | En `show version` |
| Config activa | `show running-config` (casi vacía en switch nuevo) |

---

## Parte 3 — Configuración básica del equipo

### Actividad 9 — Cambiar el nombre

```
Switch# configure terminal
Switch(config)# hostname SW-LAB-01
SW-LAB-01(config)#
```

El prompt cambia inmediatamente. Usa el nombre que indique el docente.

### Actividad 10 — Desactivar búsqueda DNS

```
SW-LAB-01(config)# no ip domain-lookup
```

Esto evita la pausa de ~30s si tipeas mal un comando (el switch intenta resolverlo como dominio).

### Actividad 11 — Mensaje del día (MOTD)

```
SW-LAB-01(config)# banner motd #Laboratorio Intermedio - Switch Cisco 2960#
```

El `#` es el delimitador. Todo lo que esté entre los dos `#` será el mensaje de bienvenida.

### Actividad 12 — Verificar configuración

```
SW-LAB-01# show running-config
```

Confirma que aparecen: `hostname`, `no ip domain-lookup`, `banner motd`.

---

## Parte 4 — Administración de interfaces

### Actividad 13 — Listar todas las interfaces

```
SW-LAB-01# show ip interface brief
```

Salida típica:
```
Interface              IP-Address      OK? Method Status  Protocol
FastEthernet0/1        unassigned      YES unset  down    down
...
FastEthernet0/24       unassigned      YES unset  down    down
GigabitEthernet0/1     unassigned      YES unset  down    down
GigabitEthernet0/2     unassigned      YES unset  down    down
```

### Actividad 14 — Configurar descripción y estado de interfaces

```
SW-LAB-01# configure terminal
SW-LAB-01(config)# interface FastEthernet 0/1
SW-LAB-01(config-if)# description Puerto de acceso - PC Admin
SW-LAB-01(config-if)# no shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/2
SW-LAB-01(config-if)# description Puerto de acceso - Impresora
SW-LAB-01(config-if)# shutdown
SW-LAB-01(config-if)# end
```

| Comando | Efecto |
|---------|--------|
| `description ...` | Texto descriptivo en la interfaz |
| `no shutdown` | Activa la interfaz |
| `shutdown` | Desactiva la interfaz |
| `end` | Vuelve directo a modo privilegiado |

### Actividad 15 — Estado de interfaces

```
SW-LAB-01# show interfaces status
```

| Estado (Status) | Significado |
|-----------------|-------------|
| `connected` | Activa y con cable conectado |
| `disabled` | Administrativamente abajo (`shutdown`) |
| `notconnected` | Sin cable, físicamente desconectada |

---

## Parte 5 — Monitoreo del switch

### Actividad 16 — Obtener información

```
SW-LAB-01# show interfaces
SW-LAB-01# show running-config
SW-LAB-01# show startup-config
SW-LAB-01# show processes cpu
SW-LAB-01# show memory
```

> `startup-config` dirá `startup-config is not present` si nunca se ha guardado.

### Actividad 17 — Comparar configs

- `show running-config` = configuración activa ahora (con tus cambios)
- `show startup-config` = configuración guardada en NVRAM

Si no has guardado → startup-config está vacío. **Al reiniciar perderías todo**.

---

## Parte 6 — Respaldo y cierre

### Actividad 18 — Guardar configuración

```
SW-LAB-01# copy running-config startup-config
```

O:
```
SW-LAB-01# write memory
```

Respuesta esperada: `Building configuration... [OK]`

### Actividad 19 — Salir de la sesión

```
SW-LAB-01# exit
SW-LAB-01> exit
```

### Actividad 20 — Verificar persistencia

Vuelve a conectar por consola. Deberías ver:
1. El banner MOTD
2. `enable` → `show startup-config` → todo está ahí: hostname, banner, descripciones.

---

## Resumen de comandos

| Comando | Modo | Qué hace |
|---------|------|----------|
| `enable` | Usuario | Entra a modo privilegiado |
| `configure terminal` | Privilegiado | Entra a modo configuración |
| `hostname X` | Config global | Cambia el nombre del switch |
| `no ip domain-lookup` | Config global | Desactiva resolución DNS |
| `banner motd #texto#` | Config global | Mensaje del día |
| `interface Fa0/X` | Config global | Submodo de interfaz |
| `description X` | Config interfaz | Descripción de interfaz |
| `shutdown` | Config interfaz | Desactiva interfaz |
| `no shutdown` | Config interfaz | Activa interfaz |
| `show version` | Cualquiera | IOS y modelo del equipo |
| `show running-config` | Privilegiado | Config activa en RAM |
| `show startup-config` | Privilegiado | Config guardada en NVRAM |
| `show ip int brief` | Cualquiera | Resumen rápido de interfaces |
| `show interfaces status` | Cualquiera | Estado de cada interfaz |
| `copy run start` | Privilegiado | Guarda la config |
| `write memory` | Privilegiado | Atajo para guardar |
| `exit` | Cualquiera | Sale del modo actual |
| `end` | Config/Submodo | Vuelve directo a `#` |

---

## Modos de IOS

```
Switch>              ← User EXEC (consulta básica)
Switch#              ← Privileged EXEC (consulta + debug + guardar)
Switch(config)#      ← Global Configuration (cambios del sistema)
Switch(config-if)#  ← Interface Configuration (cambios en interfaz)
```

- `exit` → sube un nivel
- `end` → vuelve directo a `#`
