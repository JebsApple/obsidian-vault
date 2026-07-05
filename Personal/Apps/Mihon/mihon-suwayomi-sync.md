---
tags: [proyecto, manga, red-local, en-progreso]
---

# Sync Mihon ↔ Suwayomi

Objetivo: que Mihon (Android) y Suwayomi (PC) estén sincronizados automáticamente — capítulos leídos y biblioteca — sin transferir backups manualmente.

## Solución elegida

Usar **Suwayomi como servidor central**. Mihon actúa como cliente via la extensión Suwayomi (Keiyoushi).  
Red privada via **Tailscale** para conectar PC y celu sin importar la red física.

## Estado actual

- [x] Tailscale instalado y autenticado en PC (`100.95.15.125`)
- [x] Tailscale instalado en celu (Redmi Note 13 5G, `100.103.142.37`)
- [x] Suwayomi v2.3.2232 corriendo (actualizado manualmente, JAR reemplazado)
  - PID activo, escucha en `*:4567`
  - Responde OK en localhost
  - Service disabled (no prende al inicio, se controla con `suwayomi` script)
- [x] FlareSolverr corriendo en Docker (puerto 8191)
- [x] Extensión Suwayomi instalada en Mihon
- [x] Script `~/.local/bin/suwayomi` para control manual (`suwayomi open/stop/status`)
- [x] Desktop entry actualizado (Suwayomi en Super+D → prende server + abre UI)
- [ ] URL en extensión Mihon: **`http://100.95.15.125:4567`** (Tailscale IP, no la local)
- [ ] Conexión PC ↔ celular funcional — **usar Tailscale IP**
- [ ] Migración de biblioteca Mihon → fuente Suwayomi
- [ ] Probar sync de leídos (SyncYomi incluido en v2.3.2232)

## Comandos útiles

```bash
suwayomi open     # prende Suwayomi (si apagado) y abre UI en Brave
suwayomi stop     # apaga el server
suwayomi status   # ver si está corriendo
```

## SyncYomi (NUEVO en v2.3.2232)

Esta versión agrega soporte **SyncYomi**, que permite sincronizar mangas con forks de Mihon.  
Revisar settings de la extensión Suwayomi en Mihon para opciones de sync.

## Referencia rápida

| Qué | Valor |
|-----|-------|
| Tailscale IP PC | `100.95.15.125` |
| Tailscale IP celu | `100.103.142.37` |
| Puerto Suwayomi | 4567 |
| URL para Mihon | `http://100.95.15.125:4567` |
| Extensión | Suwayomi (repo Keiyoushi) |
| Script control | `suwayomi {open\|stop\|status}` |
