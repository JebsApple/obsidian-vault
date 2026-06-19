---
tags: [report, sprint2, revert, ejecutado]
updated: 2026-06-19
---

# Reporte: Ejecución S2-Post-STL-Revert-Plan

> Fecha: 2026-06-19
> Estado: ✅ COMPLETADO

## Resumen

Se ejecutó el plan de reversión del `S2-STL-Frontend-Redesign` conservando funcionalidades del Sprint 2 (JWT, Ventas API, Carga de Imágenes, UX Login).

## Resultados

### Backend (`minegocio-backend`) — commit `19bbc55`

| Cambio | Estado |
|--------|--------|
| Reset main → origin/main (9b8d22f) | ✅ |
| JWT S2-HU03 (config/jwt.go, handler/auth_handler.go, service/auth_service.go) | ✅ |
| Refresh token endpoint (`POST /api/auth/refresh`) | ✅ |
| Ventas S2-HU02-API (handler/venta_handler.go, service/venta_service.go, repository/venta_repository.go) | ✅ |
| CORS middleware | ✅ |
| Tests (`go test ./...`) | ✅ Pasan todos |

### Frontend (`minegocio-frontend`) — commit `898137e`

| Cambio | Estado |
|--------|--------|
| Reset main → origin/main (3f6a676) | ✅ |
| Carga de Imágenes (cherry-pick b7501b4) | ✅ |
| JWT Frontend (axios plugin, authService, authGuard) | ✅ |
| UX Login (login.css con paleta #D60000/blanco/#2C3E50, responsive 375px) | ✅ |

### Base de Datos

| Migración | Estado |
|-----------|--------|
| `registro_ventas` | ✅ Aplicada |
| `registro_sesiones` | ✅ Aplicada |

## Endpoints API

| Ruta | Método | Auth | Estado |
|------|--------|------|--------|
| `/api/login` | POST | No | ✅ |
| `/api/auth/login` | POST | No | ✅ |
| `/api/auth/refresh` | POST | No | ✅ |
| `/api/productos` | GET | Sí | ✅ |
| `/api/productos/buscar` | GET | Sí | ✅ |
| `/api/productos/{id}/imagen` | POST/DELETE | Sí | ✅ |
| `/api/inventario` | GET | Sí | ✅ |
| `/api/ventas` | GET/POST | Sí | ✅ |

## Incidentes

- **Docker conflict**: Los contenedores `backend` y `backend-prod` estaban corriendo en puertos 3000/3001 con código antiguo, interfiriendo con las pruebas. Se detuvieron y el servidor actual corre en puerto 3000.
- **Ruteo**: Las nuevas rutas bajo `/api/auth/` y `/api/ventas` requirieron middleware de autenticación individual en lugar de `router.Use()` + `PathPrefix("/api").Subrouter()`, por problemas de matching con gorilla/mux v1.8.1.

## Commits

- Backend: `19bbc55` — `feat: integrar JWT (S2-HU03) + ventas API (S2-HU02)`
- Frontend: `898137e` — `feat: revertir STL-redesign, conservar funcionalidades S2`

## Próximos Pasos (Sprint 3)

- NavBar/SideBar/KanbanBoard/AnalisePage del STL-redesign
- Registro de usuarios (feat/registro-usuarios)
- Despliegue CI/CD con Docker + Jenkins

---

## Archivos modificados (backend)

- `config/jwt.go` — GenerateRefreshToken, env-based expiry
- `handler/auth_handler.go` — Refresh endpoint
- `handler/venta_handler.go` — Create, GetAll
- `service/auth_service.go` — RefreshToken
- `service/venta_service.go` — CreateVenta, GetAllVentas
- `repository/venta_repository.go` — CRUD registro_ventas
- `models/models.go` — AuthResponse, RefreshTokenRequest, RegistroVenta, CreateVentaRequest, VentaResponse
- `routes/routes.go` — nuevas rutas con auth middleware directo
- `main.go` — CORS wrapper, VentaHandler injection

## Archivos modificados/creados (frontend)

- `src/plugins/axios.js` — Axios interceptor con JWT
- `src/services/authService.js` — login/logout/refreshToken
- `src/services/ventasService.js` — Bearer headers
- `src/middleware/authGuard.js` — route guard
- `src/router/index.js` — beforeEach global auth guard
- `src/views/LoginPage.vue` — guarda token, redirect a /servicios
- `src/styles/login.css` — paleta #D60000, responsive 375px
