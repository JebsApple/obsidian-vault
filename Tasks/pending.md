---
tags: [tasks, handoff, backend]
updated: 2026-06-18
assignee: ai-reader
---

# Tareas pendientes para agente lector

## Contexto
Proyecto MiNegocio. Backend Go en http://192.168.50.28:3000 (Gitea).
Token Gitea: d752677e480b9da4b92e1547d10328e426bcc3c5
Ver [[MiNegocio]] para contexto completo.

---

## ✅ COMPLETADO — Merge S2-HU04 backend (2026-06-18)

Main de backend ahora incluye:
- `GET /api/productos/buscar` — búsqueda con filtros y paginación
- `POST /api/productos/{id}/imagen` — upload de imagen (validación MIME, 5MB max)
- `DELETE /api/productos/{id}/imagen` — eliminar imagen

Commit: `0a04bb2 merge: integrar S2-HU04 API imágenes de productos`

---

## 🔲 PENDIENTE — PR frontend S2-HU04

La rama `S2-HU04-Frontend-Galeria` en `VHerrera/MiNegocio-frontend` tiene los cambios completos pero el PR no fue mergeado a main aún.

**Tarea:** Verificar si el PR existe en Gitea. Si no existe, crearlo. Si existe, verificar que pasa CI y hacer merge.

URL PR sugerida: http://192.168.50.28:3000/VHerrera/MiNegocio-frontend/pulls

**Criterio de éxito:** Rama `S2-HU04-Frontend-Galeria` mergeada a `main` en frontend.

---

## 🔲 PENDIENTE — Smoke test backend S2-HU04

Verificar los 4 endpoints nuevos contra el servidor DEV:
1. `GET /api/productos/buscar?q=test` → 200 con `{status:"ok", total:N, productos:[]}`
2. `GET /api/productos/buscar?stock_status=bajo` → 200
3. `POST /api/productos/1/imagen` con imagen JPG → 201 con `imagen_url`
4. `DELETE /api/productos/1/imagen` → 200

Necesita token JWT (obtener via `POST /api/login`).
Si algún endpoint falla, abrir issue en Gitea: http://192.168.50.28:3000/VHerrera/MiNegocio-backend/issues
