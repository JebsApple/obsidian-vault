---
tags: [caso05, packet-tracer, voip, telefono]
---

# Paso 6: Teléfono — Home VoIP + CME

Configurar el teléfono IP para que se registre en el Call Manager Express del router.

## Requisitos previos

- Router tiene `telephony-service`, `ephone-dn 1` y `option 150` configurados (Paso 3)
- TEL-IP tiene IP por DHCP (Paso 5)

## Si el teléfono NO obtiene IP por DHCP

Solución manual:

1. Click en **Home VoIP0** → **Desktop** → **IP Configuration**
2. Poner **Static**:
   - IP: `192.168.10.40`
   - Mask: `255.255.255.0`
   - Gateway: `192.168.10.1`
3. Aceptar

> ⚠️ Si ponés IP estática, asegurate que NO esté en el `ip dhcp excluded-address` del router. Si está excluida, o la sacás del exclude o usás otra IP.

## Puerto correcto del Home VoIP

Home VoIP0 tiene un solo puerto Ethernet llamado **Ethernet** (no FastEthernet0). Verificar cable conectado ahí. El led debe estar **verde**.

## Registrar con CME

1. Click en **Home VoIP0** → **Desktop**
2. Abrir **CIPC** (Cisco IP Communicator) — puede llamarse **IP Communicator** o **Phone Dialer**
3. En la ventana que aparece, configurar:
   - **TFTP Server**: `192.168.10.1`
   - **Line**: `100` (o auto)
4. Click **OK** o **Register**

El teléfono debe mostrar el número **100** en pantalla.

## Verificar registro

En el router (CLI):

```
R-PRINCIPAL# show ephone
ephone-1 Mac: XXXX.XXXX.XXXX  TCP socket: [1] 166.1.1.1:50855
  line: 1  DN 1 100  CHANNEL 1  0
```

Si `show ephone` no muestra nada, el teléfono no se registró. Causas posibles:

- **TFTP bloqued**: en Home VoIP, abrir **Cisco IP Communicator** desde Desktop y verificar que el TFTP apunte a `192.168.10.1`
- **Option 150**: verificar que el router tenga `option 150 ip 192.168.10.1` en el pool DHCP
- **Firewall**: PT no tiene firewall real, pero si el teléfono está en una subred diferente al router, revisar rutas
- **Puerto switch**: verificar que Fa0/3 de SW-PRINCIPAL esté en `switchport mode access` y el led esté verde

## Si nada funciona

El teléfono registrado no es requisito del PDF del profesor. El PDF pide:
- Cableado estructurado funcional ✅
- Pings entre sectores ✅
- Cotizaciones + VAN/TIR (no PT)

El CME se incluye para demostrar conocimiento técnico, pero si el teléfono no registra, no invalida el trabajo.
