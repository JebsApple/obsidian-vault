---
aliases: [devops-lab, lab-orchestrator]
tags: [project, proyecto/devops-lab, ia, docker, academic]
created: 2026-07-10
status: activo
deadline: "2026-09-07"
---

# Automated DevOps Laboratory Orchestrator

**Objetivo:** Orquestador declarativo de laboratorios DevOps donde usuarios definen herramientas (Gitea, Jenkins, SonarQube) via YAML/JSON, y un agente IA local valida, genera configuraciones deterministas y auto-repara fallos de deployment.

**Stack:** FastAPI + Jinja2 + Docker Compose + OpenHands + Ollama

**Repos:**
- Local: `~/devops-lab-orchestrator/`
- GitHub: `JebsApple/devops-lab-orchestrator`

---

## Estado

| Milestone | Estado |
|-----------|--------|
| M1: Spec + Schema | ✅ |
| M2: Templates + Deploy Manual | ✅ |
| M3: API + Frontend | 🔧 Stubbed |
| M4: Agente + Self-Healing | ✅ Implementado |
| M5: Evaluation Harness | 🔧 Stubbed |

## Timeline

| Fecha | Hito |
|------|------|
| 15 Jul 2026 | Inicio recta final |
| 1 Ago 2026 | Integración OpenHands |
| 15 Ago 2026 | Experimento completado |
| **7 Sep 2026** | **Deadline INFONOR** |

## Equipo

- **Estudiante:** Victor Herrera — victor.herrera@uta.cl
- **Profesor Guía:** Diego Supanta
- **Colaborador:** Sebastian Canales
- **Conf:** INFONOR 2026 — Univ. Arturo Prat, Iquique (4-6 Nov)

## Notas del proyecto

- [[index|Arquitectura del Sistema]]
- [[experimento|Experimento Comparativo]]
- [[paper|Artículo Académico]]
- [[ADR-002-Allowlist|ADR-002: Allowlist]]
- [[ideas-claude|Ideas: Usar Claude]]
- [[INFONOR-2026|INFONOR 2026]]

## Links

- [[MOCs/index|← Projects Index]]
