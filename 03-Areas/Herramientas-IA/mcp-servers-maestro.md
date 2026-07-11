---
title: MCP Servers — Registro Maestro
date: 2026-07-11
tags:
  - herramientas-ia
  - mcp
  - claude
  - opencode
status: activo
---

# MCP Servers — Registro Maestro

Fuente de verdad tras homogenización (ver [[plan-homogenizacion-claude-opencode]]).
Regla: **cambios de MCP se hacen con `claude mcp add/remove`** (persisten en `~/.claude.json`,
proyecto `/home/apuru`). Editar `~/.claude/settings.json` con clave `mcpServers` NO tiene efecto
— `claude mcp list` no lee de ahí (bug descubierto en esta sesión, ya limpiado).

## Tabla de estado (2026-07-11)

| MCP | Claude Code | Claude Desktop | OpenCode | Comando/versión |
|-----|:---:|:---:|:---:|-----|
| obsidian | ✔ | ✔ | ✔ | `npx -y obsidian-mcp /home/apuru/Vault` (v1.0.6, mismo en las 3) |
| github | ✔ | ✔ | ✔ | `/home/apuru/.local/bin/github-mcp-wrapper` (Docker, token via `gh auth token`, sin PAT plano) |
| context7 | ✔ | ✔ | ✔ | `npx -y @upstash/context7-mcp` |
| playwright | ✔ | ✔ | ✔ | `npx -y @playwright/mcp` |
| postgres | – | – | ✔ | `/home/apuru/.local/bin/opencode-pg-mcp` (lee `$PG_CONNECTION_STRING`, sin password en archivo) |
| packet-tracer | ✔ | – | ✔ | `uvx cisco-pt-mcp` — requiere Packet Tracer abierto para conectar |
| dagu | – | – | ✔ | remote `http://127.0.0.1:8090/mcp` |
| n8n-mcp | ✔ (global) | – | – | `npx n8n-mcp` |
| serena, headroom | ✔ (global) | – | – | proyecto-agnóstico |

## Notas de seguridad

- GitHub PAT (`gho_qtD...`) que estaba en texto plano en `claude_desktop_config.json` fue **removido**
  de la config (2026-07-11). El wrapper Docker usa `gh auth token` en su lugar.
  **Pendiente:** revocar ese PAT manualmente en github.com/settings/tokens — no se puede hacer por CLI
  si fue creado desde la web UI.
- PostgreSQL password ya no está hardcodeada en `opencode.json`; viene de `$PG_CONNECTION_STRING`
  (definida en `~/.zshrc`).

## Bugs encontrados y corregidos en esta sesión

1. Claude Code tenía un `obsidian` MCP fantasma apuntando a `/home/apuru/obsidian-vault` (ruta
   inexistente, `main.js` build viejo) registrado en `~/.claude.json` a nivel de proyecto — no
   figuraba en el plan original, se descubrió al correr `claude mcp list`. Corregido a
   `npx -y obsidian-mcp /home/apuru/Vault`.
2. `~/.claude/settings.json` tenía clave `mcpServers` (packet-tracer, luego se agregó context7) que
   **no se refleja** en `claude mcp list` — Claude Code solo lee MCPs de `~/.claude.json`. Se migró
   packet-tracer y context7 a `claude mcp add` y se eliminó la clave muerta de `settings.json`.
3. `opencode-notificator` en el array `plugin` de `opencode.json` estaba roto: no resuelve en el
   registry npm (404) y su carpeta de cache (`~/.cache/opencode/packages/opencode-notificator*`)
   está vacía (0 archivos). Removido del array.
4. Playwright agregado a Claude Code (`claude mcp add playwright -- npx -y @playwright/mcp`) —
   ahora paridad completa en las 3 apps.

## Notas no accionables

- **16 plugins "unknown" version en Claude Code:** son plugins oficiales de `claude-plugins-official`
  sin campo `version` en su `plugin.json` — comportamiento esperado del marketplace de Anthropic, no
  hay fix posible desde este lado.
- **packet-tracer falla en `claude mcp list`:** requiere Packet Tracer abierto para aceptar la conexión
  del MCP; no es problema de configuración.
- **hooks.json simplificado** (`~/.claude/hooks/lib/resolve-plugin-root.js`) podría ser sobreescrito
  si el plugin ECC corre una sincronización/reinstalación completa de hooks. Backup en
  `~/.claude/hooks/hooks.json.bak-20260711` por si hay que reaplicar.

## Cómo agregar/editar un MCP en Claude Code

```bash
claude mcp add <nombre> -- <comando> <args...>
claude mcp remove <nombre>
claude mcp list   # verifica salud de conexión
```

## Cómo agregar/editar un MCP en OpenCode

Editar `~/.config/opencode/opencode.json`, bloque `"mcp"`. Tipos: `local` (comando) o `remote` (URL).

## Cómo agregar/editar un MCP en Claude Desktop

Editar `~/.config/Claude/claude_desktop_config.json`, bloque `"mcpServers"`. Reiniciar la app.
