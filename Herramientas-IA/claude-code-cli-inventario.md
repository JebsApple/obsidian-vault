---
tags:
  - claude
  - inventario
  - configuracion
---
# Claude Code CLI — Inventario completo

Versión: **2.1.200** (npm global @anthropic-ai/claude-code).  
Usuario OAuth: Victor (vherrera756@gmail.com) — Plan Claude Pro.  
Primer inicio: 2026-06-15. Total sesiones: 41. Total mensajes: 7,865.

## Plugins instalados

| Plugin | Marketplace | Versión |
|--------|-------------|---------|
| `frontend-design` | claude-plugins-official | latest |
| `claude-mem` | thedotmack | 13.9.2 |

## Skills locales

15 skills de primer nivel: `agent-browser`, `banner-design`, `brand`, `caveman`, `design`, `design-system`, `diagnose`, `ecc`, `find-skills`, `grill-me`, `mcp-builder`, `slides`, `ui-styling`, `ui-ux-pro-max`.

200+ skills ECC: todas las categorías (angular, backend, database, docker, frontend, golang, kotlin, python, react, rust, springboot, vue, etc.).

Skills de claude-mem (19): babysit, design-is, do, how-it-works, knowledge-agent, learn-codebase, make-plan, mem-search, oh-my-issues, pathfinder, smart-explore, standup, timeline-report, version-bump, weekly-digests, what-the, wowerpoint.

## Comandos slash

92 comandos. Categorías: code review, builds/tests por lenguaje, hookify, jira, plan/prd, multi-* (multi-backend, multi-frontend, multi-plan, multi-workflow), epic-*, quality-gate, security-scan, skill-*, sessions, etc.

## MCP Servers configurados

30+ servidores en `mcp-configs/mcp-servers.json`:

- **Stdio:** nexus, jira, github, firecrawl, supabase, memory, omega-memory, longhand, sequential-thinking, railway, exa-web-search, context7, codescene, magic, filesystem, playwright, fal-ai, browserbase, token-optimizer, laraplugins, confluence, evalview, squish
- **HTTP:** vercel, cloudflare-docs, cloudflare-workers-builds, cloudflare-workers-bindings, cloudflare-observability, clickhouse, parallel-search, browser-use, devfleet
- **Activos por defecto:** obsidian (local), n8n-mcp, headroom, serena
- **claude.ai conectados:** Google Drive, Canva, Claude Code Remote, Postman, Notion

## Agentes

67 agentes ECC: planner, architect, tdd-guide, code-reviewer, security-reviewer, spec-miner, build-error-resolver, e2e-runner, refactor-cleaner, doc-updater, cpp-reviewer, go-reviewer, kotlin-reviewer, rust-reviewer, python-reviewer, django-reviewer, java-reviewer, typescript-reviewer, vue-reviewer, react-reviewer, flutter-reviewer, swift-reviewer, network-architect, homelab-architect, healthcare-reviewer, performance-optimizer, code-architect, seo-specialist, a11y-architect, marketing-agent, php-reviewer, fastapi-reviewer, etc.

## Hooks activos

Sistema ECC completo: 8 PreToolUse, 1 PreCompact, 1 SessionStart, 9 PostToolUse, 1 PostToolUseFailure, 6 Stop, 1 SessionEnd.
Incluye RTK (Rust Token Killer) para rewrite de comandos Bash.

## Proyectos conocidos

| Proyecto | Path | MCPs |
|----------|------|------|
| Home | `/home/apuru` | obsidian, n8n-mcp |
| Documentos | `/home/apuru/Documentos/Claude` | — |
| MiNegocio | `/home/apuru/minegocio` | — |

## Estadísticas de uso

| Métrica | Total |
|---------|-------|
| Mensajes | 7,865 |
| Sesiones | 41 |
| Llamadas a herramientas | 2,361 |
| Modelos usados | Sonnet 4-6, Opus 4-8, Haiku 4-5 |

[[claude-desktop-instalacion.md]] — [[claude-tools-instalacion.md]] — [[configuracion-sesiones-ia.md]]
