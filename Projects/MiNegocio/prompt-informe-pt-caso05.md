---
tags: [caso05, informe, prompt, redaccion]
---

# Prompt para redacción del informe — Simulación PT Caso 05

Usá este prompt en ChatGPT/Claude para redactar la sección de simulación del informe, asumiendo que todo funciona perfecto.

---

## Prompt

Eres un ingeniero de redes redactando la sección 4.4 "Simulación en Cisco Packet Tracer" de un Trabajo de Investigación Técnico-Económico sobre cableado estructurado.

### Contexto del trabajo

- Caso 05: Red LAN para 18 terminales en 4 sectores (A, B, C, Área Técnica)
- Topología: estrella jerárquica con un switch principal (SW-PRINCIPAL) y 3 switches de acceso (SW-A, SW-B, SW-C)
- Cableado: UTP Cat6 desde cada terminal a su switch de acceso, y uplinks Cat6 entre switches
- Router R-PRINCIPAL (2811) incluido solo para servicios DHCP y telefonía IP (no requiere routing inter-VLAN)
- Red plana 192.168.10.0/24 con máscara 255.255.255.0, gateway 192.168.10.1
- IPs estáticas en todos los equipos, excepto TEL-IP que usa DHCP

### Redacción requerida

Redacta en tono técnico-profesional, en español, los siguientes puntos:

1. **Descripción de la topología implementada**: mencionar los 23 dispositivos (4 switches 2960-24TT, 1 router 2811, 8 PC, 3 laptops, 3 impresoras, 1 MFP, 1 servidor, 1 teléfono IP, 1 TV corporativa) y su organización en estrella jerárquica.

2. **Esquema de direccionamiento IP**: tabla con dispositivo, dirección IP, máscara y gateway.

3. **Configuración del router**: DHCP pool para el teléfono IP, servicio Call Manager Express (CME) para telefonía, puerto Fa0/0 como gateway de la red.

4. **Verificación de conectividad**: mencionar que se realizaron pruebas de ping entre equipos de diferentes sectores y hacia el router, con resultados exitosos.

5. **Conclusión**: la simulación valida que el diseño de cableado estructurado y el direccionamiento IP permiten la comunicación entre todos los equipos de la red.

### Tabla de direccionamiento IP

| Dispositivo | IP | Máscara | Gateway |
|-------------|----|---------|---------|
| R-PRINCIPAL Fa0/0 | 192.168.10.1 | 255.255.255.0 | — |
| SW-PRINCIPAL Vlan1 | 192.168.10.2 | 255.255.255.0 | 192.168.10.1 |
| SW-A Vlan1 | 192.168.10.3 | 255.255.255.0 | 192.168.10.1 |
| SW-B Vlan1 | 192.168.10.4 | 255.255.255.0 | 192.168.10.1 |
| SW-C Vlan1 | 192.168.10.5 | 255.255.255.0 | 192.168.10.1 |
| PC-1 | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 |
| PC-2 | 192.168.10.11 | 255.255.255.0 | 192.168.10.1 |
| PC-3 | 192.168.10.12 | 255.255.255.0 | 192.168.10.1 |
| PC-4 | 192.168.10.13 | 255.255.255.0 | 192.168.10.1 |
| PC-5 | 192.168.10.14 | 255.255.255.0 | 192.168.10.1 |
| PC-6 | 192.168.10.15 | 255.255.255.0 | 192.168.10.1 |
| PC-7 | 192.168.10.16 | 255.255.255.0 | 192.168.10.1 |
| PC-8 | 192.168.10.17 | 255.255.255.0 | 192.168.10.1 |
| LAP-1 | 192.168.10.18 | 255.255.255.0 | 192.168.10.1 |
| LAP-2 | 192.168.10.19 | 255.255.255.0 | 192.168.10.1 |
| LAP-3 | 192.168.10.20 | 255.255.255.0 | 192.168.10.1 |
| IMP-1 | 192.168.10.21 | 255.255.255.0 | 192.168.10.1 |
| IMP-2 | 192.168.10.22 | 255.255.255.0 | 192.168.10.1 |
| IMP-3 | 192.168.10.23 | 255.255.255.0 | 192.168.10.1 |
| MFP | 192.168.10.24 | 255.255.255.0 | 192.168.10.1 |
| SRV | 192.168.10.25 | 255.255.255.0 | 192.168.10.1 |
| TV-CORP | 192.168.10.26 | 255.255.255.0 | 192.168.10.1 |
| TEL-IP | DHCP (192.168.10.100) | 255.255.255.0 | 192.168.10.1 |

### Formato

Extensión: 2-3 párrafos. Incluir la tabla de direccionamiento IP. Usar lenguaje técnico pero claro, apropiado para un trabajo universitario de ingeniería.
