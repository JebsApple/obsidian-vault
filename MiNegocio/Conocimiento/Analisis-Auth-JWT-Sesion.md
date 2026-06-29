---
tags: [analisis, auth, jwt, sesion, frontend]
---

# Análisis: JWT (Gabriel) + Sesión en Frontend

**Fecha:** 2026-06-19

## Backend (Gabriel) — Correcto y completo

Gabriel implementó un sistema JWT de doble token en el backend (`config/jwt.go`):

| Token | Duración | Claims |
|-------|----------|--------|
| Access Token | 24h | `user_id`, `nombre`, `rol` |
| Refresh Token | 7d | `user_id`, `nombre`, `rol` |

### Archivos clave del backend
| Archivo | Propósito |
|---------|-----------|
| `config/jwt.go` | Generación de tokens HS256 con claims |
| `service/auth_service.go` | Login (access + refresh) y RefreshToken (nuevo access) |
| `middleware/auth_middleware.go` | Valida Bearer token en rutas protegidas |
| `handler/auth_handler.go` | Endpoints `/api/auth/login` y `/api/auth/refresh` |
| `routes/routes.go` | Protege rutas de productos, ventas, inventario |

**Estado:** Funcional. No requiere cambios.

## Frontend — 3 problemas que desconectan el JWT

### 1. LoginPage.vue usa endpoint legacy sin refresh_token
- `LoginPage.vue` POSTea a `/api/login` (endpoint legacy), NO a `/api/auth/login`
- Solo guarda `localStorage.setItem('token', data.token)`
- **NO guarda** `refresh_token`
- `authService.js` tiene la función `login()` que sí usa `/api/auth/login` y guarda ambos tokens, pero **nunca se llama desde ningún lado**

### 2. Mayoría de llamadas API usan fetch() directo, sin refresh
- Solo el interceptor de Axios (`plugins/axios.js`) maneja refresh automático
- Casi todos los servicios (`productosService.js`, `ventasService.js`) y vistas usan `fetch()` + `authHeaders()`
- Si el token expira en sesión, fallan con 401 sin intentar refrescar

### 3. No hay store de auth reactivo
- `lecciones.md` documenta `src/store/auth.js` pero **no existe en el código actual**
- `localStorage.getItem('token')` en computed properties no es reactivo en Vue

### Flujo actual
```
LoginPage.vue → POST /api/login → {token} → localStorage('token')
                                                         ↓
App.vue lee localStorage('token') ← chequeo en cada ruta
                                                         ↓
fetch() a API con header Authorization: Bearer <token>
     ├── si expira → 401 → (sin refresh, solo error)
     └── si usa Axios → interceptor refresca automáticamente
```

## Conclusión
El backend JWT de Gabriel **no está obsoleto**. El frontend no lo consume correctamente.

## Archivos afectados
- `src/views/LoginPage.vue` — cambiar endpoint + guardar refresh_token
- `src/services/authService.js` — login() existe pero no se usa
- `src/plugins/axios.js` — interceptor funcional pero no cubre todos los servicios
- `src/services/productosService.js` — fetch() directo
- `src/services/ventasService.js` — fetch() directo
- Varias vistas leen token manualmente
