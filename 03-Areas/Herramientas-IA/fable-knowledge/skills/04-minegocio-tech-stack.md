---
name: "MiNegocio Tech Stack"
description: "Use when working with MiNegocio frontend components, Vue 3 patterns, or the project technology reference. Triggers: Vue 3 composition, Vite build, Vitest testing, Tabler Icons, Vue Router, SideBar.vue, KanbanBoard.vue, GaleriaProductos.vue. Skip if unrelated to MiNegocio frontend."
user-invocable: false
---

# MiNegocio Tech Stack

## Domain
Frontend technology stack reference for MiNegocio e-commerce app. Vue 3 + Vite + Vitest + Tabler Icons + Vue Router, with specific component patterns for inventory management (Kanban), product display, and sales dashboard.

## Core Concepts
- **Vue 3 + Vite**: Composition API, `<script setup>`, Vite for fast HMR and builds
- **Component Architecture**: `SideBar.vue` (navigation), `KanbanBoard.vue` (drag-drop inventory), `GaleriaProductos.vue` (product grid), `BuscadorProductos.vue` (search), `Productos.vue`, `Inventario.vue`
- **Vitest**: Unit testing aligned with Vite config, component testing for Vue SFCs
- **Tabler Icons**: Consistent icon library used across all UI components
- **Vue Router**: Route-based navigation with `App.vue` as root layout

## Key Relationships
- `App.vue` → contains → `SideBar.vue` + router-view
- `Inventario.vue` → renders → `KanbanBoard.vue` (with pending fix for inactive product filtering)
- `BuscadorProductos.vue` → filters → `GaleriaProductos.vue` display
- `Vue Router` → maps → routes to page components
- `Vite` → builds → optimized bundle with tree-shaking for Tabler Icons

## Mental Models
- **Kanban inventory pattern**: Products flow through status columns (Inactivo → Activo → Vendido), with soft-delete controlling visibility
- **Component-per-feature**: Each view (Inventario, Galeria, Buscador, Analisis) is a self-contained Vue SFC with its own data fetching
- **Build flag isolation**: `VUE_APP_HABILITAR_WIP` hides unreleased components from production without code splitting

## When NOT to use
- Skip for backend API work (use Go/MiNegocio backend knowledge instead)
- Skip for CI/CD pipeline configuration (use Jenkins-specific knowledge)
