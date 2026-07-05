---
tags: [proyecto, manga, red-local, completado]
---

# Sync Mihon ↔ Suwayomi

Objetivo: que Mihon (Android) y Suwayomi (PC) estén sincronizados automáticamente — capítulos leídos y biblioteca — sin transferir backups manualmente.

## Solución elegida

Usar **Suwayomi como servidor central**. Mihon actúa como cliente via la extensión Suwayomi.  
Red privada via **Tailscale** para conectar PC y celu sin importar la red física.

## Cómo funciona el sync (tracker, no SyncYomi)

La extensión Suwayomi en Mihon funciona como **tracker implícito** (no se configura en Ajustes → Tracking):

- **Mihon → PC:** Automático al marcar capítulo como leído (GraphQL escribe en el servidor)
- **PC → Mihon:** Manual — abrir manga → Tracking → Suwayomi → jala estado del servidor

SyncYomi es un servidor aparte (puerto 8282) que NO está instalado. No hace falta.

## Estado actual

- [x] Tailscale instalado y autenticado en PC (`100.95.15.125`)
- [x] Tailscale instalado en celu (Redmi Note 13 5G, `100.103.142.37`)
- [x] Suwayomi v2.3.2232 corriendo (actualizado manualmente, JAR reemplazado)
- [x] Extensión Suwayomi instalada en Mihon
- [x] URL configurada en Mihon: **`http://100.95.15.125:4567`** (Tailscale IP)
- [x] Conexión funcional via Tailscale (ambos en la misma tailnet)
- [x] Backup Mihon importado a Suwayomi vía Taildrop (452 mangas en servidor)
- [x] Script `~/.local/bin/suwayomi` — control manual (`suwayomi open/stop/status`)
- [x] Script `~/.local/bin/suwayomi-backup-import` — importa backups `.tachibk` a Suwayomi
- [x] Timer systemd: cada 5 min busca backups nuevos en `~/Descargas/` y los importa
- [ ] Migración de mangas en Mihon a fuente Suwayomi (para que sincronicen)

## Comandos útiles

```bash
suwayomi open              # prende Suwayomi (si apagado) y abre UI en Brave
suwayomi stop              # apaga el server
suwayomi status            # ver si está corriendo
suwayomi-backup-import     # importa backups .tachibk nuevos (auto-detecta en Descargas)
suwayomi-backup-import /ruta/archivo.tachibk   # importa uno específico
```

## Transferencia automática de backup (Taildrop)

1. Mihon → Ajustes → Datos → Crear backup (manual o automático)
2. App Tailscale en celu → Taildrop → enviar `.tachibk` a **gris**
3. PC lo recibe con `tailscale file get ~/Descargas/` o automático si hay timer
4. Script lo importa a Suwayomi via GraphQL

El timer `suwayomi-backup-import.timer` revisa cada 5 min. Servicio user:
```bash
systemctl --user status suwayomi-backup-import.timer
```

## Referencia rápida

| Qué | Valor |
|-----|-------|
| Tailscale IP PC | `100.95.15.125` |
| Tailscale IP celu | `100.103.142.37` |
| Puerto Suwayomi | 4567 |
| URL para Mihon | `http://100.95.15.125:4567` |
| Extensión | Suwayomi |
| Script control | `suwayomi {open\|stop\|status}` |
| Script import | `suwayomi-backup-import` |
| Timer import | `suwayomi-backup-import.timer` (c/5 min) |
