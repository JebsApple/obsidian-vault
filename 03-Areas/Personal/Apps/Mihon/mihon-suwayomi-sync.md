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
- [x] Migración de mangas en Mihon a fuente Suwayomi (para que sincronicen)

## Comandos útiles

```bash
suwayomi open              # prende Suwayomi (si apagado) y abre UI en Brave
suwayomi stop              # apaga el server
suwayomi status            # ver si está corriendo
suwayomi-backup-import     # importa backups .tachibk nuevos (auto-detecta en Descargas)
suwayomi-backup-import /ruta/archivo.tachibk   # importa uno específico
suwayomi-sync              # GUI con botón Sync Now + auto-watch
```

## PC: GUI `suwayomi-sync`

App con interfaz gráfica (tkinter) para monitorear el sync:

- **Botón "Sync Now"** → busca el .tachibk más nuevo en la carpeta y lo importa
- **Auto-watch** → revisa cada 15s si llegó un backup nuevo
- **Status** → muestra server health, cantidad de mangas, último sync
- **Notificaciones** → `notify-send` cuando importa algo
- **Desktop entry**: `suwayomi-sync.desktop` (buscá "Suwayomi Sync" en apps)

Usa el mismo backend que `suwayomi-backup-import` (GraphQL Upload).

## Transferencia automática de backup (Taildrop)

1. Mihon → Ajustes → Datos → Crear backup (manual)
2. App Tailscale en celu → Taildrop → enviar `.tachibk` a **gris**
3. PC lo recibe automático en `~/Descargas/`
4. `suwayomi-sync` (auto-watch) o timer lo importan

El timer `suwayomi-backup-import.timer` revisa cada 5 min. Servicio user:
```bash
systemctl --user status suwayomi-backup-import.timer
```

## Sync Obsidian bidireccional (Syncthing)

Para tener las notas de Obsidian sincronizadas entre PC y celu sin nube:

1. **PC:** `syncthing` instalado y corriendo via systemd --user
   - Web UI: `http://127.0.0.1:8384`
   - Device ID: `4HZ7NSR-VZK57K5-2HUISMB-6ZUO5MV-DXEIUP3-MMUGPNP-2WJKZEK-Q7U5QQ2`
   - Carpeta: `~/obsidian-vault` (sendreceive, bidireccional)
   - `.stignore` excluye `.git/`, `.obsidian/caches/`, `.obsidian/workspace*`
2. **Android:** Instalar "Syncthing-Fork" desde F-Droid o Play Store
   - Agregar dispositivo con el Device ID de arriba
   - Aceptar carpeta compartida "Obsidian Vault"
   - Dirección directa: `tcp://100.95.15.125:22000` (via Tailscale, sin usar relays públicos)
3. Los cambios se replican automáticamente en ambos lados

## Tile en cortina de notificaciones (Redmi)

Para un botón rápido en el celu que saque el backup y lo mande a la PC:

**Opción A — Macrodroid (recomendada):**
1. Instalar Macrodroid desde Play Store
2. Crear macro: Trigger → "Quick Settings Tile"
3. Acciones: Open App (Mihon) → Wait 10s → Share File → elegir .tachibk más reciente
4. En share picker, elegir Tailscale → destino "gris"
5. Editar cortina → agregar tile "Sync Suwayomi"

**Opción B — Termux + Tasker:**
1. `pkg install tailscale` en Termux, autenticar
2. Script: `tailscale file cp /ruta/backup.tachibk gris`
3. Tasker: Quick Settings Tile → Run Script

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
| GUI sync | `suwayomi-sync` |
| Timer import | `suwayomi-backup-import.timer` (c/5 min) |
| Guía celu | `suwayomi-phone-setup` |
