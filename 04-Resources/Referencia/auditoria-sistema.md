---
tags:
  - sistema/auditoria
  - tipo/referencia
created: 2026-07-07
---

# Auditoría del Sistema

## Hardware

| Componente | Detalle |
|---|---|
| **CPU** | Intel Core i3-N300 — 8 núcleos/8 hilos, 0.7–3.8 GHz |
| **GPU** | Intel UHD Graphics (Alder Lake-N) — iGPU, sin GPU dedicada |
| **RAM** | 7.5 GB (zram swap de 7.5 GB comprimido zstd) |
| **Almacenamiento** | NVMe CT1000P3SSD8 — 931.5 GB (327 GB partición root, 182 GB libres) |
| **Plataforma** | x86_64, CachyOS (Arch Linux rolling) |

> **Implicación IA:** Sin GPU dedicada. Los modelos locales corren exclusivamente por CPU. Modelos <3B params van bien; 7B+ serán lentos pero funcionales.

## Sistema Operativo

- **OS:** CachyOS (Arch Linux rolling)
- **Kernel:** 7.1.2-3-cachyos (PREEMPT_DYNAMIC)
- **Display Server:** Wayland
- **DE/WM:** Hyprland 0.55.4
- **Terminal:** kitty 0.47.1
- **Shell:** zsh + starship 1.26.0
- **Editor:** micro 2.0.15, VS Code 1.126.0
- **Sonido:** PipeWire + WirePlumber

## Paquetes del Sistema (311 instalados explícitos)

### Navegadores
- **Brave** (principal)
- **Firefox** 152.0.3
- **Chromium** 149.0.7827.200

### Desktop
- **Hyprland** 0.55.4 + hyprlock, hyprpaper, hyprpicker, hyprsunset, hyprlauncher
- **Waybar** 0.15.0 (con daemon hover + cells)
- **Swaync** 0.12.6 (notificaciones)
- **Dunst** 1.13.2 (notificaciones alternativo)
- **Wofi** 1.5.3 (launcher)
- **Wlogout** 1.2.2 (logout menu)
- **Mako** 1.11.0 (notificaciones)
- **Kitty** 0.47.1 (terminal principal)
- **Alacritty** 0.17.0 (terminal secundario)
- **SDDM** 0.21.0 (display manager)
- **KDE Plasma** 6.7.2 (dolphin, kate, spectacle, gwenview, okular, kcalc, konsole, etc.)
- **KDE Connect** (conexión con celular)

### Desarrollo
- **Node.js** 26.4.0 / **npm** 11.16.0 / **pnpm** 11.3.0 / **yarn** 1.22.22 / **bun** 1.3.14
- **Go** 1.26.4
- **Python** 3.14.6 + pip + pipx
- **Git** 2.55.0 + **GitHub CLI** 2.95.0 + **lazygit** 0.62.2 + **tig** 2.6.1
- **Docker** 29.6.1 + containerd
- **VirtualBox** 7.2.10 + **GNOME Boxes** 50.0
- **VS Code**, **IntelliJ IDEA CE**, **PyCharm CE**
- **Ollama** 0.31.1

### Networking
- **Tailscale** 1.98.8 (VPN mesh)
- **NetworkManager** + **iwd** (Wi-Fi)
- **OpenFortiVPN** 1.24.1
- **ufw** 0.36.2 (firewall)

### Creativo
- **Blender** 5.1.2
- **GIMP** 3.2.4, **Inkscape** 1.4.4, **Krita** 6.0.2
- **OBS Studio** 32.1.2

### Gaming
- **Minecraft Launcher**, **Modrinth App**, **Discord**
- Paquete `cachyos-gaming-meta`

### Utilidades
- **Syncthing** 2.1.1 (sincronización)
- **scrcpy** 4.0 (control celular por USB)
- **yt-dlp** (descarga videos)
- **OCR:** tesseract (eng, spa, jpn, kor) + script `easyocr`
- **ffmpeg**, **pipewire**, **grim** (screenshots), **wf-recorder** (grabación)
- **starship**, **btop**, **fastfetch**, **glances**, **nvtop**
- **reflector**, **pacman-contrib**, **paru**, **yay**

### IA / ML
- Paquetes pip: `numpy`, `pillow` (sistema). EasyOCR via pipx.
- **Ollama + moondream** (modelo local 1.7B params, phi2, visión + texto)
- No hay torch/tensorflow instalado globalmente.

## Node Global Packages

| Paquete | Función |
|---|---|
| `@anthropic-ai/claude-code` | Claude Code (Anthropic oficial) |
| `opencode-ai` | OpenCode AI |
| `@ngotrnghia1811/opencode-headroom` | Headroom para OpenCode |
| `obsidian-mcp` | MCP server para Obsidian |
| `svgo` | Optimización SVGs |
| `ui-ux-pro-max-cli` | CLI de UI/UX Pro Max |
| `bun` | JavaScript runtime |

## AI/Ollama — Modelos Locales

