# Fable: Extract Knowledge Graph → Skills

## Contexto del usuario

Trabajo con un Obsidian vault de 350 archivos, 764 nodos, 845 edges, 119 comunidades. Tengo un knowledge graph (graphify) que mapea toda mi información: proyectos activos (MiNegocio, scan-tracker, hermes-agent, iglesia, traductor-comics), notas Zettelkasten de ingeniería de software, configuración Linux/Hyprland, homelab, laboratorios de networking, y un equipo de desarrollo (Victor, Gabriel, Ignacio, Nicolas).

Mis herramientas: Claude Code, opencode, Fable 5, Obsidian, Hyprland/Wayland, Proxmox homelab, Go backend, Vue frontend.

## Lo que quiero

Que dejes "partes de ti" que me sirvan: skills, personas, templates, y conocimiento derivado del graph. Cada pieza debe ser útil, portátil, y contextualizada a cómo trabajo.

## Instrucciones

### Fase 1: Analiza el graph

Lee `/home/apuru/Vault/graphify-out/graph.json` y `/home/apuru/Vault/graphify-out/GRAPH_ANALYSIS.md`. Identifica:

1. **Comunidades sin MOC** (50 de 119) — estas son mis áreas ciegas
2. **Nodos hub** (top 20 por degree) — estos son mis conceptos centrales
3. **Nodos aislados** (47) — contenido huérfano que nadie enlaza
4. **Patrones repetidos** — estructuras que aparecen en múltiples comunidades
5. **Conexiones cross-project** — puentes entre proyectos distintos

### Fase 2: Extrae skills del graph

Para cada comunidad significativa (≥5 nodos), crea un skill que:

```yaml
---
name: "vault-{tema}"
description: "Cuando el usuario [acción relacionada con el tema]. Usa esto para [propósito]. NO usar para [exclusiones]."
user-invocable: false
---
```

El skill debe contener:
- **Conceptos core** (hub nodes de la comunidad)
- **Relaciones** (edges importantes dentro de la comunidad)
- **Mentales models** (patrones extraídos de paths entre nodos)
- **Cuándo NO usar** (anti-triggers — esto es lo más importante)

### Fase 3: Crea personas para cada dominio

Usando el framework OpenPersona (4 capas: Soul → Body → Faculty → Skill), crea personas para:

| Dominio | Qué cubre | Graph communities |
|---------|-----------|-------------------|
| **MiNegocio Dev** | Backend Go, frontend Vue, S3 procedures, team knowledge | 1, 4, 5, 6, 12, 16, 17, 22, 26, 27 |
| **Linux/Hyprland** | Desktop config, waybar, caelestia, system audit | 9, 14, 21, 23, 28 |
| **Homelab/Infra** | Proxmox, backups, networking, self-hosted | 8, 15, 18, 25 |
| **AI Tools** | Claude Code, opencode, MCP, skills ecosystem | 25, 26 |
| **Software Engineering** | Zettelkasten concepts, patterns, UML, quality | 10, 11, 20 |
| **Projects** | Iglesia, scan-tracker, hermes, traductor-comics | 2, 3, 13, 19 |

Cada persona debe tener:
- **Identity**: expertise, role, values (de hub nodes)
- **Mental Models**: frameworks y heuristics (de path patterns)
- **Reflexes**: reacciones automáticas (de decision patterns repetidos)
- **Reasoning Chains**: secuencias de pensamiento (de inter-community edges)
- **Knowledge Graph**: conceptos + relaciones (de la comunidad)
- **Limitations**: blind spots (de nodos aislados/sparse regions)

### Fase 4: Crea templates reutilizables

Templates para Obsidian que reflejen mis patrones de trabajo reales:

1. **Template de sesión de desarrollo** — basado en cómo registro sesiones (community 22)
2. **Template de procedure** — basado en mis S3 procedures (community 6)
3. **Template de research** — basado en cómo hago research (community 8, 25)
4. **Template de audit** — basado en mis auditorías de sistema (community 9)
5. **Template de sprint** — basado en cómo planifico sprints (community 1, 17)

