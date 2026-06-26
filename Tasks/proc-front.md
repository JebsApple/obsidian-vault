---
tags: [proyecto/minegocio, sprint-3, handoff, frontend]
updated: 2026-06-26
assignee: victor
---

# proc-front — Plan de Base Frontend S3-HU02

## Perspectiva
Victor Herrera. S3-HU02 completado (JWT_SECRET por entorno). Base frontend funcional dejada para implementaciones del equipo.

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

## Próximos pasos
Ejecutar implementación cuando se autorice. Ver [[pending]] para estado general.
