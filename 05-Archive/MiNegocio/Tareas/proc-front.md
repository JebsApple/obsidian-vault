---
tags: [proyecto/minegocio, sprint-3, handoff, frontend]
updated: 2026-06-27
assignee: victor
estado: listo-para-review
---

# proc-front — Plan de Base Frontend S3-HU02

## Perspectiva
Victor Herrera. S3-HU02 completado (JWT_SECRET por entorno). Base frontend funcional dejada para implementaciones del equipo.

## ✅ ACTUALIZACIÓN 2026-06-27 — Polish completado

Rama `sandbox/proc-front` lista en Gitea (commit `6e3bdca`). Ver [[Reporte-polish-frontend-2026-06-27]] para detalle completo.

### Resumen de cambios aplicados:

**Bugs corregidos (detectados en deploy :8082):**
- [x] Favicon: logo Vue CLI → SVG del kiosko MiNegocio (`public/favicon.svg`)
- [x] Sidebar mobile "gris a la mitad" → sidebar full-width con nav horizontal en ≤768px
- [x] Imágenes productos 404 → proxy `/uploads/` en `vue.config.js` (prod: pendiente nginx)
- [x] Login no guardaba nombre/rol → `getUserFromToken()` lee JWT directamente (sin duplicar en localStorage)

**Polish de UI:**
- [x] **Avatar usuario:** círculo rojo `#d60000` con inicial del nombre (ej. `V` para Victor) — `SideBar.vue`
- [x] **LoginPage rediseñado:** card con sombra, logo + branding MiNegocio, labels, spinner en botón, error con badge
- [x] **VentasPage:** inline styles eliminados → clases CSS con hover nativo (`.producto-card:hover` con borde rojo)
- [x] **InventarioPage:** inline styles eliminados → `.resultado-item`, `.stock-input`, hover CSS
- [x] **Ganancia estimada:** badge verde cuando hay ganancia, rojo cuando precio compra ≥ venta
- [x] **AppModal:** reemplaza `alert()`/`confirm()` del browser en toda la app (venta registrada, errores, confirmaciones de eliminado)

**Arquitectura:**
- [x] Refactor JWT: `getUserFromToken()` en `authService.js` — fuente única de verdad para nombre y rol

**Tests:** 23/23 ✅ | **Build:** limpio ✅

## Método
Evolutivo sobre código existente (no reescritura). Respetando arquitectura de capas del backend y componentes Vue.js. Sin tocar tareas de otros integrantes.

## Decisiones tomadas
| Decisión | Detalle |
|----------|---------|
| Login solo ingreso | Se quitó modo registro. Solo admin + usuarios DB pueden entrar |
| Auth guard global | `beforeEach` en router — rutas protegidas redirigen a `/login` |
| Landing + Dashboard | Combinados en `AnalisePage.vue` con toggle según estado de login |
| SideBar condicional | Enlaces visibles según rol (`esAdmin` desde localStorage) |
| Admin Usuarios | Placeholder + instrucciones en comentarios HTML para el implementador |
| Export reporte | Botón placeholder con comentario asignando tarea a Ignacio |
| PatchStock | Ruta registrada en backend (`PATCH /api/inventario/{id}/stock`) |

## Archivos modificados/creados
- `src/views/LoginPage.vue` — Eliminar registro
- `src/views/AnalisePage.vue` — Comentarios para Ignacio + botón export placeholder
- `src/router/index.js` — Auth guard + ruta /admin/usuarios
- `src/components/SideBar.vue` — Enlace Admin Usuarios (solo admin) + placeholder Sesiones
- `src/views/AdminUsuariosPage.vue` — Página placeholder
- `backend/routes/routes.go` — +1 línea (PATCH inventario)
- `backend/README.md` — Actualizado
- `frontend/README.md` — Actualizado

## No considerado (tareas de otros)
| Tarea | Asignado |
|-------|----------|
| S3-HU04: Control de roles | Gabriel |
| S3-HU05: id_vendedor dinámico | Ignacio + Gabriel |
| S3-HU07: Auditoría sesiones | Gabriel + Ignacio |
| S3-HU08: Auto-migraciones DB | Victor + Gabriel |
| Export PDF/Excel | Ignacio |
| Dashboard stats backend | Ignacio |
| S3-HU09: Limpieza código muerto | Ignacio |
| S3-HU10: KanbanBoard | Ignacio |

## ✅ 2026-06-27 — Separación en ramas S3-HU02 completada

El trabajo del `S3-HU02` local se separó en ramas independientes en Gitea:

| Rama | Contenido | Commits |
|------|-----------|---------|
| `S3-HU02-T01-navegacion-barra-lateral` | NavBar, SideBar, LogoSVG, layout auth, login rediseñado, estilos base | 1 |
| `S3-HU02-T02-tablero-kanban` | KanbanBoard.vue + panel drag & drop en InventarioPage | 1 |
| `S3-HU02-T03-panel-principal` | AnalisePage KPIs, ganancia badge, VentasPage inline→CSS | 1 |
| `S3-HU02-T04-pruebas` | Tests Vitest (5 suites, 23 tests) + vitest.config.js | 1 |
| `S3-HU02-T05-validaciones` | AppModal global, validaciones, reemplazo alert/confirm | 1 |

Todas creadas desde `main` con cambios limpios, sin incluir tareas de otros integrantes. Cada rama es independiente y revisable por separado.

## Próximos pasos
