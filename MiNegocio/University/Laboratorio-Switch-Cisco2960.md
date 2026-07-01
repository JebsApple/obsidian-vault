---
tags: [universidad, redes, cisco, laboratorio, packet-tracer]
---

# Laboratorio Intermedio — Switch Cisco 2960 en Packet Tracer

> Administración básica y configuración inicial de un switch Cisco 2960 mediante acceso por consola en **Cisco Packet Tracer**.

---

## Escenario

El departamento de soporte ha recibido un switch Cisco 2960 recién instalado. No hay administración remota habilitada aún, así que todo se hace por **consola**. Vas a simularlo en Packet Tracer.

---

## Índice

1. [Montar el escenario](#parte-1--montar-el-escenario-en-packet-tracer)
2. [Exploración inicial](#parte-2--exploración-inicial-del-dispositivo)
3. [Configuración básica](#parte-3--configuración-básica-del-equipo)
4. [Administración de interfaces](#parte-4--administración-de-interfaces)
5. [Monitoreo](#parte-5--monitoreo-del-switch)
6. [Respaldo y cierre](#parte-6--respaldo-y-cierre)

---

## Parte 1 — Montar el escenario en Packet Tracer

### Actividad 1 — Colocar los dispositivos

1. Abre **Cisco Packet Tracer**.
2. En la barra inferior, ve a **End Devices** y arrastra un **PC** al área de trabajo.
3. Ve a **Switches** y arrastra un **Switch 2960** (el modelo 24 puertos, se ve así: 24 FastEthernet + 2 Gigabit).
4. Colócalos separados para que se vea claro.

### Actividad 2 — Conectar por consola

1. En la barra de herramientas, selecciona el ícono del **cable** (Connections).
2. Elige el cable de consola: **Cable** → **Console** (el ícono es un cable celeste con punta RJ-45).
3. Haz clic en el **PC** → se abre una ventana de selección de puerto. Elige **RS-232**.
4. Luego haz clic en el **Switch 2960** → elige **Console**.
5. Aparece un cable celeste conectando ambos dispositivos. ✅

### Actividad 3 — Acceder al CLI del switch

1. Haz clic en el **Switch 2960** → se abre una ventana.
2. Ve a la pestaña **CLI** (Command Line Interface).
3. Espera a que termine el boot (verás texto pasando).
4. Presiona **Enter** hasta ver:

```
Switch>
```

¡Estás en el CLI de Cisco IOS!

> 💡 Si no ves el prompt rápido, presiona Enter un par de veces.

### Actividad 4 — Registrar evidencia

Toma un **screenshot** de la ventana de Packet Tracer mostrando el prompt `Switch>` en la pestaña CLI. Esa es tu evidencia de conexión exitosa.

---

## Parte 2 — Exploración inicial del dispositivo

### Actividad 5 — Modo operativo inicial

`Switch>` → **modo usuario** (User EXEC). Se identifica por el `>`.
Solo permite comandos de consulta básica.

### Actividad 6 — Ingresar a modo privilegiado

```
Switch> enable
Switch#
```

`Switch#` → **modo privilegiado** (Privileged EXEC). Se identifica por el `#`.
Desde acá puedes ver todo y aplicar cambios.

> El laboratorio se hace **sin contraseñas**. Solo escribes `enable` y entras.

### Actividad 7 — Identificar modelo y versión IOS

```
Switch# show version
```

Busca en la salida:

| Dato | Qué buscar |
|------|-----------|
| **Modelo** | `WS-C2960-24TT-L` |
| **IOS** | `Cisco IOS Software, Version ...` |
| **Interfaces** | `24 FastEthernet` + `2 GigabitEthernet` |
| **Uptime** | `Switch uptime is ...` |

### Actividad 8 — Nombre, estado, uptime y config activa

```
Switch# show running-config
```

| Dato | Valor esperado |
|------|---------------|
| Hostname actual | `Switch` (default de fábrica) |
| Config activa | Vacía / solo lo mínimo |
| Uptime | En `show version` |

---

## Parte 3 — Configuración básica del equipo

### Actividad 9 — Cambiar el nombre del switch

```
Switch# configure terminal
Switch(config)# hostname SW-LAB-01
SW-LAB-01(config)#
```

El prompt cambia apenas le das Enter. Usa el nombre que diga tu profe.

### Actividad 10 — Desactivar búsqueda DNS

```
SW-LAB-01(config)# no ip domain-lookup
```

Si no pones esto, al escribir mal un comando el switch se queda ~30s intentando resolverlo como nombre de dominio.

### Actividad 11 — Mensaje del día (MOTD Banner)

```
SW-LAB-01(config)# banner motd #Laboratorio Intermedio - Switch Cisco 2960#
```

El `#` actúa como delimitador. Todo lo que va entre los dos `#` será el banner de bienvenida.

### Actividad 12 — Verificar configuración aplicada

```
SW-LAB-01(config)# end
SW-LAB-01# show running-config
```

Confirma que aparecen:

1. `hostname SW-LAB-01`
2. `no ip domain-lookup`
3. `banner motd ^C...^C`

---

## Parte 4 — Administración de interfaces

### Actividad 13 — Listar todas las interfaces disponibles

```
SW-LAB-01# show ip interface brief
```

Salida típica en Packet Tracer:

```
Interface              IP-Address      OK? Method Status  Protocol
FastEthernet0/1        unassigned      YES unset  down    down
FastEthernet0/2        unassigned      YES unset  down    down
... (hasta Fa0/24)
GigabitEthernet0/1     unassigned      YES unset  down    down
GigabitEthernet0/2     unassigned      YES unset  down    down
```

Tienes **24 puertos FastEthernet** (Fa0/1 - Fa0/24) y **2 GigabitEthernet** (Gi0/1 - Gi0/2).

### Actividad 14 — Configurar descripción y estado de interfaces

Vas a configurar un grupo de interfaces. Elige 4 (o las que diga el profe):

```
SW-LAB-01# configure terminal
SW-LAB-01(config)# interface FastEthernet 0/1
SW-LAB-01(config-if)# description Puerto de acceso - PC Admin
SW-LAB-01(config-if)# no shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/2
SW-LAB-01(config-if)# description Puerto de acceso - Impresora
SW-LAB-01(config-if)# shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/3
SW-LAB-01(config-if)# description Puerto de reserva
SW-LAB-01(config-if)# shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/4
SW-LAB-01(config-if)# description Enlace a switch secundario
SW-LAB-01(config-if)# no shutdown
SW-LAB-01(config-if)# end
```

| Comando | Efecto |
|---------|--------|
| `description ...` | Pone una etiqueta a la interfaz |
| `no shutdown` | Activa la interfaz (la enciende) |
| `shutdown` | Desactiva la interfaz (la apaga) |
| `end` | Vuelve directo al prompt `#` desde cualquier submodo |

### Actividad 15 — Determinar estado de las interfaces

```
SW-LAB-01# show interfaces status
```

Columna **Status**:

| Estado | Significado |
|--------|-------------|
| `connected` | Activa ✅ |
| `disabled` | Le pusiste `shutdown` 🔴 |
| `notconnected` | Sin cable conectado ⚪ |

Registra cuántas interfaces están en cada estado.

---

## Parte 5 — Monitoreo del switch

### Actividad 16 — Obtener información del sistema

```
SW-LAB-01# show interfaces              ← estadísticas de todas las interfaces
SW-LAB-01# show running-config          ← config actual (en RAM)
SW-LAB-01# show startup-config          ← config guardada (en NVRAM)
SW-LAB-01# show processes cpu           ← uso de CPU
SW-LAB-01# show memory                  ← uso de memoria
```

> Si nunca has guardado, `show startup-config` dirá que no está presente. Es normal.

### Actividad 17 — Comparar configuraciones

Ejecuta:

```
SW-LAB-01# show running-config
SW-LAB-01# show startup-config
```

- **running-config**: cambios que has hecho esta sesión (en RAM).
- **startup-config**: lo que sobrevive a un reinicio (en NVRAM).

Si nunca guardaste → la startup está vacía. **Si reinicias el switch, pierdes todo.**

---

## Parte 6 — Respaldo y cierre

### Actividad 18 — Guardar la configuración

```
SW-LAB-01# copy running-config startup-config
```

O el atajo:

```
SW-LAB-01# write memory
```

Respuesta esperada:

```
Building configuration...
[OK]
```

Ahora sí la configuración persiste al reinicio.

### Actividad 19 — Cerrar sesión

```
SW-LAB-01# exit
SW-LAB-01> exit
```

### Actividad 20 — Verificar persistencia

1. Cierra la ventana del switch en Packet Tracer.
2. Vuelve a hacer clic en el switch → pestaña **CLI**.
3. Presiona Enter hasta que aparezca el prompt.
4. Escribe `enable`, luego:

```
Switch# show startup-config
```

Confirma que ves: `hostname SW-LAB-01`, `no ip domain-lookup`, `banner motd ...` y las `description` en las interfaces.

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
| `show interfaces` | Privilegiado | Estadísticas detalladas |
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
- `end` → vuelve directo a `#` desde cualquier submodo

---

## Diferencias con el hardware real

| Aspecto | Packet Tracer | Switch real |
|---------|--------------|-------------|
| Conexión | Cable Console arrastrando | Cable RJ-45 a DB9 físico |
| Terminal | Pestaña CLI integrada | PuTTY/screen por separado |
| Aceleración | Boot instantáneo | 30-60 segundos |
| Reset | Botón "Power Cycle" en ventana | Desconectar cable de poder |
| Costo | Gratis | Depende del laboratorio |
