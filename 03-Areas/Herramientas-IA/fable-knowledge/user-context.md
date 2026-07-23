# User Context — apuru

## Profile
- **Name**: Víctor, apodo "Manzana"
- **Studies**: Ingeniería Civil en Informática, UTA (Chile)
- **Location**: Chile

## Learning Style
- Videos + hands-on > documentación escrita
- Prefiere aprender creando con IA: que le explique mientras construyen
- Se frustra si no entiende el por qué antes de implementar
- No le gustan los conceptos nuevos de golpe — prefiere ir de a poco

## AI Workflow Preferences
- **NO** comentarios redundantes en código
- Planificaciones concretas antes de ejecutar
- Investigar primero, preguntar para afinar ambigüedades
- Ofrecer rutas diferentes, pensar como experto
- Nunca descartar crear ruta propia (pero nunca hardcodear)
- Quiere control pero en equilibrio: hacer lo justo y necesario
- Se frustra cuando las cosas se ramifican demasiado y pierde el orden

## Daily Patterns
- Programa según hiperfoco, sin horario fijo
- Actualmente full CLI IA (Claude Code / opencode)
- Sesiones cuando el foco aparece
- Solo estudia (sin trabajo actual)
- Sin otros ingresos
- Descubrió opencode/Claude Code por internet, redes sociales, YouTube

## Active Projects
- **MiNegocio**: small business app (Go + Vue + PostgreSQL + S3), team of 4 developers
- **Scan Tracker**: web app para organizar trabajo de scanlation (compartida con compañeros scanlators)
- **Hermes Agent**: autonomous agent runtime (Claude Code, Gemini, Groq)
- **Iglesia**: Astro-based church website, GitHub Pages
- **Traductor de Cómics (TL2EDIT)**: PSD translation tool — proyecto con potencial de ingresos, el más emocionante junto con ScanTracker
- **Luciérnaga App**: mobile app (Flutter, solo idea) — aporte a la iglesia, sin reuniones con pastores para afinar requerimientos
- **Limpieza de computadores (software)**: otra opción de negocio
- **ani-cli-hub**: terminal anime hub, fork de ani-cli-mx (bash, kitty graphics, jkanime) — github.com/JebsApple/ani-cli-hub

## Tech Stack
- **Backend**: Go (Gin/Echo), PostgreSQL, Docker, Nginx
- **Frontend**: Vue 3, Chart.js, jsPDF, xlsx, Tailwind
- **Desktop**: Hyprland/Wayland, Arch Linux (CachyOS), Waybar
- **Homelab**: Proxmox VE, Syncthing, systemd timers, Docker
- **AI**: Claude Code, opencode, Fable 5, MCP servers, Gemini API
- **Sync**: Syncthing (multi-machine), Obsidian Git, Mihon

## Work Patterns
- **Language**: Spanish (code comments in English)
- **Style**: Ponytail (lazy senior dev, shortest path to done)
- **Sessions**: 1-3 hours, sometimes overnight autonomous loops
- **Tool preference**: Go stdlib first → already-installed deps → minimum code
- **Testing**: TDD when non-trivial, assert-based self-checks for scripts

## Team
- **Victor Herrera**: backend tasks, dead code cleanup, procedures
- **Gabriel Flores**: CRUD operations, procedures, team lead
- **Ignacio Varela**: frontend, point of sale, inventory
- **Nicolas Valdes**: barcodes, inventory, SonarQube/Jenkins

## Vault Structure
- `01-Referencia/`: external knowledge, guides, research
- `02-Projects/`: active project blueprints + trackers (6 projects)
- `03-Areas/`: personal knowledge (Linux, IA, Personal)
- `04-Resources/`: Zettelkasten concepts (150+ atomic notes)
- `05-Archive/`: completed/superseded content

## Graph Summary (1475 nodes, 1465 edges, 235 communities — updated 2026-07-14)
- **30 communities** have MOCs (Maps of Content) — 20 new
- **30 skills** extracted (communities 0-29) — `fable-knowledge/skills/`
- **6 personas** generated (OpenPersona 4-layer) — `fable-knowledge/personas/`
- **MCP server** `graphify-vault` — live graph queries (query_graph, shortest_path, god_nodes)
- **5 templates** created (sprint, procedure, research, audit, session) — `Plantillas/`
- **47 nodes** isolated → orphaned content (stversions internals + MiNegocio archived)
- **115 connected components** → highly fragmented

## Key Bridges
- `handoff a opencode` connects sprints ↔ frontend components
- `MiNegocio` node connects team ↔ backend lessons
- `MOC Ingeniería de Software` connects 10 Resources nodes to reference layer

## Skills (by domain)
| Domain | Skill File | Triggers |
|--------|-----------|----------|
| MiNegocio Dev | `01-minegocio-active-dev.md` | sprint, HU, kanban, audit |
| Frontend | `04-minegocio-tech-stack.md` | Vue, component, vite |
| Backend | `16-minegocio-backend-lessons.md` | Go, auth, JWT, POS |
| Linux | `14-linux-desktop-config.md` | Hyprland, waybar, lua |
| Homelab | `08-homelab-infrastructure.md` | proxmox, docker, backup |
| AI Tools | `09-system-audit-tooling.md` | claude, opencode, mcp |
| DevOps | `15-devops-gitops.md` | CI/CD, terraform, gitops |
| Comics | `13-comic-translator-psd.md` | translate, PSD, OCR |
| Networking | `18-networking-lab-pt.md` | cisco, packet tracer, lab |
| Architecture | `10-software-eng-concepts.md` | UML, agile, quality |

## Personas
| Persona | Domain | Style |
|---------|--------|-------|
| `minegocio-dev` | Full-stack e-commerce | Bilingual, technical |
| `linux-tinkerer` | Hyprland desktop | Spanish, hands-on |
| `homelab-architect` | Self-hosted services | English, systematic |
| `ai-tooling-specialist` | AI assistant config | Bilingual, pragmatic |
| `se-student` | Software engineering | Spanish, learning |
| `projects-builder` | Side projects (Iglesia, Scan Tracker, Hermes, Traductor, Luciérnaga) | Spanish, decision-oriented |

## Recurring Patterns
1. **Blueprint + Tracker + Sprint** — all 6 projects follow this
2. **Backend Go + Frontend Vue** — MiNegocio's core stack
3. **Procedimiento → HU → Tarea** — task decomposition pattern
4. **Research → Decision → Implementation** — decision-making cycle
5. **Audit → Fix → Snapshot** — system maintenance cycle
