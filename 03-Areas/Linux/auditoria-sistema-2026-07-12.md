---
created: 2026-07-12
tags:
  - area/linux
  - tipo/auditoria
  - sistema/cachyos
---

# Auditoría de Sistema — 2026-07-12

Auditoría completa post-migración a caelestia-dots. Priorización MoSCoW.

## Hallazgos y Estado

### MUST (críticos)

| # | Falla | Causa raíz | Estado |
|---|-------|-----------|--------|
| 1 | ~100 procesos `chroma-mcp` huérfanos, swap 12/15 GB llena | claude-mem plugin 13.10.4 vs worker 13.10.3: cada hook intenta reciclar worker, spawnea chroma-mcp nuevo y el viejo queda huérfano (loop infinito) | Script `fix-audit-20260712` parte A |
| 2 | `mako.service` failed en cada login | caelestia-shell (quickshell) ya provee `org.freedesktop.Notifications` — conflicto DBus | ✅ Deshabilitado (`systemctl --user disable --now mako`) |
| 3 | Hibernación falla: "Image allocation is 251512 pages short" | RAM 7.5 GB saturada por la fuga #1 — no hay memoria para armar la imagen de hibernación. Con #1 arreglado debería funcionar | Verificar tras limpieza |

### SHOULD

| # | Falla | Fix |
|---|-------|-----|
| 4 | 49 updates pacman pendientes | `sudo pacman -Syu` (script parte B) |
| 5 | 7 archivos `.pacnew` sin merge (incl. `pacman.conf`, `pam.d/sudo`, mirrorlists) | `sudo pacdiff` — merge manual, no sobrescribir ciego |
| 6 | ~15 paquetes huérfanos (gtk2, nvm, go, llvm21-libs…) | `pacman -Qdtq \| sudo pacman -Rns -` (script parte B) |

### COULD (cosmético)

| # | Ruido | Nota |
|---|-------|------|
| 7 | `~/.face` no existe — error en lockscreen/dashboard caelestia | Setear foto desde dashboard de caelestia (facePicker) o copiar imagen a `~/.face` |
| 8 | Spam ddcutil "VCP feature xDF unsupported" en journal | Monitor no soporta esa feature DDC; caelestia Brightness.qml la consulta igual. Benigno |
| 9 | `qs: PAM _pam_init_handlers: no default config other` | caelestia usa pam.d propio (fprint+passwd) sin archivo `other`; sin lector de huellas genera warning. Benigno |
| 10 | kded6: `applications.menu not found` | App KDE bajo Hyprland; instalar `archlinux-xdg-menu` si molesta |

## Script de reparación

`~/.local/bin/fix-audit-20260712` — parte A sin sudo (limpia huérfanos + recicla worker claude-mem), parte B con sudo (updates, orphans, pacnew).

## Lección

Plugin con worker persistente + mismatch de versión = fuga de procesos silenciosa. Síntoma visible: swap llena, hibernación rota. Diagnóstico: `ps -eo pid,ppid,etime,cmd` + contar procesos por nombre; huérfanos tienen PPID 1.
