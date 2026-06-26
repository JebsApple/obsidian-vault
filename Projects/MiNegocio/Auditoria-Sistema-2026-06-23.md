---
tags: [proyecto/minegocio, auditoria, sistema]
---

# Auditoría de Sistema — tempMiNegocio (repo clonado)
**Fecha:** 2026-06-23 | **Repo:** `github.com/JebsApple/tempMiNegocio` (privado)
**Clonado en:** `/tmp/opencode/tempMiNegocio`

---

## Resumen del proyecto

| Componente | Tecnología | Archivos | Líneas aprox |
|---|---|---|---|
| **Frontend** | Vue 3.2 + Vue Router 5 + Vue CLI 5 | ~27 src | ~4,664 |
| **Backend** | Go 1.22+ (Gorilla Mux, lib/pq, golang-jwt) | ~27 src | ~2,500 |
| **Base de Datos** | PostgreSQL 16.14 | 8 SQL | ~1,200 |
| **Docs/Diseño** | HTML standalone | 2 | ~583 |

---

## Conexiones Frontend → Backend

| Endpoint Frontend | Backend existe | Coinciden |
|---|---|---|
| `POST /api/login` | ✅ | ✅ |
| `POST /api/register` | ✅ | ✅ |
| `GET /api/productos` | ✅ | ✅ |
| `GET /api/productos/buscar` | ✅ | ✅ |
| `POST /api/productos` | ✅ | ✅ |
| `PUT /api/productos/{id}` | ✅ | ✅ |
| `DELETE /api/productos/{id}` | ✅ | ✅ |
| `POST /api/productos/{id}/imagen` | ✅ | ✅ |
| `DELETE /api/productos/{id}/imagen` | ✅ | ✅ |
| `POST /api/ventas` | ✅ | ✅ |
| `GET /api/ventas` | ✅ | ✅ |

**⚠️ Endpoints de sesión** (`/api/sesiones/inicio`, `/api/sesiones/cierre`) existen en backend pero **no son consumidos** por el frontend.

**⚠️ Handler `PatchStock`** en backend **no está registrado** en rutas (dead code).

---

## Conexiones Backend → Base de Datos

- Tablas `usuarios`, `productos`, `registro_ventas` existen y columnas coinciden con las queries ✅
- Vista `inventario_view` existe y es usada por `inventario_repository.go` ✅
- Usuario `app_user` tiene permisos correctos ✅
- Migraciones (001: `stock_status`, 002: `registro_ventas`) aplicadas al esquema ✅

---

## Issues encontrados

### 🔴 Críticos

| ID | Issue | Componente | Detalle |
|----|-------|-----------|---------|
| AU-01 | **API_BASE hardcodeada en productosService** | Frontend | `productosService.js` usa `const API_BASE = ''` mientras `ventasService.js` importa desde `@/config/api`. Si cambia la base URL, productos falla. |
| AU-02 | **go.mod vs Dockerfile version mismatch** | Backend | `go.mod` dice `go 1.25.0` pero Dockerfile usa `golang:1.22-alpine`. |
| AU-03 | **CORS `*` en producción** | Backend | `Access-Control-Allow-Origin: *` — debería restringirse a orígenes específicos. |
| AU-04 | **Password texto plano en seed data** | DB | `backup_server.sql` contiene `password_hash='1234'`. `setup_produccion.sql` tiene placeholder `CAMBIAR_POR_HASH_REAL`. |

### 🟡 Medios

| ID | Issue | Componente | Detalle |
|----|-------|-----------|---------|
| AU-05 | **Sin guards de ruta** | Frontend | No hay `router.beforeEach`. Cualquier usuario navega a cualquier ruta sin token. |
| AU-06 | **Sin archivos .env** | Frontend | Código espera `VUE_APP_API_BASE` pero no hay `.env.development` ni `.env.production`. |
| AU-07 | **Binario compilado en repo** | Backend | `minegocio-api` (10MB ELF con debug info) incluido en el repo. |
| AU-08 | **Dead code `PatchStock`** | Backend | Handler existe pero no está registrado en rutas. |
| AU-09 | **setup_produccion.sql sin hash real** | DB | Placeholder `CAMBIAR_POR_HASH_REAL` — riesgo de despliegue sin reemplazar. |
| AU-10 | **JWT_SECRET sin fallback** | Backend | `panic` si no se setea `JWT_SECRET`. |

### 🟢 Bajos

| ID | Issue | Componente | Detalle |
|----|-------|-----------|---------|
| AU-11 | **Sin tests frontend** | Frontend | Backend tiene tests Go, frontend no tiene ninguno. |
| AU-12 | **Sin docker-compose** | Global | No hay orquestación de contenedores. |
| AU-13 | **README desactualizado** | Backend | Solo documenta 4 endpoints originales, el código tiene 13. |
| AU-14 | **Dump DB incluye todas las bases** | DB | `backup_server.sql` expone template1, cliente_dev, etc. |

