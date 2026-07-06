---
tags: [caso05, packet-tracer, capturas, informe]
---

# Paso 8: Capturas para el informe

Lista de screenshots necesarios para la sección 4.4 del informe. El orden sigue la estructura del PDF del profesor.

## 1. Topología completa

Capturar el canvas de PT mostrando:
- Todos los 23 dispositivos visibles
- Conexiones (cables) visibles
- Nombres de cada dispositivo legibles

> **Posición**: después de la tabla de direccionamiento IP en la sección 4.4

## 2. Tabla de direccionamiento IP

No es captura de PT, es tabla en el Word:

| Dispositivo | IP | Máscara | Gateway |
|-------------|-----|---------|---------|
| R-PRINCIPAL Fa0/0 | 192.168.10.1 | /24 | — |
| PC-1 | 192.168.10.2 | /24 | .1 |
| ... (todos los 18 terminales) | ... | ... | ... |
| TEL-IP | 192.168.10.39 (DHCP) | /24 | .1 |

## 3. Router — show ip interface brief

Captura CLI del router mostrando Fa0/0 `up/up` con IP `192.168.10.1/24`.

```
R-PRINCIPAL#show ip interface brief
Interface             IP-Address      OK? Method Status          Protocol
FastEthernet0/0       192.168.10.1    YES manual up              up
```

## 4. Switch — show interfaces status

Captura de SW-PRINCIPAL o cualquier switch mostrando los puertos en estado `connected`.

```
SW-PRINCIPAL#show interfaces status
Port      Name               Status       Vlan       Duplex  Speed Type
Fa0/7     Enlace al router   connected    1          a-full  a-100 10/100BaseTX
...
```

## 5. Pings funcionales

Captura de pings desde R-PRINCIPAL a:
- PC-1 (192.168.10.2) — Sector A
- PC-5 (192.168.10.11) — Sector B
- PC-6 (192.168.10.18) — Sector C
- SRV (192.168.10.34) — Área técnica

> Capturar al menos 1 ping exitoso de cada sector. No importa si son 80% o 100%.

## 6. DHCP binding (opcional)

Si el teléfono tomó IP por DHCP, capturar `show ip dhcp binding` mostrando IP .39 asignada.

## 7. ephone (opcional)

Si el teléfono registró correctamente, capturar `show ephone` mostrando línea 100 registrada.

## Resumen de capturas mínimas

| # | Captura | Obligatorio? |
|---|---------|-------------|
| 1 | Topología completa | ✅ Sí |
| 2 | Tabla IP | ✅ Sí |
| 3 | show ip interface brief | ✅ Sí |
| 4 | show interfaces status | ✅ Sí |
| 5 | Pings a cada sector | ✅ Sí |
| 6 | DHCP binding | ❌ No, solo si funciona |
| 7 | show ephone | ❌ No, solo si registra |

## Cómo tomar las capturas

En PT:
1. Abrir la pestaña deseada (CLI, Desktop, o canvas)
2. `Ctrl+Alt+Shift+X` o usar herramienta de captura de pantalla del sistema
3. Guardar como PNG

Para CLI: a veces es mejor capturar toda la ventana de PT mostrando el CLI + título.
