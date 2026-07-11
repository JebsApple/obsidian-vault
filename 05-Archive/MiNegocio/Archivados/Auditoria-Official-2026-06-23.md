---
tags: [proyecto/minegocio, auditoria, sistema, oficial]
---

# Auditoría de Sistema — MiNegocio oficial
**Fecha:** 2026-06-23
**Repos oficiales:** Gitea `192.168.50.28:3000` (3 repos: frontend, backend, database)
**Ubicación local:** `/home/icin/minegocio-{frontend,backend,database}`

---

## Resumen del proyecto

| Componente | Tecnología | Rama | Commits ahead | Estado git |
|---|---|---|---|---|
| **Frontend** | Vue 3.2 + Vue Router 5 + Vue CLI 5 | `main` | 0 (`origin/main`) | ✅ Clean |
| **Backend** | Go 1.22 + Gorilla Mux + lib/pq + golang-jwt | `main` | **+10** (`origin/main`) | ⚠️ Sin push |
| **Base de Datos** | PostgreSQL 16.14 | `main` | **+4** (`origin/main`) | ⚠️ Sin push |

---

## Comparativa: oficial vs tempMiNegocio

El repo `tempMiNegocio` (GitHub/JebsApple) funciona como un **branch alternativo/experimental** con diferencias significativas:

### Frontend

| Aspecto | Oficial | tempMiNegocio |
|---|---|---|
| **Nombre paquete** | `MiNegocio` | `pruevaservidornginx` |
| **HTTP client** | `axios` + `jwt-decode` + `fetch` | Solo `fetch` nativo |
| **Auth endpoints** | `/api/auth/login`, `/api/auth/refresh` | `/api/login`, `/api/register` |
| **Auth service** | `authService.js` con JWT decode + refresh | No tiene (login en LoginPage.vue directo) |
| **Route guards** | ✅ `router.beforeEach` con verificación | ❌ No tiene |
| **API_BASE** | No tiene `config/api.js` | Tiene `config/api.js` con `VUE_APP_API_BASE` |
| **Sistema de diseño** | CSS inline + imports por archivo | CSS variables (`variables.css`, `components.css`, `base.css`) |
| **Componentes únicos** | — | `NavBar`, `SideBar`, `LogoSVG`, `KanbanBoard` |
| **Vistas únicas** | `HomePage`, `ServiciosPage`, `ContactoPage`, `RegistroVentasPage` | `AnalisePage` (dashboard) |
| **Registro usuarios** | ❌ No soportado | ✅ Formulario de registro |
| **Tests** | ❌ Ninguno | ❌ Ninguno |
| **Auth token storage** | `token` + `refresh_token` | `token` + `usuario` (JSON) |

### Backend

| Aspecto | Oficial | tempMiNegocio |
|---|---|---|
| **Go version** | `go 1.22.12` ✅ (coincide con Dockerfile) | `go 1.25.0` ❌ (mismatch con Docker `1.22`) |
| **JWT refresh** | ✅ `POST /api/auth/refresh` | ❌ No tiene |
| **Auth endpoints** | `/api/login` + `/api/auth/login` + `/api/auth/refresh` | Solo `/api/login` + `/api/register` |
| **Inventario stock** | ✅ `PATCH /api/inventario/{id}` registrado | ❌ Handler `PatchStock` no registrado (dead code) |
| **JWT secret** | Fallback a string default | `panic` si no se setea |
| **CORS** | Incluye `PATCH` en métodos | No incluye `PATCH` |
| **Tests** | ✅ 6 archivos test | ✅ 6 archivos test |
| **Binario compilado** | `.gitignore` lo ignora (`main`, `main-prod`) | Binario `minegocio-api` presente en repo |
| **Sesiones handler** | ❌ No existe | ✅ Existe (pero no usado por frontend) |

### Base de Datos

| Aspecto | Oficial | tempMiNegocio |
|---|---|---|
| **Migraciones** | `registro-ventas/` y `registro-sesiones/` como scripts SQL sueltos | `migrations/001_add_stock_status.sql` y `002_create_registro_ventas.sql` |
| **README.md** | ✅ 92 líneas completo | ❌ No tiene |
| **stock_status** | ❌ No implementado | ✅ Migración 001 lo agrega (para Kanban) |
| **registro_sesiones** | ✅ Tabla definida con create/drop | ❌ No existe |
| **esquema.sql raíz** | Solo migración parcial (20 líneas) | Schema completo (58 líneas) |
| **backup_server.sql** | ✅ Idéntico | ✅ Idéntico |
| **setup_produccion.sql** | ✅ Idéntico | ✅ Idéntico |

---

## Conexiones Frontend → Backend

### Endpoints consumidos por el frontend oficial

