# Cross-Project Patterns — Patrones compartidos entre proyectos

Análisis de estructuras recurrentes que aparecen en múltiples comunidades del graph.

## Patrón 1: Blueprint + Tracker + Sprint

Todos los proyectos activos siguen la misma estructura:
- `blueprints/` → plan detallado
- `trackers/` → kanban/sprint
- `reference/` → documentación de soporte

**Proyectos que lo usan**: MiNegocio, Iglesia, Scan Tracker, Traductor Comics, Hermes Agent, Luciérnaga App

**Implicación**: Crear un template genérico de proyecto que copie esta estructura automáticamente.

## Patrón 2: Backend Go + Frontend Vue

MiNegocio y potencialmente otros proyectos usan:
- Go (Gin/Echo) para backend
- Vue 3 para frontend
- PostgreSQL como base de datos
- Docker para containerización

**Implicación**: Un skill "Go+Vue project" que cargue los patrones relevantes del graph.

## Patrón 3: Procedimiento → Historia de Usuario → Tarea

Las tareas de MiNegocio siguen:
- Procedimiento (cómo hacerlo)
- Historia de usuario (qué se necesita)
- Tarea específica (quién lo hace)

**Community 6** tiene 28 nodos de este patrón.

## Patrón 4: Research → Decision → Implementation

El patrón de toma de decisiones:
1. Research (notes en 04-Resources o 05-Archive/Research-obsoletos)
2. Decision document (en 03-Areas o 02-Projects)
3. Implementation (en el proyecto activo)

**Proyectos que lo siguen**: Homelab (Proxmox decisions), Linux config (Hyprland), AI tools (Claude/opencode)

## Patrón 5: Audit → Fix → Snapshot

Ciclo de auditoría del sistema:
1. Auditoría (detectar problemas)
2. Fix (scripts de corrección)
3. Snapshot (backup antes de cambios)

**Community 9** tiene 23 nodos de este patrón.

## Patrón 6: MOC como puerta de entrada

Los MOCs que existen (10 de 119 comunidades) actúan como hubs:
- `MOCs/index.md` → vault root
- `MOCs/ingenieria-software.md` → 13 edges a conceptos Zettelkasten
- `MOCs/linux.md` → notas de configuración
- `MOCs/projects.md` → proyectos activos

**Gap**: 50 comunidades sin MOC. Las más críticas: MiNegocio Active Dev (35 nodos), Homelab (27 nodos), System Audit (23 nodos).
