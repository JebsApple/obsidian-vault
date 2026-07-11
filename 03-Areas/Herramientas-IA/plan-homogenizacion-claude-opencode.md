---
title: Plan de Homogenización Claude Code + Claude Desktop + OpenCode
date: 2026-07-10
tags:
  - herramientas-ia
  - claude
  - opencode
  - mcp
  - plan
  - configuracion
status: activo
---

# Plan de Homogenización Claude Code + Claude Desktop + OpenCode

## Objetivo

Tener todo listo para usar con coherencia entre ambas apps y comenzar a utilizarlo para generar nuevos proyectos aprovechando los tokens y skills al máximo.

## Estado Actual del Sistema

| Componente | Claude Code | Claude Desktop | OpenCode |
|------------|-------------|----------------|----------|
| **MCP Servers** | 1 (packet-tracer) | 2 (github, obsidian) | 8 (obsidian, dagu, context7, postgres, github, playwright, packet-tracer, packet-tracer-bun) |
| **Plugins** | 22 habilitados | 1 DXT (Kapture) | 9 |
| **Skills** | 271 (ECC) | 0 (usa DXT) | 0 (usa plugins) |
| **Agents** | 67 (ECC) | 0 | 0 |
| **Commands** | 92 (ECC) | 0 | 0 |
| **Hooks** | 354 líneas, 7 fases | 0 | 0 |
| **CLAUDE.md** | 1 byte (`@RTK.md`) | N/A | 201 líneas (workspace) |

---

## BUGS Y PROBLEMAS CRÍTICOS

### 1. Binarios sin PATH
- `claude` no está en PATH (solo en `~/.config/Claude/claude-code/2.1.202/claude`)
- `opencode` no está en PATH
- **Impacto:** No se puede invocar desde terminal ni por hooks

### 2. Plugin Ponytail roto
- `opencode.json` referencia `/home/apuru/ponytail/.opencode/plugins/ponytail.mjs`
- Directorio `~/ponytail/` **no existe**
- **Impacto:** OpenCode falla al cargar este plugin

### 3. MCPs duplicados e inconsistentes
- `obsidian` configurado en 3 lugares con sintaxis diferente:
  - Claude Desktop: `stdbuf -oL node .../obsidian-mcp/build/main.js`
  - OpenCode: `npx -y obsidian-mcp`
  - Claude Code: no tiene obsidian
- `github` en 3 lugares con implementaciones diferentes:
  - Claude Desktop: `npx @modelcontextprotocol/server-github` + PAT en env
  - OpenCode: Docker wrapper (`github-mcp-wrapper`)
  - Claude Code: no tiene github

### 4. Credenciales en texto plano
- GitHub PAT en `claude_desktop_config.json`
- PostgreSQL password en `opencode.json` (admin123)
- **Riesgo:** Si algún archivo se comparte, las credenciales quedan expuestas

### 5. `~/.claude/CLAUDE.md` casi vacío
- Contiene solo `@RTK.md` (1 byte)
- El CLAUDE.md real está en `/home/apuru/CLAUDE.md` (workspace-level)
- **Impacto:** Claude Code no carga las instrucciones del usuario a nivel global

### 6. Hooks excesivamente complejos
- `hooks.json` tiene 354 líneas con scripts Node.js inline de ~500 caracteres cada uno
- Cada hook repite la misma lógica de búsqueda de plugin root
- **Impacto:** Frágil, difícil de mantener, latencia innecesaria

### 7. Doble archivo opencode
- `opencode.json` y `opencode.jsonc` son byte-idénticos
- **Impacto:** Confusión sobre cuál editar

### 8. 16 plugins con versión "unknown"
- No se puede verificar si están actualizados

### 9. Dos ubicaciones ECC
- `/home/apuru/ECC/` (fuente completa)
- `/home/apuru/herramientas/ecc/` (referencia)
- **Impacto:** Confusión sobre cuál es canónico

---

## PLAN DE REPARACIÓN

### Fase 1: Seguridad y Corrección de Bugs Críticos
- [ ] Rotar GitHub PAT expuesto en Claude Desktop config
- [ ] Mover credenciales PostgreSQL a variable de entorno
- [ ] Eliminar referencia a plugin Ponytail roto en opencode.json
- [ ] Agregar binarios `claude` y `opencode` al PATH via `.zshrc`

