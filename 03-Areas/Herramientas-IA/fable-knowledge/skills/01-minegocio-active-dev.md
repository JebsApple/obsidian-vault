---
name: "MiNegocio Active Dev"
description: "Use when working on MiNegocio e-commerce sprint development, CI/CD pipelines, or bug fixes. Triggers: Sprint 3 tasks, Jenkins pipeline, JWT auth fix, Kanban frontend, dashboard ventas, soft-delete pattern. Skip if unrelated to MiNegocio project."
user-invocable: false
---

# MiNegocio Active Dev

## Domain
Active development sprint work for MiNegocio, an e-commerce/POS application. Covers Sprint 3 user stories (HU01-HU04), CI/CD with Jenkins, frontend Kanban redesign, and production deployment.

## Core Concepts
- **Sprint 3 HU01**: Technical debt resolution + Jenkins CI/CD pipeline setup
- **Sprint 3 HU02**: Frontend redesign — Kanban board for product inventory with drag-drop
- **Sprint 3 HU03**: Sales dashboard with Chart.js, jsPDF export, xlsx export
- **Sprint 3 HU04**: Admin user creation and role management
- **JWT Auth Fix**: `middleware/auth_middleware.go` must store user_id/rol in context via `context.WithValue` — was silently breaking venta FK constraints
- **Soft-Delete Pattern**: Active → Inactive (soft) → Deleted (hard); Service layer decides via `GetByID` state

## Key Relationships
- `Sprint 3 Plan` → defines → `HU01-HU04` tasks
- `Jenkinsfile (frontend/backend/database)` → gates → production deployment
- `VUE_APP_HABILITAR_WIP` flag → hides → unreleased Dashboard/Users features in prod
- `Analisis.vue` → consumes → Chart.js + vue-chartjs for real sales data
- `Inventario.vue` → feeds → `KanbanBoard.vue` (pending fix for inactive product filtering)

## Mental Models
- **Pre-prod audit loop**: Code → 24 bugs found → fix → checkpoint → handoff to next agent when quota exhausted
- **Build flag gating**: Unfinished features ship in bundle but are hidden via env flag, avoiding long-lived feature branches
- **Context propagation bug pattern**: JWT middleware that validates but doesn't propagate claims is a silent time-bomb — always verify downstream handlers receive the claims

## When NOT to use
- Skip for MiNegocio architecture decisions (use project README and CLAUDE.md instead)
- Skip for unrelated e-commerce projects (this is project-specific knowledge)
