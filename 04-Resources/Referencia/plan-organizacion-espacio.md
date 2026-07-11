---
tags:
  - referencia
  - productividad
  - organization
created: 2026-07-10
---
# Plan de Organización del Espacio de Trabajo

## Objetivo
Mantener un espacio de trabajo limpio, intuitivo y de baja fricción para productividad máxima.

## Estructura del Home (`~/`)

```
~/
├── obsidian-vault/          # Vault principal (sync git + Syncthing)
├── proyectos/
│   ├── minegocio/           # Repo principal (frontend+backend monorepo, git → Gitea)
│   ├── devops-lab-orchestrator/  # Proyecto académico DevOps
│   └── deriva/              # Script Python
├── Documentos/
│   ├── academicos/          # Informes, exámenes, papers, subnet
│   ├── media/
│   │   ├── anime/           # Videos
│   │   ├── manga/           # Manga scans
│   │   └── comics/          # Traductor de comics + manhwa
│   └── Claude/projects/     # Archivos de proyectos Claude
├── herramientas/
│   ├── ponytail/            # AI agent framework
│   ├── ecc/                 # Custom rules
│   └── bin/                 # Instaladores (sonar-scanner, obsidian, etc)
├── respaldos/               # Backups datados
├── Descargas/               # Siempre vacío (limpiar regularmente)
├── scripts/                 # Scripts utilitarios
└── .local/bin/              # 84 scripts custom (Hyprland, Waybar, Obsidian, etc)
```

## Estructura del Vault (`obsidian-vault/`)

```
obsidian-vault/
├── index.md                 # MOC principal
├── Herramientas-IA/         # Notas sobre herramientas de IA
│   └── IA-Control/          # Sistema de tareas remotas IA
├── MiNegocio/               # Proyecto principal
│   ├── MiNegocio.md         # Hub del proyecto
│   ├── Archivados/          # Sprints anteriores, rubricas
│   ├── Conocimiento/        # Guias, lecciones, documentación técnica
│   ├── Procedimientos/      # HU01-HU05, procedures por sprint
│   ├── Registro/            # Session logs (Sesion-YYYY-MM-DD.md)
│   ├── Tareas/              # Tareas activas
│   └── University/          # Archivos académicos del proyecto
├── Papelera/                # Papelera (research obsolete, system obsolete)
├── Personal/
│   ├── Apps/                # Notas de apps (deriva, HyprPlayer, Mihon)
│   ├── Linux/               # Config Hyprland, Waybar, sistema
│   └── PT-Caso05/           # Packet Tracer - Caso 05
├── Plantillas/              # Templates Obsidian
│   ├── _template.md         # Proyecto
│   ├── _template-sesion.md  # Session log
│   ├── _template-procedimiento.md  # Procedimiento
│   └── _template-tarea.md   # Tarea
├── Projects/                # Proyectos académicos externos
│   ├── Caso05/
│   ├── devops-lab-orchestrator/
│   └── MiNegocio/Planes/    # Planes de sprint
└── Referencia/              # Notas de referencia general
```

## Convenciones

### Tags
- **Proyecto:** `proyecto/minegocio` (jerárquico, siempre con slash)
- **Sprint:** `sprint-3` (con guion, nunca `sprint3`)
- **Tipo:** `tipo/sesion`, `tipo/procedimiento`, `tipo/tarea`
- **Siempre en frontmatter YAML** (nunca inline `#tags` en contenido)

### Wikilinks
- Estilo bare `[[nombre-nota]]` para links simples
- Path-style `[[MiNegocio/Tareas/nombre]]` para desambiguar
- **NUNCA** incluir `.md` en wikilinks
- Sección: `[[nombre#Heading]]`

### Archivos
- `kebab-case` para nombres de archivo (nunca espacios)
- `Sesion-YYYY-MM-DD-descripcion.md` para logs de sesión
- `Sesion-YYYY-MM-DD.md` para logs sin contexto adicional

### Plantillas
- Configurar `Plantillas/` como template folder en Obsidian
- Ctrl+T para insertar template
- Siempre incluir frontmatter con tags

## Mantenimiento Regular

### Semanal
- [ ] Mover archivos de `~/Descargas/` a su lugar correcto
- [ ] Revisar wikilinks rotos (`[[nombre]]` sin target)
- [ ] Sincronizar vault (`git push`)

### Mensual
- [ ] Revisar tags inconsistentes
- [ ] Archivar sesiones viejas (>2 sprint atrás)
- [ ] Limpiar `Papelera/`
- [ ] Backup completo (`backup-opencode-config`)

### Al iniciar proyecto nuevo
- [ ] Crear hub note `Projects/nombre/index.md`
- [ ] Definir tags del proyecto
- [ ] Agregar al MOC (`index.md`)

## Regla de Oro
> Si un archivo no tiene tag ni link, probablemente no debería existir en el vault.