### Fase 2: Homogenización MCP ✅ (2026-07-11)
- [x] Unificar configuración de MCPs entre las 3 apps:
  - **Obsidian:** misma versión en las 3 (`npx -y obsidian-mcp` v1.0.6) — de paso se corrigió un MCP obsidian fantasma en Claude Code apuntando a ruta inexistente
  - **GitHub:** mismo wrapper Docker (`github-mcp-wrapper`, token via `gh auth token`) en las 3 — PAT en texto plano removido de Claude Desktop
  - **Context7:** agregado a Claude Desktop y Claude Code
  - **Playwright:** agregado a Claude Desktop
- [x] Crear archivo maestro de MCPs → [[mcp-servers-maestro]]

### Fase 3: CLAUDE.md Unificado ✅ (confirmado 2026-07-11)
- [x] `~/.claude/CLAUDE.md` con `@RTK.md` (pointer a ECC) — confirmado correcto, sin cambios
- [x] `/home/apuru/CLAUDE.md` workspace-level intacto
- [x] No hace falta sincronizar más — separación de responsabilidades ya es correcta

### Fase 4: Limpieza y Optimización ✅ (2026-07-11)
- [x] `opencode.jsonc` — ya no existía (eliminado en Fase 1)
- [x] Simplificar hooks: lógica de plugin-root extraída a `~/.claude/hooks/lib/resolve-plugin-root.js`, hooks.json bajó de 49.6KB a 24.6KB (-50%), 28 hooks reescritos, verificado que siguen funcionando igual
- [x] Ubicaciones ECC — solo existe `/home/apuru/Herramientas/ecc/` (las otras rutas del plan original ya no existían)
- [x] Plugin versions — `opencode-notificator` no resuelve en npm registry pero funciona vía cache local (`~/.cache/opencode/packages/`), no requiere acción

### Fase 5: Preparación para Nuevos Proyectos ✅ (2026-07-11)
- [x] Verificado con `claude mcp list`: obsidian, github, context7 conectan bien. packet-tracer falla si Packet Tracer no está abierto (esperado, no es bug de config)
- [x] Flujo de trabajo ya documentado abajo en este archivo
- [x] Script `project-init` en `~/.local/bin/` — crea `~/proyectos/<nombre>` con `git init`, `.mcp.json` (obsidian+github+context7), `opencode.json` (mismos MCPs + model routing) y `CLAUDE.md` stub. Uso: `project-init <nombre> [--stack web|go|python|generic]`

**Pendiente (skip por ahora, decisión del usuario):** rotar/revocar el GitHub PAT `gho_qtD...` manualmente en github.com/settings/tokens (ya no está en ningún archivo de config, pero sigue siendo válido hasta que lo revoques).

## Plan completo (Fases 1-5) ✅ 2026-07-11

---

## Flujo de Trabajo Objetivo

```
Claude Code → Desarrollo de código, testing, debugging
Claude Desktop → Investigación, conversación, tareas DXT/Kapture
OpenCode → Tareas automatizadas, MCPs pesados, plugins DCP
```

## Archivos Clave

| Archivo | Propósito |
|---------|-----------|
| `~/.claude/settings.json` | Config principal Claude Code |
| `~/.claude/hooks/hooks.json` | Hooks ECC (354 líneas) |
| `~/.claude/CLAUDE.md` | Instrucciones globales Claude Code |
| `~/CLAUDE.md` | Instrucciones workspace (proyectos) |
| `~/.config/Claude/claude_desktop_config.json` | MCPs Claude Desktop |
| `~/.config/opencode/opencode.json` | Config OpenCode (MCPs + plugins) |
| `~/.config/opencode/plugins/claude-mem.js` | Plugin mem OpenCode |
| `~/.local/bin/opencode-sandbox` | Sandbox para MCPs experimentales |
| `~/.local/bin/backup-opencode-config` | Backup config OpenCode |
| `~/ECC/` | Fuente ECC (agents, skills, commands) |
