---
name: "MiNegocio Backend Lessons"
description: "Use when working with MiNegocio backend patterns, POS systems, auth middleware, or Go+Vue full-stack issues. Triggers: FOR UPDATE, POS barcode, RequireRole, AuthMiddleware, Cropper.js, JWT refactor. Skip if unrelated to MiNegocio or Go backend."
user-invocable: false
---

# MiNegocio Backend Lessons

## Domain
Hard-won backend development lessons from MiNegocio: transactional safety, auth patterns, upload handling, and frontend-backend integration pitfalls in a Go + Vue.js POS system.

## Core Concepts
- **Venta transaccional FOR UPDATE**: Row-level locking for concurrent POS sales. Prevents oversell on race conditions.
- **registro_ventas table**: Sales ledger written by POS. Integrity depends on transactional writes above.
- **RequireRole middleware**: Role-based access control. Builds on AuthMiddleware. Protects Proveedor CRUD and admin routes.
- **AuthMiddleware context fix**: Critical hotfix — middleware wasn't passing user context to handlers, breaking downstream auth.
- **Upload middleware**: Magic bytes validation (not just extension). Prevents malicious file uploads.
- **JWT as single truth**: One JWT source, no duplicate tokens in localStorage. Eliminates auth desync between service and storage.
- **localStorage not reactive in Vue**: Writing to localStorage doesn't trigger Vue reactivity. Need explicit watchers or reactive refs.
- **Barcode scanner**: Integrates with POS for product lookup. Shared feature between Ignacio and Nicolás workstreams.
- **Reporte handler**: PDF via wkhtmltopdf, Excel via excelize. Runs parallel to Proveedor CRUD in same branch.

## Key Relationships
- AuthMiddleware fix → enables → Venta transaccional (auth must work before transactions)
- AuthMiddleware fix → fixes_bug_in → POS system (core bug blocking sales)
- RequireRole → protects → Proveedor CRUD (role gate on admin endpoints)
- AuthMiddleware fix → extended_by → authService.js (JWT lifecycle management)
- Barcode scanner → integrates_with → POS system (scanner triggers product lookup)
- Upload middleware → used_by → ModalFotoPerfil (Cropper.js → upload → server)
- JWT refactor → motivated_by → localStorage reactivity + JWT single-truth lessons

## Mental Models
- **Transaction = lock + write + unlock**: FOR UPDATE on row, do work, commit. Skip any step = race condition.
- **Auth flows downhill**: Fix middleware first, everything downstream depends on it. AuthMiddleware → RequireRole → handlers.
- **One truth, one place**: JWT lives in one spot (cookie or header), never duplicated in localStorage + memory.

## When NOT to use
- Skip for new projects without POS/transaction requirements.
- Skip for pure frontend work unrelated to MiNegocio auth patterns.
- Skip for Python or Node.js backends (patterns are Go-specific).