### moondream:latest
| Propiedad | Valor |
|---|---|
| **Arquitectura** | phi2 |
| **Parámetros** | 1.7B |
| **Contexto** | 2048 tokens |
| **Cuantización** | Q4_0 |
| **Tamaño** | ~1.7 GB |
| **Capacidades** | text completion + vision (CLIP projector 454M params) |
| **Uso** | Modelo multimodal ligero para descripción de imágenes, OCR, VQA |

> **Potencial:** Con ~7.5 GB RAM y CPU i3-N300, puedes correr modelos hasta ~3B-7B params. Recomendado: `deepseek-coder-v2` (coding), `qwen3-coder` (coding), `llama-3.2-3b` (general). Modelos 13B+ serán muy lentos en CPU.

## Proyectos de Desarrollo

| Proyecto | Ruta | Stack |
|---|---|---|
| **ponytail** | `~/ponytail/` | MCP plugin para OpenCode |
| **packet-tracer-mcp** | `~/packet-tracer-mcp/` | MCP server Packet Tracer (TypeScript) |
| **obsidian-vault** | `~/obsidian-vault/` | Vault Obsidian personal |
| **MiNegocio** | (en servidor 192.168.50.25) | Vue 3 + Go backend |

## OpenCode — Configuración

### MCP Servers

| Servidor | Tipo | Función |
|---|---|---|
| **obsidian** | local (npx) | Acceso a notas Obsidian |
| **dagu** | remote (8090) | Orquestación DAGs |
| **context7** | local (npx) | Documentación de librerías |
| **postgres** | local (npx) | DB `cliente_dev` en localhost |
| **github** | local (wrapper) | API GitHub |
| **playwright** | local (npx) | Automatización navegador |
| **packet-tracer** | local (uvx) | Simulación redes Cisco |

### Plugins
`ponytail`, `claude-mem`, `dcp`, `plannotator`, `wakatime`, `vibeguard`, `notificator`, `websearch-cited`, `goal-plugin`

## Scripts Personalizados (~/.local/bin)

### Waybar / Barra
| Script | Función |
|---|---|
| `waybar-hover-daemon` | Daemon hover expandible dual-mode |
| `waybar-cells-daemon` | Daemon cells para waybar |
| `waybar-cells-gen` | Generador de CSS cells |
| `toggle-waybar-mode` | Cambia modo modern ↔ legacy |
| `toggle-waybar-design` | Alterna diseño waybar |
| `waybar-reload` | Recarga waybar |

### Hyprland / WM
| Script | Función |
|---|---|
| `hyprctl` | Wrapper para hyprctl |
| `hypr-active-monitor` | Detecta monitor activo |
| `hypr-audio` | Control de audio vía piping |
| `hypr-keyhint` | Muestra atajos de teclado |
| `hyprkeys` / `hyprkeys-gui` | Atajos de teclado (GUI) |
| `hypr-mimehint` | Hint de MIME types |
| `hypr-preview` | Preview de ventanas |
| `hypr-toast` | Toast notifications |
| `hypr-player` | Reproductor multimedia |
| `hyprnotify` | Notificaciones (compilado) |
| `hyprsunset` | Reducción luz azul (compilado) |

### Hardware / Periféricos
| Script | Función |
|---|---|
| `brightness` | Control brillo general |
| `brightness-edp` | Brillo pantalla laptop |
| `brightness-hdmi` | Brillo monitor externo |
| `brightness-cursor` | Brillo con cursor interactivo |
| `brightness-edp-scroll` | Brillo por scroll |
| `battery` | Estado batería |
| `bluetooth` | Control Bluetooth |
| `dnd` | Do Not Disturb |
| `power` | Menú de energía |
| `pulseaudio` | Control volumen |

### Audio / Micrófono
| Script | Función |
|---|---|
| `audiosource` | Selección fuente audio |
| `mic-celular` | Usar celular como micrófono |
| `mic-help` | Ayuda micrófono |
| `status-audio` | Estado audio actual |
| `setup-virtual-mic.sh` | Configurar micrófono virtual |
| `toggle-buds-mode` | Cambiar modo buds |

### MPRIS / Multimedia
| Script | Función |
|---|---|
| `mpris-music` | Now playing (música) |
| `mpris-vlc` | Now playing (VLC) |
| `mpris-yt` | Now playing (YouTube) |
| `clock` | Reloj en barra |

### Red
| Script | Función |
|---|---|
| `network` | Estado/control WiFi |

### Sistema
| Script | Función |
|---|---|
| `updates` | Verificar actualizaciones |
| `settings` | Abrir configuraciones |
| `lock-poweroff` | Bloquear + apagar |
| `lock-reboot` | Bloquear + reiniciar |
| `toggle-compact` | Alternar modo compacto |
| `toggle-reload` | Recargar toggle |
| `run-scaled` | Ejecutar app con escala |

### Obsidian / Backup
| Script | Función |
|---|---|
| `obsidian-sync` | Sincronizar vault |
| `obsidian-sync.sh` | Sincronizar (variante) |
| `vault-sync` | Sincronizar vault (otro) |
| `backup-opencode-config` | Backup configuración OpenCode |
| `restore-opencode-config` | Restaurar backup |
| `opencode-sandbox` | Sandbox para MCPs experimentales |

