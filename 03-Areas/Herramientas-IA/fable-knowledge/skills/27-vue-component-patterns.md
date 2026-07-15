---
name: "Vue Component Patterns (MiNegocio)"
description: "Use when building or reviewing Vue components for MiNegocio. Triggers: KanbanBoard, AppModal, Analisis dashboard, Chart.js Vue, ubicaciones CRUD. Skip if unrelated to MiNegocio frontend."
user-invocable: false
---

# Vue Component Patterns (MiNegocio)

## Domain
Vue component patterns specific to MiNegocio's inventory management frontend — Kanban boards, dashboards, modals, and CRUD interfaces organized by physical locations.

## Core Concepts
- **KanbanBoard.vue**: Drag-drop Kanban board component organized by physical ubicaciones (not stock levels)
- **Analisis.vue**: Dashboard component using Chart.js for KPI visualization
- **AppModal.vue**: Global modal/alert/confirm component replacing native browser dialogs
- **AnalisePage.vue**: Combined Dashboard + Landing page component
- **Ubicaciones CRUD**: Backend repository pattern (inventario_repository.go) for location management
- **Kanban por ubicaciones físicas**: Architectural decision — organize Kanban by physical storage locations, not stock quantities
- **HU02-T02**: User story task for KanbanBoard drag-drop implementation
- **HU02-T03**: User story task for Dashboard KPIs implementation

## Key Relationships
- KanbanBoard.vue → uses → ubicaciones (physical location data model)
- KanbanBoard.vue → implements → HU02-T02 (user story)
- Analisis.vue → implements → HU02-T03 (user story)
- AnalisePage.vue → composes → Analisis.vue (dashboard sub-component)
- AppModal.vue → replaces → native alert/confirm (global UI pattern)
- Ubicaciones CRUD → provides data → KanbanBoard.vue (backend→frontend)

## Mental Models
- **Location-first architecture**: Physical ubicaciones drive UI organization, not stock levels
- **Component composition**: AnalisePage.vue wraps Analisis.vue for combined views
- **Global UI patterns**: AppModal.vue standardizes all user confirmations/alerts

## When NOT to use
- Skip for non-MiNegocio Vue projects (different data models)
- Skip for backend-only changes (Go/inventario_repository.go)
- Skip for non-Kanban, non-dashboard Vue components