| Endpoint                            | Backend existe                                          | Coinciden |
| ----------------------------------- | ------------------------------------------------------- | --------- |
| `POST /api/login`                   | ✅                                                       | ✅         |
| `POST /api/auth/login`              | ✅                                                       | ✅         |
| `POST /api/auth/refresh`            | ✅                                                       | ✅         |
| `GET /api/productos`                | ✅                                                       | ✅         |
| `GET /api/productos/buscar`         | ✅                                                       | ✅         |
| `POST /api/productos`               | ✅                                                       | ✅         |
| `PUT /api/productos/{id}`           | ✅                                                       | ✅         |
| `DELETE /api/productos/{id}`        | ✅                                                       | ✅         |
| `POST /api/productos/{id}/imagen`   | ✅                                                       | ✅         |
| `DELETE /api/productos/{id}/imagen` | ✅                                                       | ✅         |
| `POST /api/ventas`                  | ✅                                                       | ✅         |
| `GET /api/ventas`                   | ✅                                                       | ✅         |
| `GET /api/ventas/{id}`              | ⚠️ Handler no existe (venta individual no implementada) | ❌         |
| `GET /api/inventario`               | ✅                                                       | ✅         |
| `PATCH /api/inventario/{id}`        | ✅                                                       | ✅         |

### Endpoints NO consumidos por el frontend
- `POST /api/register` — existe en `tempMiNegocio` pero NO en el backend oficial

---

## Conexiones Backend → Base de Datos

- Tablas `usuarios`, `productos`, `registro_ventas` existen y columnas coinciden ✅
- Vista `inventario_view` existe y es usada por `inventario_repository.go` ✅
- Usuario `app_user` tiene permisos correctos ✅
- `registro_ventas` usa FK a `productos(id)` y `usuarios(id)` ✅
- Soft delete `activo = true` en todas las queries ✅

---

## Issues oficiales

### 🔴 Críticos

| ID | Issue | Componente | Detalle |
|---|---|---|---|
| AO-01 | **Password texto plano en seed data** | DB | `backup_server.sql` contiene `password_hash='1234'`. README dice "pendiente migrar a bcrypt". |
| AO-02 | **JWT_SECRET hardcodeado con fallback** | Backend | `config/jwt.go:33` — default: `"MiNegocio2026_SuperSecretKey_CambiarEnProduccion!"`. Si alguien accede al binario tiene la clave. |
| AO-03 | **Login sin bcrypt** | Backend | `usuario_repository.go:22` compara `WHERE password_hash = $2` en texto plano. |
| AO-04 | **setup_produccion.sql sin hash real** | DB | Placeholder `'CAMBIAR_POR_HASH_REAL'` en el INSERT de admin. |

### 🟡 Medios

| ID | Issue | Componente | Detalle |
|---|---|---|---|
| AO-05 | **10 commits backend sin pushear** | Backend | `main` está +10 ahead de `origin/main`. Riesgo de pérdida. |
| AO-06 | **4 commits DB sin pushear** | DB | `main` está +4 ahead de `origin/main`. |
| AO-07 | **CORS `*` en producción** | Backend | `Access-Control-Allow-Origin: *` en `main.go`. |
| AO-08 | **Sin tests frontend** | Frontend | Backend tiene 6 tests, frontend 0. |
| AO-09 | **Sin CI/CD frontend** | Frontend | Backend y DB tienen Jenkinsfile, frontend no. |
| AO-10 | **Ventas sin tests** | Backend | `venta_handler.go` y `venta_service.go` no tienen tests. |
| AO-11 | **Sin control de migraciones DB** | DB | Scripts SQL sueltos sin tabla `schema_migrations`. |
| AO-12 | **Sin login por rol** | Backend | AuthMiddleware no expone claims al handler. `id_vendedor` queda sin resolver. |

### 🟢 Bajos

| ID | Issue | Componente | Detalle |
|---|---|---|---|
| AO-13 | **HelloWorld.vue sin uso** | Frontend | Boilerplate de Vue CLI, nunca se usa. |
| AO-14 | **CSS duplicado** | Frontend | Estilos hardcodeados en cada componente en vez de compartidos. |
| AO-15 | **Sin variables de entorno** | Frontend | Solo existe `.env.local` con `host ip 192.168.50.25` (formato inválido). |
| AO-16 | **Sin TypeScript** | Frontend | Options API sin tipos, sin autocompletado. |
| AO-17 | **`getVenta(id)` sin handler backend** | Backend | `ventasService.js` llama a `GET /api/ventas/{id}` pero no hay handler implementado. |

---

## Estado del CI/CD

| Componente | Pipeline | Estado |
|---|---|---|
| Backend | Jenkins: Checkout → `go test` → build Docker → deploy SSH a `192.168.50.25` | ✅ |
| Database | Jenkins: Validar SQL → rsync → psql remoto | ✅ |
| Frontend | ❌ Sin pipeline (despliegue manual via WinSCP) | ❌ |

---

## Endpoints del Backend (oficial)

### Públicos
| Método | Ruta | Handler |
|---|---|---|
| POST | `/api/login` | authHandler.Login |
| POST | `/api/auth/login` | authHandler.Login (alias) |
| POST | `/api/auth/refresh` | authHandler.Refresh |