### Fase 5: Crea el "Fable Context File"

Un archivo que Fable (o cualquier AI persona) pueda cargar al inicio de sesión para entender mi contexto:

```markdown
# User Context — apuru

## Active Projects
- MiNegocio: small business app (Go + Vue + S3), team of 4 developers
- Scan Tracker: Obsidian plugin + web app, Google Sheets API
- Hermes Agent: autonomous agent runtime
- Iglesia: Astro-based church website
- Traductor de Cómics: PSD translation tool

## Tech Stack
- Backend: Go (Gin/Echo), PostgreSQL, Docker
- Frontend: Vue 3, Chart.js, jsPDF, xlsx
- Desktop: Hyprland/Wayland, Arch Linux, CachyOS
- Homelab: Proxmox, Syncthing, systemd timers
- AI: Claude Code, opencode, Fable 5, MCP servers

## Work Patterns
- Language: Spanish (code comments in English)
- Style: Ponytail (lazy senior dev, shortest path to done)
- Sessions: Usually 1-3 hours, sometimes overnight autonomous
- Tool preference: Go stdlib first, then already-installed deps

## Team
- Victor Herrera: backend tasks, dead code cleanup
- Gabriel Flores: CRUD operations, procedures
- Ignacio Varela: frontend, point of sale
- Nicolas Valdes: barcodes, inventory

## Vault Structure
- 01-Referencia: external knowledge, guides
- 02-Projects: active project blueprints + trackers
- 03-Areas: personal knowledge (Linux, IA, Personal)
- 04-Resources: Zettelkasten concepts, research
- 05-Archive: completed/superseded content
```

### Fase 6: Escribe los archivos

Guarda todo en `/home/apuru/Vault/03-Areas/Herramientas-IA/fable-knowledge/`:

```
fable-knowledge/
├── README.md                    # Índice de todo lo creado
├── user-context.md              # Context file (Fase 5)
├── skills/
│   ├── vault-minegocio-dev/
│   │   └── SKILL.md
│   ├── vault-linux-hyprland/
│   │   └── SKILL.md
│   ├── vault-homelab-infra/
│   │   └── SKILL.md
│   ├── vault-ai-tools/
│   │   └── SKILL.md
│   ├── vault-software-eng/
│   │   └── SKILL.md
│   └── vault-projects/
│       └── SKILL.md
├── personas/
│   ├── minegocio-dev.md
│   ├── linux-hyprland.md
│   ├── homelab-infra.md
│   ├── ai-tools.md
│   ├── software-eng.md
│   └── projects.md
├── templates/
│   ├── sesion-desarrollo.md
│   ├── procedure.md
│   ├── research.md
│   ├── audit.md
│   └── sprint.md
└── graph-insights/
    ├── blind-spots.md           # 50 comunidades sin MOC
    ├── orphaned-nodes.md        # 47 nodos aislados
    ├── missing-links.md         # edges sugeridos por Jaccard
    └── cross-project-patterns.md # patrones compartidos
```

## Criterios de calidad

- [ ] Cada skill tiene description con trigger phrases + anti-triggers
- [ ] Cada skill es < 500 lines (preferiblemente < 80)
- [ ] Cada persona tiene las 6 capas del framework OpenPersona
- [ ] Templates son obsidian-compatibles (frontmatter + wikilinks)
- [ ] user-context.md es < 200 lines (token-efficient)
- [ ] graph-insights/ tiene datos accionables, no solo listas
- [ ] Todo en español (técnico en inglés donde aplica)
- [ ] Cada archivo referencia source_file del graph para trazabilidad

## Constraints

- NO inventes edges que no existan en el graph
- NO incluyas contenido completo de notas — resume
- USA los hub nodes como anclajes de conocimiento
- MARCA las fuentes con source_file para verificación
- SIEMPRE incluye "cuándo NO usar" en skills