---

## Pruebas existentes

| Componente | Archivos test | Estado |
|---|---|---|
| Backend config | `db_test.go`, `jwt_test.go` | ✅ |
| Backend auth | `auth_handler_test.go`, `auth_service_test.go` | ✅ |
| Backend productos | `producto_handler_test.go`, `producto_service_test.go` | ✅ |
| Backend middleware | `auth_middleware_test.go` | ✅ |
| Frontend | ❌ Sin tests | ❌ |
| Database | ❌ Sin tests | ❌ |

---

## Estado del CI/CD (Jenkins)

| Componente | Pipeline | Estado |
|---|---|---|
| Backend | Checkout → `go test` → build Docker → deploy SSH a `192.168.50.25` | ✅ |
| Database | Validar SQL → rsync → psql remoto | ✅ |
| Frontend | ❌ Sin pipeline (despliegue manual via WinSCP) | ❌ |

---

## Endpoints del Backend

### Públicos (sin auth)
| Método | Ruta |
|---|---|
| POST | `/api/login` |
| POST | `/api/register` |

### Protegidos (JWT Bearer)
| Método | Ruta |
|---|---|
| GET | `/api/productos/buscar` |
| GET | `/api/productos` |
| POST | `/api/productos` |
| PUT | `/api/productos/{id:[0-9]+}` |
| DELETE | `/api/productos/{id:[0-9]+}` |
| POST | `/api/productos/{id:[0-9]+}/imagen` |
| DELETE | `/api/productos/{id:[0-9]+}/imagen` |
| GET | `/api/inventario` |
| POST | `/api/ventas` |
| GET | `/api/ventas` |
| POST | `/api/sesiones/inicio` |
| POST | `/api/sesiones/cierre` |
| GET | `/uploads/{path}` (static) |

---

## Rutas del Frontend (Vue Router)

| Path | Nombre | Componente |
|---|---|---|
| `/` | `analisis` | AnalisePage |
| `/login` | `login` | LoginPage |
| `/productos` | `producto` | ProductosPage |
| `/productos-registrados` | `productos-registrados` | ProductosRegistrados |
| `/inventario` | `inventario` | InventarioPage |
| `/ventas` | `ventas` | VentasPage |

---

## Esquema de Base de Datos

```
usuarios (id, nombre, email, password_hash, rol, activo, fecha_creacion, fecha_actualizacion)
  │
  ├──< productos (id, nombre, codigo_barras, precio_compra, precio_venta, stock,
  │               imagen_url, descripcion, categoria, marca, fecha_ingreso,
  │               id_usuario → FK, activo, stock_status)
  │
  └──< registro_ventas (id_venta, id_producto → FK, precio_producto, cantidad,
                        fecha_venta, id_vendedor → FK)
```

Vista: `inventario_view` — clasifica stock como Normal (>=5), Bajo (1-4), Agotado (0).

---

## Configuración de conexiones

### Frontend → Backend
- **Desarrollo**: Proxy en `vue.config.js`: `/api` → `http://localhost:3000`
- **Producción**: Nginx sirve frontend estático y redirige `/api/` al backend en puerto 3000/3001
- **API_BASE**: Variable de entorno `VUE_APP_API_BASE` (vacío → mismo origen)

### Backend → Base de Datos
- Variables de entorno: `DB_HOST` (default `172.17.0.1`), `DB_PORT` (`5432`), `DB_USER` (`postgres`), `DB_PASSWORD` (requerida), `DB_NAME` (`cliente_dev`), `DB_SSLMODE` (`disable`)
- JWT: `JWT_SECRET` (requerido, sin default)
- Puerto: `APP_PORT` (default `3000`)

---

## Recomendaciones

1. 🔴 Unificar `API_BASE` en `productosService.js` para que use `@/config/api`
2. 🔴 Corregir mismatch Go version (Dockerfile vs go.mod)
3. 🔴 Restringir CORS a orígenes específicos en producción
4. 🔴 Generar hash bcrypt real para seed data y setup_produccion.sql
5. 🟡 Agregar `router.beforeEach` con verificación de token
6. 🟡 Crear `.env.development` y `.env.production` con `VUE_APP_API_BASE`
7. 🟡 Agregar `minegocio-backend/minegocio-api` al `.gitignore` raíz
8. 🟡 Revisar `setup_produccion.sql` antes de ejecutar
9. 🟢 Agregar tests al frontend
10. 🟢 Pipeline CI/CD para frontend (Jenkinsfile)
