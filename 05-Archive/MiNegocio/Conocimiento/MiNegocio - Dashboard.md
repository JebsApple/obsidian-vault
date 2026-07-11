---
tags: [proyecto/MiNegocio, estado/reestructuracion]
---

# MiNegocio.cl — Dashboard del Proyecto

## Stack Tecnológico

| Capa        | Tecnología                                           |
| ----------- | ---------------------------------------------------- |
| Frontend    | Vue 3 (Options API) + Vue Router 5                   |
| Backend     | Go 1.22 + gorilla/mux + lib/pq + golang-jwt + bcrypt |
| DB          | PostgreSQL 16                                        |
| Drag & Drop | HTML5 Native DnD API                                 |

## Estructura

```
/home/apuru/minegocio/
├── proyecto/minegocio-frontend/   # Vue 3 SPA
├── proyecto/minegocio-backend/    # Go API REST
└── proyecto/minegocio-database/   # Scripts SQL
```

## Rutas Frontend

| Ruta | Vista | Descripción |
|------|-------|-------------|
| `/` | AnalisePage | Dashboard / Landing |
| `/login` | LoginPage | Autenticación JWT |
| `/analisis` | AnalisePage | Dashboard análisis |
| `/inventario` | InventarioPage | Kanban + drag & drop productos |
| `/productos` | ProductosPage | Formulario + tabla CRUD |
| `/productos/registrar` | ProductosPage | Formulario de registro |
| `/productos/ver` | ProductosRegistrados | Galería con búsqueda |
| `/ventas` | VentasPage | Punto de venta con carrito |
| `/servicios` | ServiciosPage | Menú principal |
| `/contacto` | ContactoPage | (placeholder) |

## Endpoints API

- `POST /api/login` — Login (JWT)
- `GET /api/productos` — Listar
- `GET /api/productos/buscar` — Búsqueda paginada
- `POST /api/productos` — Crear
- `PUT /api/productos/{id}` — Actualizar
- `DELETE /api/productos/{id}` — Soft delete
- `POST /api/productos/{id}/imagen` — Subir imagen
- `DELETE /api/productos/{id}/imagen` — Eliminar imagen
- `GET /api/inventario` — Vista inventario
- `POST /api/ventas` — Registrar venta
- `GET /api/ventas` — Listar ventas
- `POST /api/sesiones/inicio` — Registrar inicio sesión
- `POST /api/sesiones/cierre` — Registrar cierre sesión

## Ramas Propuestas

```
main           ← estable
dev            ← integración
feat/ventas    ← handler ventas + sesiones
feat/frontend-ventas ← página de ventas + carrito
feat/inventario-dnd  ← inventario con drag & drop
feat/bcrypt    ← migración a bcrypt
fix/imagenes   ← reparación visual
```
