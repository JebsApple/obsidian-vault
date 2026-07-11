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

### Fase 2: Homogenización MCP
- [ ] Unificar configuración de MCPs entre las 3 apps:
  - **Obsidian:** misma versión en Claude Desktop y OpenCode (npx)
  - **GitHub:** misma implementación (Docker wrapper en ambas)
  - **Context7:** agregar a Claude Desktop y Claude Code
  - **Playwright:** agregar a Claude Desktop
- [ ] Crear archivo maestro de MCPs con versiones y dependencias

### Fase 3: CLAUDE.md Unificado
- [ ] Poblar `~/.claude/CLAUDE.md` con instrucciones globales relevantes
- [ ] Mantener `/home/apuru/CLAUDE.md` como workspace-level (proyectos específicos)
- [ ] Sincronizar reglas entre ambos archivos

### Fase 4: Limpieza y Optimización
- [ ] Eliminar `opencode.jsonc` duplicado
- [ ] Simplificar hooks: extraer lógica de plugin root a un script compartido
- [ ] Consolidar ubicaciones ECC a una sola (`/home/apuru/ECC/`)
- [ ] Actualizar plugin versions o eliminar plugins sin versión

### Fase 5: Preparación para Nuevos Proyectos
- [ ] Verificar que todos los MCPs arrancan correctamente
- [ ] Documentar flujo de trabajo óptimo: Claude Code (desarrollo) + Claude Desktop (investigación) + OpenCode (tareas automatizadas)
- [ ] Crear template de proyecto base con MCPs preconfigurados

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
