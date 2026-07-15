---
name: "MiNegocio S3 Procedures"
description: "Use when working with MiNegocio Sprint 3 procedures — CRUD Proveedores, audits, bug reports, session logs, or task tracking. Triggers: S3-HU05, CRUD Proveedores, HU02, Taiga, auditoría Sprint 3, productos fantasma, IVA 19%. Skip if unrelated to Sprint 3 execution."
user-invocable: false
---

# MiNegocio S3 Procedures

## Domain
Sprint 3 operational procedures for MiNegocio: user stories (HU02 frontend redesign, HU05 CRUD Proveedores), audit trails, bug reports, and session-by-session development logs from 2026-06-27 to 2026-07-10.

## Core Concepts
- **S3-HU05 CRUD Proveedores**: repository → service → handler → Vue page pattern for entity creation
- **S3-HU02 Frontend**: KanbanBoard animations, sidebar spring/stagger/ripple, Tabler icons, barcode support
- **Productos Fantasma Bug**: `Scan()` without `COALESCE` returns phantom products — requires SQL fix
- **IVA 19%**: price breakdown concept (precio_sin_iva) applied across product forms
- **Kanban Ubicaciones**: physical location classification (Bodega/Vitrina/Sin clasificar) for inventory

## Key Relationships
- Taiga → drives → Gitea branches → dev → main (deployment flow)
- S3-HU05 instrucciones (Gabriel) → implemented by → repository/service/handler Go files + ProveedoresPage.vue
- S3-HU02 plan → produced → animaciones sidebar, KanbanBoard, productos fantasma fix
- Auditoría 2026-07-02 → reviewed → T08/T15 tasks + Kanban ubicaciones + fantasmas fix

## Mental Models
- **Plan → Execute → Audit cycle**: each task has a plan doc, session log, then audit report — follow this chain for any S3 task
- **Bug triage pattern**: informe bugs → register in Taiga → fix in session → verify in audit
- **Sesión log chain**: sequential session logs (06-27 → 06-28 → ... → 07-10) form a temporal breadcrumb trail

## When NOT to use
- Skip for team role assignments (see MiNegocio Team & Knowledge skill)
- Skip for Sprint 2 historical data (already archived)
