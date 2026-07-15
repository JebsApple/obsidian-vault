# GitHub Repos Research — Julio 2026

> Investigación de repositorios relevantes a proyectos y stack del usuario. Actualizar cuando se necesite.

## Stack del usuario (para filtrar)

- Go (Gin/Echo), Vue 3, PostgreSQL, Docker, Proxmox
- Claude Code, opencode, MCP servers
- Hyprland/Wayland, Arch Linux
- Obsidian (vault con graphify)
- Flutter (planeado)
- Hermes Agent (runtime autónomos)

## Estado de instalación

### Coding Agent Orchestration

| Herramienta | Estado | Notas |
|------------|--------|-------|
| claude-squad (`cs`) | ✅ v1.0.19 | `cs -p "opencode"` para multi-agente paralelo |
| cmux | ❌ macOS only | Swift/AppKit, no funciona en Linux |
| superset | ❌ Pendiente | Build from source (Electron), no hay npm/binary |
| opencode.nvim | ❌ Pendiente | Requiere Neovim instalado |
| bridle | ❌ Skip | Config manager, no orquestador |

### MCP Servers

| Herramienta | Estado | Notas |
|------------|--------|-------|
| MCP Go SDK | 📚 Documentado | Librería Go para construir MCP servers, no tool a instalar |
| spec-workflow-mcp | ✅ Instalado | npm global, MCP server para workflow spec-driven |
| mobile-mcp | ✅ Instalado | npm global, control de dispositivos móviles via MCP |
| notebooklm-mcp-cli | ✅ Instalado v0.8.6 | via pipx, CLI: `nlm` / `notebooklm-mcp` |

### Obsidian Plugins

| Plugin | Estado | Notas |
|--------|--------|-------|
| Claudian | ✅ Build OK | Claude Code embebido en Obsidian |
| obsidian-mcp-plugin | ✅ Build OK | MCP server directo al vault |
| infranodus-obsidian | ✅ Clone OK | Graph analysis + text analysis (requiere InfraNodus service) |
| ObsidianRAG | ✅ Clone OK | RAG local con Ollama/LM Studio (requiere Docker backend) |
| Granola-to-Obsidian | ❌ No encontrado | Solo `granola-sync` (Python, no en PyPI) — instalar manual desde GitHub |
| mcp-obsidian | 📚 Alternativa | MCP server via REST API (4k⭐), alternativa a obsidian-mcp-plugin |

### Notas del usuario
- Modelos IA locales (Ollama) no sirven por recursos del PC — buscar orquestador para opencode + OpenRouter + Claude subagéntico
- Homelab: sin HomeLab aún, skip repos de homelab
- Hyprland: ahora usa Caelestia full, no Waybar. Docs de Hyprland son para futuro

---

## 1. Coding Agent Orchestration

