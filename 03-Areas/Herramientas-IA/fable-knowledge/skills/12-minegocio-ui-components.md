---
name: "MiNegocio UI Components"
description: "Use when working with MiNegocio Vue components, Jenkinsfile CI/CD, or Sprint 3 session artifacts. Triggers: KanbanBoard, ModalAgregarProducto, Jenkinsfile, SideBar.vue, GaleriaProductos, WIP flag, structured logging. Skip for unrelated Vue projects or non-MiNegocio CI/CD."
user-invocable: false
---

# MiNegocio UI Components

## Domain
MiNegocio project's Vue.js frontend components, Jenkins CI/CD pipeline files, and session work artifacts from the Kanban redesign sprint. Focuses on component architecture, feature flags, and production deployment gates.

## Core Concepts
- **Kanban Board**: `KanbanBoard.vue` — the core UI for product inventory management. `VUE_APP_HABILITAR_WIP` feature flag gates work-in-progress functionality.
- **Component Library**: `SideBar.vue` (collapsible with transitions), `AppModal` (global confirmation), `GaleriaProductos.vue` (responsive product grid), `ModalAgregarProducto.vue`.
- **CI/CD Pipeline**: Three Jenkinsfiles — Frontend, Backend, Database. Session 2026-07-03 updated all three with production gates. Nicolás authored the pipeline files.
- **Logging Stack**: `config/logger.go` (slog-based), `middleware/logger.go` (request logging + request ID), `middleware/recovery.go` (panic recovery with stack trace). Defined by S3-SLT-logging task.
- **Known Debt**: `Inventario.vue` has a pending fix for Kanban with inactive products. `productos.css` is shared between product and inventory views.

## Key Relationships
- Sesión 2026-07-03 → implements → KanbanBoard.vue, creates → ModalAgregarProducto.vue, updates → all Jenkinsfiles
- proc-front (S3-HU02) → plans → KanbanBoard.vue + AppModal (planning precedes implementation)
- Victor Herrera → author_of → KanbanBoard.vue, SideBar.vue, GaleriaProductos, logging tasks
- Nicolás → author_of → Frontend + Backend Jenkinsfiles
- COMENTARIOS task → documents_changes_to → SideBar.vue, GaleriaProductos, productos.css

## Mental Models
- **Feature Flags for Progressive Rollout**: `VUE_APP_HABILITAR_WIP` allows deploying Kanban changes without exposing unfinished features to production.
- **Separation of Pipeline Concerns**: Frontend/Backend/Database each get their own Jenkinsfile — deploy independently, fail independently.
- **Shared CSS = Shared Contract**: `productos.css` is the implicit interface between product views. Changes ripple.

## When NOT to use
- Skip for other Vue projects not using this component set
- Skip for Go backend debugging (community 11)
- Skip for Jenkins pipeline authoring from scratch (this is project-specific artifacts)
