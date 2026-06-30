# Reporte de instalación — OpenCode + plugins en servidor (2026-06-30)

## Plugins instalados (npm)

| Plugin | Estado |
|--------|--------|
| `@tarquinen/opencode-dcp` | ✅ context pruning |
| `@plannotator/opencode` | ✅ plan review |
| `opencode-wakatime` | ✅ time tracking |
| `opencode-vibeguard` | ✅ secret redaction |
| `opencode-websearch-cited` | ✅ web search con citas |
| `@prevalentware/opencode-goal-plugin` | ✅ goal mode |
| `claude-mem` | ✅ memoria persistente |
| `opencode-notificator` | ❌ no existe en registry npm |

## MCPs configurados

| MCP | Tipo | Puerto |
|-----|------|--------|
| obsidian | local (npx) | — |
| context7 | local (npx) | — |
| postgres | local (npx) | 5432 |
| github | Docker (`ghcr.io/github/github-mcp-server`) | — |
| playwright | local (npx) | — |
| dagu | local (binary) | 8090 |

## Servicios systemd user

| Servicio | Estado | Puerto |
|----------|--------|--------|
| `claude-mem.service` | ✅ running | 37700 |
| `dagu.service` | ✅ running | 8090 |

## Dagu

- Versión: 2.8.3
- Binario: `~/.local/bin/dagu`
- DAGs: `~/.config/dagu/dags`

## Config

Archivo: `~/.config/opencode/opencode.jsonc`

**Nota:** GitHub MCP necesita `GITHUB_PERSONAL_ACCESS_TOKEN` en el entorno para funcionar.
