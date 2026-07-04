---
tags:
  - project/devops-lab-orchestrator
  - status/active
  - type/academic
---

# Automated DevOps Laboratory Orchestrator

**Titulo completo:** Automated DevOps Laboratory Orchestrator con Agentes IA Locales y Auto-Reparacion

**Stack:** FastAPI + Jinja2 + Docker Compose + OpenHands + Ollama
**Monorepo:** `JebsApple/devops-lab-orchestrator` (GitHub)
**Repo local:** `~/devops-lab-orchestrator/`

## Objetivo

Orquestador declarativo de laboratorios DevOps donde usuarios definen herramientas (Gitea, Jenkins, SonarQube) via YAML/JSON, y un agente IA local valida, genera configuraciones deterministas y auto-repara fallos de deployment.

## Estado

| Milestone | Estado |
|-----------|--------|
| M1: Spec + Schema | Completado |
| M2: Templates + Deploy Manual | Completado |
| M3: API + Frontend | Stubbed |
| M4: Agente + Self-Healing | Implementado |
| M5: Evaluation Harness | Stubbed |

## Timeline

| Fecha | Hito |
|------|------|
| 15 Jul 2026 | Inicio recta final |
| 1 Ago 2026 | Integracion OpenHands |
| 15 Ago 2026 | Experimento completado |
| 7 Sep 2026 | **Deadline INFONOR** |

## Notas

- [[Projects/devops-lab-orchestrator/arquitectura|Arquitectura del Sistema]]
- [[Projects/devops-lab-orchestrator/experimento|Experimento Comparativo]]
- [[Projects/devops-lab-orchestrator/paper|Articulo Academico]]
- [[Projects/devops-lab-orchestrator/ADR-002-Allowlist|ADR-002: Allowlist]]
- [[Projects/devops-lab-orchestrator/ideas-claude|Ideas: Usar Claude]]
- [[Projects/devops-lab-orchestrator/INFONOR-2026|INFONOR 2026]]

## Equipo

- **Estudiante:** Victor Herrera -- victor.herrera@uta.cl
- **Profesor Guia:** Diego Supanta
- **Colaborador:** Sebastian Canales
- **Conf:** INFONOR 2026 -- Univ. Arturo Prat, Iquique (4-6 Nov)
- **Tema:** 05 - Ingenieria de Software y DevOps

**Enlace:** https://github.com/JebsApple/devops-lab-orchestrator
