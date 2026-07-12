---
aliases: [projects-index, dashboard]
tags: [moc, dashboard]
created: 2026-07-11
---

# Proyectos — Dashboard

## Vista general

```dataview
TABLE status, deadline, file.folder as "Ubicación"
FROM "02-Projects"
WHERE tags AND contains(tags, "project")
SORT status ASC, deadline ASC
```

## Proyectos activos

```dataview
TABLE status, deadline
FROM "02-Projects"
WHERE status = "activo"
SORT deadline ASC
```

## En progreso

```dataview
TABLE status
FROM "02-Projects"
WHERE status = "en-progreso"
SORT file.name ASC
```

## Pendientes

```dataview
TABLE status
FROM "02-Projects"
WHERE status = "pendiente"
SORT file.name ASC
```

## Por proyecto

### [[traductor-comics-psd|Traductor de Cómics a PSD]]
> Express + React 19 — OCR + traducción + export PSD/DOCX

| Sprint | Estado |
|--------|--------|
| Sprint 0 — Foundations | ✅ |
| Sprint 1 — Core Interaction | 📋 |
| Sprint 2 — Polish + TypeR | 📋 |

### [[scan-tracker-obsidian|Scan Tracker → Obsidian]]
> Plugin Obsidian — Sync Google Sheets ↔ markdown

| Milestone | Estado |
|-----------|--------|
| M1-M6: Código | ✅ |
| M7: Testing real | 📋 |

### [[devops-lab-orchestrator|DevOps Lab Orchestrator]]
> FastAPI + Docker + OpenHands + Ollama — Lab orquestado con IA

| Milestone | Estado |
|-----------|--------|
| M1-M2, M4 | ✅ |
| M3, M5 | 🔧 |

### [[hermes-agent|Hermes Agent]]
> Runtime autónomo de agentes IA (Nous Research)

| Fase | Estado |
|------|--------|
| Fase 1: Local | 📋 |

### [[refactor-claude-md|Refactor CLAUDE.md]]
> Reestructurar configuración de Opencode

| Step | Estado |
|------|--------|
| 1.1-3.1 | 📋 |

---

## Links

- [[MOCs/index|← Index]]
