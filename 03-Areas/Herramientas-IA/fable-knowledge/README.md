# Fable Knowledge — Índice

Conocimiento extraído del knowledge graph del vault (graphify). "Partes de Fable" dejadas en el sistema: skills, personas, insights y contexto cargable por cualquier AI.

**Fuente**: `~/Vault/graphify-out/graph.json` (1475 nodos · 1465 edges · 235 comunidades, actualizado 2026-07-14)
**Spec original**: [[../fable-prompt-extract-knowledge]]

## Estructura

```
fable-knowledge/
├── README.md              ← este índice
├── user-context.md        ← contexto cargable al inicio de sesión (proyectos, stack, equipo, patrones)
├── skills/                ← 30 skills, uno por comunidad del graph (00-29)
├── personas/              ← 6 personas OpenPersona (Soul→Body→Faculty→Skill)
└── graph-insights/        ← análisis accionable del graph
```

Templates viven en `~/Vault/Plantillas/` (no aquí): `_template-sprint`, `_template-procedimiento-v2`, `_template-research`, `_template-auditoria`, `_template-sesion-v2`.

## Personas

| Persona | Dominio | Cuándo usar |
|---------|---------|-------------|
| [[personas/minegocio-dev\|minegocio-dev]] | Full-stack MiNegocio (Go+Vue) | Features, sprints, auth, POS, equipo |
| [[personas/projects-builder\|projects-builder]] | Side projects (Iglesia, Scan Tracker, Hermes, Traductor, Luciérnaga) | Blueprints, scaffolding, decisiones cross-project |
| [[personas/linux-tinkerer\|linux-tinkerer]] | Hyprland/Wayland desktop | Config Lua, waybar, caelestia, fixes |
| [[personas/homelab-architect\|homelab-architect]] | Self-hosted + infra | Proxmox, backups, VPN, sync |
| [[personas/ai-tooling-specialist\|ai-tooling-specialist]] | Claude Code, opencode, MCP | Config de herramientas AI, homogenización |
| [[personas/se-student\|se-student]] | Ingeniería de software | UML, agile, calidad, estudio |

## Skills (por dominio)

| Dominio | Skills |
|---------|--------|
| MiNegocio | 01, 04, 05, 06, 12, 16, 17, 27 |
| Linux/Hyprland | 09, 14, 29 |
| Homelab/Infra | 08, 15, 25 |
| AI Tools | 11, 21, 23, 26, 28 |
| Proyectos | 02, 03, 13, 19, 22 |
| Conocimiento | 10, 18, 20, 24 |
| Plugin Obsidian | 00, 07 |

Ver `skills/` — cada archivo tiene frontmatter con triggers y anti-triggers.

## Graph Insights

- [[graph-insights/blind-spots\|blind-spots]] — comunidades sin MOC (histórico: los 12 accionables ya tienen MOC en `MOCs/`)
- [[graph-insights/orphaned-nodes\|orphaned-nodes]] — 47 nodos aislados con acciones sugeridas
- [[graph-insights/missing-links\|missing-links]] — edges sugeridos por Jaccard
- [[graph-insights/cross-project-patterns\|cross-project-patterns]] — 6 patrones repetidos entre proyectos

## Cómo usar esto

1. **Inicio de sesión AI**: cargar `user-context.md` (< 200 líneas, token-efficient)
2. **Trabajo en dominio específico**: cargar la persona + skills del dominio
3. **Consultas al graph**: skill `/graphify query "<pregunta>"` o MCP server `graphify-vault` (tools: query_graph, get_node, shortest_path, god_nodes)
4. **Mantenimiento**: tras agregar notas al vault, correr `/graphify ~/Vault --update` para regraficar
