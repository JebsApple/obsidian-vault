# OpenCode — Backup de Configuración

> Creado: 2026-07-29
> Backup previo a reinstall. Los archivos están en esta misma carpeta.

## Estructura respaldada

| Archivo/Dir | Descripción |
|-------------|-------------|
| `opencode.json` | Config principal: providers, MCPs, plugins, agent models |
| `opencode-mem.jsonc` | Memory plugin config: embedding model, auto-capture, user profile |
| `opencode-superpowers-install.json` | Manifiesto de instalación de superpowers |
| `commands/` | Comandos personalizados (aprende, graphify, plan, seguridad, self-check, vault) |
| `agents/` | Agentes superpowers (code-reviewer, implementer, plan-writer, spec-writer) |
| `skills/` | Skills instalados |

## Plugins activos

- ponytail (local: `/home/apuru/Herramientas/ponytail/.opencode/plugins/ponytail.mjs`)
- opencode-wakatime
- opencode-vibeguard
- opencode-websearch-cited
- @prevalentware/opencode-goal-plugin
- opencode-mem
- opencode-superpowers

## MCPs configurados

| MCP | Comando |
|-----|---------|
| obsidian | `npx obsidian-mcp /home/apuru/Vault` |
| context7 | `npx @upstash/context7-mcp` |
| github | `/home/apuru/.local/bin/github-mcp-wrapper` |
| playwright | `npx @playwright/mcp` |
| notebooklm | `notebooklm-mcp` |
| graphify-vault | `graphify.serve /home/apuru/Vault/graphify-out/graph.json` |
| serena | `uvx --from git+https://github.com/oraios/serena serena start-mcp-server` |
| headroom | `headroom mcp serve` |

## Modelos

| Rol | Modelo |
|-----|--------|
| Principal | `big-pickle` |
| Small/explore/title/summary | `north-mini-code-free` |
| Compaction | `deepseek-v4-flash-free` |

## Comandos personalizados

- `aprende` → skill aprende (aprendizaje de sesión)
- `graphify` → skill graphify (knowledge graph)
- `plan` → skill fable-plan (plan Fable 5)
- `seguridad` → skill fable-chequeo-seguridad
- `self-check` → skill self-diagnostic
- `vault` → skill fable-vault (contexto del vault)

## Para restaurar

```bash
# 1. Copiar archivos de vuelta
cp -r 05-Archive/OpenCode-Backup/opencode.json ~/.config/opencode/
cp -r 05-Archive/OpenCode-Backup/opencode-mem.jsonc ~/.config/opencode/
cp -r 05-Archive/OpenCode-Backup/commands ~/.config/opencode/
cp -r 05-Archive/OpenCode-Backup/agents ~/.config/opencode/
cp -r 05-Archive/OpenCode-Backup/skills ~/.config/opencode/

# 2. Reinstalar plugins npm globales
npm install -g opencode-wakatime opencode-vibeguard opencode-websearch-cited
npm install -g @prevalentware/opencode-goal-plugin
npm install -g opencode-mem opencode-superpowers
```
