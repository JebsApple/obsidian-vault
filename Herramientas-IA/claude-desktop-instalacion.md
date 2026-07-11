---
tags:
  - claude
  - instalacion
  - inventario
---
+# Claude Desktop — Instalación y componentes

Instalado en CachyOS (Arch Linux) vía `paru -S claude-desktop-bin` el 2026-07-03.

## Paquetes instalados

| Paquete | Versión | Fuente |
|---------|---------|--------|
| `claude-desktop-bin` | 1.18286.0-1 | AUR |
| `@anthropic-ai/claude-code` | 2.1.200 | npm global |

## Binarios

| Ruta | Tipo |
|------|------|
| `/usr/bin/claude-desktop` | Desktop app (Electron) |
| `~/.npm-global/bin/claude` | CLI (npm) |

## Directorios de configuración y datos

| Ruta | Tamaño | Propósito |
|------|--------|-----------|
| `~/.claude/` | 956 MB | Config, agents, sessions, skills, MCP, telemetría |
| `~/.claude.json` | 42 KB | Config principal CLI |
| `~/.config/Claude/` | — | Config desktop (`claude_desktop_config.json`) |
| `~/.claude-mem/` | — | Memoria persistente (SQLite + logs) |
| `~/.cache/claude-desktop/` | — | Caché desktop |
| `~/.cache/claude-cli-nodejs/` | — | Caché CLI |

## Extensiones VS Code

- `anthropic.claude-code-2.1.191-linux-x64`
- `anthropic.claude-code-2.1.195-linux-x64`

## Systemd

- `~/.config/systemd/user/claude-mem.service` — demonio de memoria persistente

## Archivos de sistema

| Ruta | Propósito |
|------|-----------|
| `/usr/share/applications/claude-desktop.desktop` | Lanzador |
| `/usr/share/fish/completions/claude.fish` | Completions Fish |
| `/usr/share/licenses/claude-desktop-bin/` | Licencias |
| `/usr/share/keyrings/claude-desktop-archive-keyring.asc` | Clave GPG (repo Anthropic) |
| `/var/lib/pacman/local/claude-desktop-bin-1.18286.0-1/` | Registro pacman |

## Documentos relacionados en este vault

- [[claude-tools-instalacion]]
- [[configuracion-sesiones-ia]]
- [[ECC-Instalacion]]
- [[memoria-persistente]]
