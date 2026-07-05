---
tags: [proyecto/minegocio, packet-tracer, estado/auditoria]
---

# Auditoria Caso05 --- Packet Tracer via MCP

## Estado actual (2026-07-05)

### Lo que funciona bien

| Componente | Metodo usado | Status |
|-----------|-------------|--------|
| Bridge MCP -> PT | Extension mcp-bridge.pts en PT Scripting | Conexion estable |
| Topologia basica (23 devices) | pt_query_topology / CDP | Detectada |
| VLANs 10/20/30/40 + trunks | pt_apply_switching | Creadas en todos los switches |
| Access ports Fa0/1-6 -> VLAN 40 | pt_apply_switching (accessPorts) | Asignados |
| Subinterfaces router (.10 .20 .30 .40) | pt_configure_subinterface | Up con IPs correctas |
| SVI Vlan40 SW-PRINCIPAL | pt_run_cli (enable -> conf t -> int vlan 40 -> ip add 192.168.10.46/28 -> no shut) | 192.168.10.46/28 up/up |
| DHCP pool VOZ | pt_run_cli en R-PRINCIPAL | Red .32/28, default-router .33, option 150 |
| CME telephony | pt_run_cli en R-PRINCIPAL | max-ephones 1, max-dn 1, ephone-dn 1 num 100 |
| Static IPs area tecnica | pt_set_pc (mode: static) | SRV .34, MFP .35, TV-CORP .36, LAP-3 .37, IMP-3 .38 |
| DUPLICATE_IP .33 | Resuelto (SVI Vlan40 .46, router .33) | Corregido |
| Save .pkt | pt_save_pkt | ~97KB, SHA-1 verificable |

### Lo que se complico

| Problema | Sintoma | Causa |
|----------|---------|-------|
| pt_run_cli_bulk no funciona | "empty output", comandos no persisten | Cada sesion CLI es efimera; bulk envia comandos sin esperar prompt correcto |
| pt_apply_services fallo | "expected name, got poolName" | Schema espera dhcpPools[].name, no poolName |
| pt_apply_voip fallo | "expected sourceIp, maxDn" | Schema espera sourceIp (string), maxDn (number) |
| Sesion CLI no persiste | Cada pt_run_cli empieza en user mode (>) | Siempre mandar enable primero en cada llamada |
| Paginacion --More-- | Outputs truncados | terminal length 0 no soportado en 2960-24TT |
| show run interface VlanX | "Invalid input" | Usar show interfaces VlanX en su lugar |
| Switches acceso sin enable | show commands limitados | Usar enable explicito en cada pt_run_cli |

### Pendientes para Claude

1. **SVIs de acceso:** Verificar SW-A Vlan10 (IP .6/29), SW-B Vlan20 (.14/29), SW-C Vlan30 (.22/29) con:
   - `pt_run_cli(device="SW-A", command="show interfaces Vlan10")`
   Si no existen, crearlas via pt_run_cli:
   - enable -> conf t -> interface vlan 10 -> ip address 192.168.10.6 255.255.255.248 -> no shut -> exit -> ip default-gateway 192.168.10.1 -> end

2. **TEL-IP en DHCP:** Forzar renew desde PT UI o con `pt_set_pc(device="TEL-IP", mode="dhcp")` --- el pool VOZ ya esta configurado en R-PRINCIPAL.

3. **DUPLICATE_IP 0.0.0.0:** Es cosmetico (Bluetooth, Vlan1 shutdown). Ignorar.

4. **Verificar reachability:** Desde R-PRINCIPAL hacer `ping 192.168.10.46` (SVI SW-PRINCIPAL) y `ping 192.168.10.34` (SRV).

5. **Default gateways:** Confirmar que switches de acceso tengan `ip default-gateway <gw>`:
   - SW-A -> 192.168.10.1
   - SW-B -> 192.168.10.9
   - SW-C -> 192.168.10.17

6. **Guarda final:** `pt_save_pkt(path="/home/apuru/pt/saves/Caso05_Herrera_Soncco.pkt", overwrite=true)`

### Tips utiles

- Usar `pt_run_cli` (singular), nunca `pt_run_cli_bulk`
- Siempre anteponer `enable\n` al comando, ej: `enable\nshow interfaces Vlan40`
- pt_apply_switching funciona bien para VLANs + trunks + accessPorts
- pt_set_pc requiere `mode: "static"` o `mode: "dhcp"`
- Schema de DHCP: dhcpPools[].name (no poolName), dhcpPools[].option150
- Schema de VoIP: sourceIp (string), maxDn (number), maxEphones
- pt_configure_subinterface funciona bien (usar FastEthernet0/0)
- Cada llamada pt_run_cli abre nueva sesion --- siempre empezar con enable

## Resumen para Claude

Configuracion v4 aplicada parcialmente via MCP. VLANs, router-on-a-stick, DHCP, CME y area tecnica estan. Faltan SVIs de acceso, DHCP para TEL-IP, y verificacion de conectividad. Ver archivo .pkt en `/home/apuru/pt/saves/Caso05_Herrera_Soncco.pkt`.
