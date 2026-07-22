---
tags: [ia/claude, homelab, syncthing, referencia]
fuente: https://www.tododeia.com/community/syncthing-claude
---

# Syncthing — sincronizar ~/.claude entre computadoras

Sincroniza agentes, skills y proyectos de Claude entre máquinas. Gratis, P2P, sin cuentas ni servidor intermediario — encaja con el uso ya existente de Syncthing en el homelab (ver `08-homelab-infrastructure.md`).

## Instalación

- **Arch/CachyOS**: `sudo pacman -S syncthing && systemctl --user enable --now syncthing.service` (ya instalado en este sistema)
- **macOS**: `brew install syncthing && brew services start syncthing`
- **Windows**: `choco install syncthing`

## Configuración

1. Panel web: `http://127.0.0.1:8384`
2. "Add Folder" → nombre (ej. "Claude") → path `~/.claude` → anotar **Folder ID**
3. Anotar **Device ID** (Actions → Show ID)
4. En cada máquina adicional: instalar Syncthing, "Add Remote Device", pegar Device ID de la primera máquina, aceptar conexión + carpeta compartida entrante, apuntar a `~/.claude` local
5. Verificar: panel debe mostrar "Up to Date" en todos los dispositivos; probar con archivo de prueba

## Detalles clave

- **Carpeta a sincronizar**: `~/.claude`
- **Conflictos**: Syncthing preserva ambas versiones con sufijo `.sync-conflict-` en ediciones simultáneas
- **Requisito**: al menos dos máquinas online ocasionalmente (no hace falta simultaneidad)