### Utilidades
| Script | Función |
|---|---|
| `grimblast` | Screenshots (grim + slurp) |
| `ocr` | OCR con EasyOCR |
| `margin-compute` | Calcular márgenes waybar |
| `right-spacer` | Espaciador derecho waybar |
| `resources` | Monitor recursos |
| `git-status` | Estado git rápido |
| `deriva` / `deriva-dev` | Atajos a proyectos |

### Suwayomi (Manga)
| Script | Función |
|---|---|
| `suwayomi` | Iniciar Suwayomi server |
| `suwayomi-sync` | Sincronizar con celular |
| `suwayomi-backup-import` | Importar backup |
| `suwayomi-phone-backup` | Backup desde celular |
| `suwayomi-phone-setup` | Setup inicial |
| `suwayomi-phone-guide` | Guía de conexión |

### Otros
| Script | Función |
|---|---|
| `discord-launch` | Launch Discord con flags |
| `taiga-report` | Reporte de tiempo en Taiga |
| `linkear` | Crear symlinks |
| `xwayland-scale-config` | Configurar escala XWayland |
| `zen-pip-toggle` | Toggle picture-in-picture Zen |
| `zen` | Zen Browser (symlink) |
| `obsidian` | Obsidian (symlink) |
| `gh` | GitHub CLI (binario) |
| `dagu` | Dagu workflow engine (binario) |
| `uv` / `uvx` | Python package manager |
| `easyocr` | EasyOCR (via pipx) |
| `headroom` | Headroom AI (via uv) |
| `github-mcp-wrapper` | Wrapper GitHub MCP |

## Servicios Systemd

### Usuario
| Servicio | Función |
|---|---|
| `waybar.service` | Barra Waybar |
| `waybar-hover-daemon.service` | Daemon hover expandible |
| `waybar-cells-daemon.service` | Daemon cells |
| `dagu.service` | DAG workflow engine |
| `claude-mem.service` | Memoria persistente Claude |
| `syncthing.service` | Sincronización archivos |
| `pipewire.service` / `pipewire-pulse.service` | Audio |
| `wireplumber.service` | Gestión sesión audio |
| `hyprsunset.service` | Reducción luz azul |
| `blueman-applet.service` | Applet Bluetooth |
| `gnome-keyring-daemon.service` | Keyring |

### Sistema
| Servicio | Función |
|---|---|
| `docker.service` + `containerd.service` | Contenedores |
| `tailscaled.service` | VPN mesh |
| `NetworkManager.service` | Gestión redes |
| `bluetooth.service` | Bluetooth |
| `sddm.service` | Display Manager |
| `ananicy-cpp.service` | Auto nice de procesos |
| `power-profiles-daemon.service` | Perfiles energía |

## Configuraciones Waybar

- **Dual-mode:** modern (per-module hover) ↔ legacy (global hover) via `toggle-waybar-mode`
- **Daemon:** `waybar-hover-daemon` escribe `waybar-hover-module` (modern) o `waybar-hover-group` (legacy)
- **Backups:** config/style `.legacy`, `.modern`, `.bak.*` en `~/.config/waybar/`
- **Directorio bak:** `bak/20260625-working/` snapshot completo
- **Scripts:** `legacy-scripts/` (global-hover), `modern-scripts/` (per-module)

## Configuraciones Hyprland

- `hyprland.lua` — Config principal en Lua
- `hyprlock.conf` — Pantalla de bloqueo
- `hyprpaper.conf` — Fondos de pantalla
- `hyprsunset.conf` — Filtro luz azul
- `scripts/` — Scripts asociados

## Backup / Restauración

- `backup-opencode-config` → `~/.config/opencode/backups/opencode-{timestamp}.tar.gz`
- `restore-opencode-config` → Menú interactivo de backups
- Scripts en `~/.local/bin/`

## Notas Finales

### Capacidad IA Local
| Modelo | Params | RAM | Velocidad estimada en CPU i3-N300 |
|---|---|---|---|
| moondream | 1.7B | ~2 GB | Rápido |
| qwen3-coder / deepseek-coder-v2 | ~3-4B | ~3-4 GB | Bueno |
| llama-3.2-3b | 3B | ~3 GB | Bueno |
| llama-3.1-8b / qwen3-8b | 8B | ~6-7 GB | Lento pero usable |
| deepseek-r1:7b | 7B | ~6 GB | Lento |
| modelos 13B+ | 13B+ | >10 GB | No recomendado sin GPU |

### Para usar OpenCode con Ollama
```bash
ollama pull deepseek-coder-v2
ANTHROPIC_BASE_URL=http://localhost:11434 opencode
```

### Estado Actual
- OpenCode activo en sesión de auditoría
- 182 GB libres en disco
- ~2.4 GB RAM disponible
- Ollama funcionando con modelo moondream