### Protegidos (JWT)
| Método | Ruta | Handler |
|---|---|---|
| GET | `/api/productos/buscar` | productoHandler.BuscarProductos |
| GET | `/api/productos` | productoHandler.GetProductos |
| POST | `/api/productos` | productoHandler.CreateProducto |
| PUT | `/api/productos/{id:[0-9]+}` | productoHandler.UpdateProducto |
| DELETE | `/api/productos/{id:[0-9]+}` | productoHandler.DeleteProducto |
| POST | `/api/productos/{id:[0-9]+}/imagen` | productoHandler.UploadProductoImagen |
| DELETE | `/api/productos/{id:[0-9]+}/imagen` | productoHandler.DeleteProductoImagen |
| GET | `/api/inventario` | inventarioHandler.GetInventario |
| PATCH | `/api/inventario/{id:[0-9]+}` | inventarioHandler.PatchStock |
| POST | `/api/ventas` | ventaHandler.Create |
| GET | `/api/ventas` | ventaHandler.GetAll |
| GET | `/uploads/{path}` | Static file server |

---

## Rutas del Frontend (oficial)

| Path | Componente | Auth | Descripción |
|---|---|---|---|
| `/` | HomePage | No | Landing con auto-redirect a /servicios |
| `/login` | LoginPage | No | Login |
| `/servicios` | ServiciosPage | Sí | Menú post-login |
| `/contacto` | ContactoPage | No | Página vacía placeholder |
| `/productos` | ProductosPage | Sí | CRUD tabla + formulario |
| `/productos-registrados` | ProductosRegistrados | Sí | Galería con búsqueda/filtros |
| `/ventas` | VentasPage | Sí | POS con carrito |
| `/inventario` | InventarioPage | Sí | Buscar + actualizar stock |
| `/registro-ventas` | RegistroVentasPage | Sí | Historial de ventas |

---

## Esquema de Base de Datos (oficial)

```
usuarios (id, nombre, email, password_hash, rol, activo, fecha_creacion, fecha_actualizacion)
  │
  ├──< productos (id, nombre, codigo_barras, precio_compra, precio_venta, stock,
  │               imagen_url, descripcion, categoria, marca, fecha_ingreso,
  │               id_usuario → FK, activo)
  │
  ├──< registro_ventas (id_venta, id_producto → FK, precio_producto, cantidad,
  │                     fecha_venta, id_vendedor → FK)
  │
  └──< registro_sesiones (id, id_usuario → FK, inicio_sesion, cierre_sesion)
```

Vista: `inventario_view` — stock Normal (>=5), Bajo (1-4), Agotado (0).

---

## Comparativa de issues: oficial vs tempMiNegocio

| Issue | Oficial | tempMiNegocio |
|---|---|---|
| API_BASE hardcodeada en productosService | ❌ No aplica (no tiene config/api.js) | 🔴 AU-01 |
| go.mod vs Dockerfile mismatch | ✅ Coinciden (1.22) | 🔴 AU-02 |
| CORS `*` | 🟡 AO-07 | 🔴 AU-03 |
| Password texto plano | 🔴 AO-01 / AO-04 | 🔴 AU-04 |
| Sin guards de ruta | ✅ Tiene | 🟡 AU-05 |
| Sin archivos .env | 🟢 AO-15 | 🟡 AU-06 |
| Binario compilado en repo | ✅ Ignorado | 🟡 AU-07 |
| Dead code PatchStock | ✅ Registrado | 🟡 AU-08 |
| JWT_SECRET sin fallback | ✅ Tiene fallback | 🟡 AU-10 |
| Sin tests frontend | 🟡 AO-08 | 🟢 AU-11 |
| README desactualizado | ✅ Actualizado | 🟢 AU-13 |
| Login en texto plano (bcrypt) | 🔴 AO-03 | ❌ (no revisado en temp) |

---

## Recomendaciones

1. 🔴 **Hacer push de los commits pendientes**: backend (+10) y DB (+4) a Gitea
2. 🔴 **Migrar a bcrypt**: Login usa comparación texto plano (`password_hash = $2`)
3. 🔴 **Reemplazar JWT_SECRET default**: No usar fallback hardcodeado en producción
4. 🔴 **Generar hash bcrypt real** para `setup_produccion.sql`
5. 🟡 **Pipeline CI/CD para frontend**: Crear Jenkinsfile
6. 🟡 **Agregar tests frontend** y tests para ventas backend
7. 🟡 **Restringir CORS** en producción a orígenes específicos
8. 🟡 **Exponer claims del JWT** en handlers para control de acceso por rol
9. 🟢 **Limpiar HelloWorld.vue**, CSS duplicado, y código muerto
10. 🟢 **Crear .env.development/.env.production** con formato válido
11. 🟢 **Evaluar migrar diseño de tempMiNegocio** (CSS variables, NavBar, SideBar, Kanban, Dashboard) al oficial
