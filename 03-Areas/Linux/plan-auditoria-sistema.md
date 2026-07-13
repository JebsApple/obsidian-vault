---
created: 2026-07-12
tags:
  - area/linux
  - tipo/playbook
  - sistema/cachyos
aliases:
  - Plan Auditoría Sistema
---

# Plan de Auditoría y Reparación del Sistema

Playbook ejecutable por opencode (o cualquier agente) para auditar y reparar este sistema desde la perspectiva de Fable. Basado en auditoría real del [[auditoria-sistema-2026-07-12|2026-07-12]].

**Sistema:** CachyOS, Hyprland (config Lua: `~/.config/hypr/hyprland.lua`), caelestia-dots (quickshell), 7.5 GB RAM, zram + swap disco 8 GB, claude-mem plugin.

**Herramienta rápida:** `audit-sistema` (status), `audit-sistema --fix` (fixes sin sudo), `audit-sistema --quick` (solo crítico). Exit code = cantidad de FAILs.

## Reglas para el agente

1. **Diagnóstico antes de acción.** Nunca matar/reiniciar/borrar sin evidencia que apunte a ESA causa.
2. **sudo no funciona desde tool de agente** — generar script y pedir al usuario ejecutarlo.
3. **No tocar configs de producción a ciegas:** `opencode.json` va por `opencode-sandbox`; `hyprland.conf` NO tiene efecto (config real es `hyprland.lua`).
4. **Solo matar procesos huérfanos (PPID 1)** — procesos con padre vivo son sesiones activas.
5. Documentar hallazgos nuevos en nota de auditoría fechada en `03-Areas/Linux/`.

## Fase 1 — Crítico (cada vez)

| Check | Comando | Umbral FAIL | Reparación |
|-------|---------|-------------|------------|
| Fuga chroma-mcp | `pgrep -fc chroma-mcp` + contar PPID 1 | >10 huérfanos | Matar huérfanos (2 pases, hijos quedan huérfanos tras 1º). Causa: mismatch versión claude-mem worker/plugin — verificar en `~/.claude-mem/logs/` que `workerVersion == pluginVersion`; si no, actualizar plugin y reciclar worker (`kill $(pid en ~/.claude-mem/worker.pid)`) |
| Swap | `free` | ≥90% | Identificar consumidores: `awk /VmSwap/ /proc/*/status`. Si es fuga conocida, limpiar. Si no, investigar antes de matar |
| Servicios fallidos | `systemctl --failed` y `systemctl --user --failed` | cualquiera | Ver `journalctl -u <unit> -n 20`. Conocidos: `systemd-hibernate` falla si RAM saturada (síntoma, no causa — arreglar memoria primero); `mako` debe estar DESHABILITADO (caelestia-shell provee notificaciones, conflicto DBus) |

## Fase 2 — Salud general

| Check | Comando | Acción |
|-------|---------|--------|
| Updates | `checkupdates \| wc -l` | >30: proponer `sudo pacman -Syu` (script para usuario) |
| .pacnew | `find /etc -name '*.pacnew'` | `sudo pacdiff` — **merge manual** para `pacman.conf` y `pam.d/sudo`, nunca sobrescribir ciego |
| Huérfanos pacman | `pacman -Qdtq` | Listar y proponer `sudo pacman -Rns -` |
| Disco raíz | `df /` | ≥80%: buscar con `du -xh / 2>/dev/null \| sort -rh \| head`, limpiar `~/.cache`, `paccache -r` |
| Journal | `journalctl -p 3 -b` | Filtrar ruido conocido (ver abajo). Errores nuevos: investigar causa raíz en vez de silenciar |

## Fase 3 — Escritorio (caelestia/Hyprland)

- `hyprctl configerrors` debe salir vacío
- `pgrep -f 'qs -c caelestia'` debe existir (shell corriendo)
- `~/.face` debe existir (avatar lockscreen; se setea desde dashboard caelestia)
- `~/.config/caelestia/shell.json` existe (si falta, usa defaults — no es error)
- Logs shell: `journalctl --user -t qs -p 4`

## Ruido conocido (NO reparar, es benigno)

| Mensaje | Causa |
|---------|-------|
| `ddcutil ... VCP feature xDF ... DDCRC_REPORTED_UNSUPPORTED` | Monitor no soporta esa feature DDC; caelestia Brightness la consulta igual |
| `qs: PAM _pam_init_handlers: no default config other` | caelestia usa pam.d propio (fprint+passwd) sin `other`; sin lector de huellas |
| `kded6: applications.menu not found` | App KDE bajo Hyprland; opcional instalar `archlinux-xdg-menu` |
| `bluetoothd ... Transport endpoint is not connected` | Reconexión de audífonos BT, transitorio |

## Historial de incidentes

- **2026-07-12:** [[auditoria-sistema-2026-07-12]] — fuga chroma-mcp (~255 procesos, swap 15/15 GB), mako en conflicto con caelestia, hibernación rota por RAM saturada. Scripts: `fix-audit-20260712`, `audit-sistema`.
- **2026-07-12 22:34:** rampage del OOM killer al llenarse la swap (consecuencia de la fuga): mató wireplumber, pipewire-pulse, syncthing, speech-dispatcher, arch-update-tray, kactivitymanagerd; coredumps de gcr-prompter y xdg-desktop-portal-hyprland. Todos quedaron en `start-limit-hit`. Reparación: `systemctl --user reset-failed && systemctl --user restart wireplumber pipewire-pulse syncthing arch-update-tray`. Lección: tras evento OOM, los servicios fallidos son víctimas, no causas — reset-failed + restart, no debug individual. obex y speech-dispatcher son dbus-activated: inactivos = normal.

## Flujo recomendado (opencode)

```
1. audit-sistema            # status
2. Si FAILs: audit-sistema --fix   # fixes sin sudo
3. Si quedan FAILs con sudo: generar script en ~/.local/bin/ y pedir al usuario correrlo
4. Verificar: audit-sistema --quick (exit 0 = sano)
5. Hallazgo nuevo → agregar a "Ruido conocido" o "Historial" según corresponda
```