| Repo | ⭐ | Lang | Qué hace | Para qué sirve |
|------|-----|------|----------|----------------|
| [claude-squad](https://github.com/smtg-ai/claude-squad) | 8.1k | **Go** | Gestor TUI de múltiples agentes (Claude Code, Codex, Gemini, Aider, OpenCode). Usa tmux + git worktrees para aislamiento. | Ejecutar N agentes en paralelo, cada uno en su branch. Directo para autonomous loops multi-tarea. |
| [cmux](https://github.com/manaflow-ai/cmux) | 24.5k | Swift | Terminal macOS (libghostty) con vertical tabs, notificaciones para agentes, browser in-app, Claude Code Teams, SSH. | Gestión visual de sesiones agent. macOS only —/Linux no sirve. |
| [superset](https://github.com/superset-sh/superset) | 12.4k | TS | Code editor para era AI — ejecuta ejércitos de agentes. Electron. | Alternativa GUI a claude-squad. |
| [agent-deck](https://github.com/asheshgoplani/agent-deck) | 499 | **Go** | Session manager TUI para agentes. Go + BubbleTea. | Más ligero que claude-squad, mismo nicho. |
| [opencode.nvim](https://github.com/sudo-tee/opencode.nvim) | 900 | Lua | Frontend Neovim para opencode. | Integración nvim+opencode. |
| [bridle](https://github.com/neiii/bridle) | 433 | Rust | Config manager para harnesses agentic (Claude Code, Opencode, Goose, etc). | Centralizar configs de múltiples agentes. |

---

## 2. Agent Frameworks / Runtimes

| Repo | ⭐ | Lang | Qué hace | Para qué sirve |
|------|-----|------|----------|----------------|
| [SwarmClaw](https://github.com/swarmclawai/swarmclaw) | 611 | TS | Runtime self-hosted: agentes, swarms, delegación, schedules, memoria, MCP, 23+ providers. Hermesa Agent es provider nativo. | Multi-agente autónomos con orchestration. Inspiración para arquitectura de Hermes. |
| [PraisonAI](https://github.com/MervinPraison/PraisonAI) | 8.4k | Python | Framework multi-agente: deploy en 5 líneas, RAG, 100+ LLMs. | Más pesado, más ecosistema. Python. |
| [loki-mode](https://github.com/asklokesh/loki-mode) | 1.0k | Shell | SDLC multi-agente: spec → issues → código → PR → review. | Inspiración para pipelines autónomos de dev. |
| [SIA](https://github.com/hexo-ai/sia) | 2.0k | Python | Self-improving AI: mejora autónomamente rendimiento de modelos/agentes. | Concepto de self-learning. |
| [crewAI](https://github.com/crewAIInc/crewAI) | 55.5k | Python | Orchestration de agentes rol-playing. El más popular. | Si se necesita multi-agente en Python. |
| [Doberman-Core](https://github.com/fu351/Doberman-Core) | 112 | Python | Seguridad para agentes: guardrails, prompt injection defense, audit. | Relevante si Hermes crece a producción. |

---

## 3. MCP Ecosystem

| Repo | ⭐ | Lang | Qué hace | Para qué sirve |
|------|-----|------|----------|----------------|
| [MCP Go SDK](https://github.com/modelcontextprotocol/go-sdk) | 4.8k | **Go** | SDK oficial Go para MCP servers y clients. Colaboración con Google. | Construir MCP servers en Go. |
| [MCP Registry](https://github.com/modelcontextprotocol/registry) | 7.0k | **Go** | Registry comunitario de MCP servers. | Descubrimiento de herramientas MCP. |
| [spec-workflow-mcp](https://github.com/Pimzino/spec-workflow-mcp) | 4.3k | TS | MCP server para spec-driven dev con dashboard web. | Workflow alineado con patrón blueprint. |
| [mobile-mcp](https://github.com/mobile-next/mobile-mcp) | 5.4k | TS | MCP para automatización mobile (iOS, Android, emuladores). | Relevante para Luciérnaga (Flutter). |
| [awesome-mcp-servers](https://github.com/wong2/awesome-mcp-servers) | 4.2k | — | Lista curada de MCP servers. | Catálogo de referencia. |
| [notebooklm-mcp-cli](https://github.com/jacob-bd/notebooklm-mcp-cli) | 5.5k | Python | Acceso programático a Google NotebookLM. | Si se usa NotebookLM. |

---

## 4. Obsidian + AI

| Repo | ⭐ | Lang | Qué hace | Para qué sirve |
|------|-----|------|----------|----------------|
| [Claudian](https://github.com/YishenTu/claudian) | 14k | TS | Plugin Obsidian: incrusta Claude Code/Codex como colaborador en el vault. | Exacto para vault + AI. Estudiar arquitectura. |
| [obsidian-mcp-plugin](https://github.com/aaronsb/obsidian-mcp-plugin) | 434 | TS | MCP server para Obsidian: acceso semántico al vault. | graphify + MCP bridge. |
| [infranodus-obsidian](https://github.com/noduslabs/infranodus-obsidian-plugin) | 156 | TS | Graph view avanzado + topic modeling + AI. | Complementa graphify. |
| [Granola-to-Obsidian](https://github.com/dannymcc/Granola-to-Obsidian) | 217 | JS | Sync automático de notas de Granola AI a Obsidian. | Si se usa Granola. |
| [ObsidianRAG](https://github.com/Vasallo94/ObsidianRAG) | 106 | Python | RAG local con Ollama sobre notas de Obsidian. | Alternativa local a cloud RAG. |

---

## 5. Homelab / Self-Hosted

| Repo | ⭐ | Lang | Qué hace | Para qué sirve |
|------|-----|------|----------|----------------|
| [dnsweaver](https://github.com/maxfield-allison/dnsweaver) | 155 | **Go** | DNS automático para Docker + Proxmox VE. Multi-provider (Technitium, Pi-hole, Cloudflare). | Resolver DNS automático en homelab. |
| [ultimate-selfhosted-homelab](https://github.com/junaydirfan/ultimate-selfhosted-homelab) | 62 | — | Guía completa Proxmox + Docker/LXC. | Referencia de arquitectura homelab. |

---

## 6. Hyprland / Desktop

| Repo | ⭐ | Qué hace |
|------|-----|----------|
| [HyprKenso](https://github.com/aadritobasu/HyprKenso) | 123 | Rice Hyprland: Waybar, Rofi, SwayNC, MPD, QuickShell. |
| [AlvaroParker/config](https://github.com/AlvaroParker/config) | 63 | Dotfiles Arch + Hyprland + Waybar theming. |

---

## Áreas sin hallazgos relevantes

- **Go + Vue fullstack**: niche, no hay repos nuevos con tracción que superen lo que ya existe.
- **Flutter apps**: muchos templates genéricos, nada destacable nuevo.
- **Astro themes**: saturado, no hay novedad sobre lo que ya hay.
- **Traducción PSD/imágenes**: sin repos nuevos significativos.
- **Syncthing alternatives**: nada nuevo que lo supere.

---

## Top 5 accionables (resumen rápido)

1. **claude-squad** — Go, multi-agent paralelo con worktrees. Usar hoy.
2. **MCP Go SDK** — Go, SDK oficial MCP. Para construir servers.
3. **Claudian** — Plugin Obsidian + Claude Code. Studiar arquitectura.
4. **SwarmClaw** — Runtime multi-agente. Inspiración para Hermes.
5. **dnsweaver** — Go, DNS automático Proxmox+Docker.

---

*Última actualización: 2026-07-14*
