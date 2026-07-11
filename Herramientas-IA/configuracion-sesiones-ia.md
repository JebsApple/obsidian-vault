---
tags: [configuracion, agentes, ia, setup]
---

# Configuración de Sesiones IA

Para que cualquier IA (opencode, Claude Code) lea el vault automáticamente al iniciar sesión, existen dos archivos en `/home/icin/`:

## `CLAUDE.md` (lo usa Claude Code)

```
/home/icin/CLAUDE.md
```

```markdown
# MiNegocio - Instrucciones para IA

## Al iniciar una sesión, lee estos archivos del vault de Obsidian

El vault está en `/home/icin/obsidian-vault`. Usa las herramientas MCP de Obsidian (obsidian_read-note) para leer los siguientes archivos y entender el contexto completo del proyecto:

### 1. Estado del proyecto
- `Projects/MiNegocio.md` — Estado actual, ramas activas, stack, decisiones
- `Projects/MiNegocio - Merge a Main.md` — Plan de merge y PRs pendientes
- `Tasks/pending.md` — Tareas pendientes y completadas

### 2. Agentes y configuración
- `Knowledge/agentes.md` — Definiciones de agentes, roles, convenciones (c-back, c-front, c-db, etc.)

### 3. Conexiones y remotos
- `Knowledge/conexion-remota.md` — SSH a Gitea, MCP setup, sync

### 4. Decisiones técnicas
- `Knowledge/decisiones.md` — ADRs y decisiones de arquitectura

### 5. Lecciones aprendidas
- `Knowledge/lecciones.md` — Errores, soluciones y aprendizajes previos

### 6. Cómo usar herramientas
- `Knowledge/como-usar.md` — Guías de uso de herramientas

## Estructura del proyecto

```
/home/icin/
├── CLAUDE.md                    ← Este archivo
├── obsidian-vault/              ← Documentación (MCP conectado)
│   ├── Projects/                ─ Estado del proyecto
│   ├── Knowledge/               ─ Guías, agentes, decisiones
│   └── Tasks/                   ─ Tareas pendientes
├── proyecto/minegocio-frontend/          ← Vue.js 3 (puerto 8081)
├── proyecto/minegocio-backend/           ← Go (puerto 3000)
└── proyecto/minegocio-database/          ← PostgreSQL
```

## Convenciones generales
- Backend en capas: handlers/services/repository/models — main.go es solo entry point
- Frontend Vue.js con componentes reutilizables
- Soft delete activo en DB (campo `activo` boolean)
- Paleta: rojo `#d60000`, blanco, negro
- Gitea en `192.168.50.28:3000`, SSH como `git@gitea`
- Commits descriptivos, un commit por tarea
- Siempre leer el vault antes de tomar decisiones
```

## `AGENTS.md` (lo usa opencode)

```
/home/icin/AGENTS.md
```

```markdown
Lee el archivo CLAUDE.md en `/home/icin/CLAUDE.md` para instrucciones completas.

Resumen: el proyecto es MiNegocio (Vue.js + Go + PostgreSQL). Toda la documentación está en el vault de Obsidian en `/home/icin/obsidian-vault/`. Usa las herramientas `obsidian_read-note` para leer los archivos relevantes antes de trabajar.
```

## Cómo sincronizar a otra máquina

```bash
# En la máquina origen, pushear el vault a GitHub
cd /home/icin/obsidian-vault
git add -A && git commit -m "update: configuracion sesiones IA" && git push

# En la máquina destino, clonar o hacer pull
git pull

# Copiar los archivos de configuración
cp /home/icin/obsidian-vault/Knowledge/configuracion-sesiones-ia.md /tmp/
# Extraer CLAUDE.md y AGENTS.md de la nota y crearlos en /home/icin/
```
