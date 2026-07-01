---
tags: [proyecto/minegocio, sprint-3, historia-usuario, gabriel, backend, frontend, database]
---

# S3-HU05: CRUD de Proveedores

**Asignado:** Gabriel
**Dependencias:** Ninguna
**Bloquea:** S3-HU01-T06 (id_vendedor dinámico — parcial), S3-HU04 (Control de roles)

> **UX:** 1 | **Design:** 1 | **Front:** 4 | **Back:** 5 | **DB:** 1 | **Total:** 12

---

## Descripción

Como usuario del sistema, quiero gestionar proveedores y asignarlos a productos al registrarlos, para tener trazabilidad de quién provee cada producto del inventario.

## Criterios de aceptación

1. El usuario puede crear, ver, editar y desactivar proveedores desde una página dedicada.
2. Cada proveedor tiene: nombre, RUT, email, teléfono, dirección.
3. Al registrar un producto, se puede seleccionar un proveedor desde un `<select>`.
4. El producto guardado muestra el nombre del proveedor asociado.
5. Eliminar un proveedor no elimina sus productos (FK con `ON DELETE SET NULL`).

---

## Tareas

### S3-HU05-T01: Base de datos — tabla `proveedores` + FK en `productos` `[database]` `[1 punto]`

| Archivo | Acción |
|---------|--------|
| `postgres/esquema.sql` | Crear tabla `proveedores` (id, nombre, rut, email, telefono, direccion, activo) |
| `postgres/esquema.sql` | Agregar `id_proveedor` FK a `productos` |



### S3-HU05-T02: Backend — CRUD Proveedores `[backend]` `[5 puntos]`

| Archivo | Acción |
|---------|--------|
| `models/models.go` | Agregar structs `Proveedor` + `CreateProveedorRequest` |
| `repository/proveedor_repository.go` | **Crear** — CRUD completo |
| `service/proveedor_service.go` | **Crear** — pass-through |
| `service/interfaces.go` | Agregar `ProveedorRepositoryI` |
| `handler/proveedor_handler.go` | **Crear** — 5 handlers HTTP |
| `handler/interfaces.go` | Agregar `ProveedorServiceI` |
| `routes/routes.go` | 5 rutas REST |
| `main.go` | Wiring repo → service → handler → routes |



### S3-HU05-T03: Frontend — Página de gestión de proveedores `[frontend]` `[3 puntos]`

| Archivo | Acción |
|---------|--------|
| `services/proveedorService.js` | **Crear** — getAll, getByID, crear, actualizar, eliminar |
| `views/ProveedoresPage.vue` | **Crear** — tabla + modal/form |
| `router/index.js` | Ruta `/proveedores` |
| `components/SideBar.vue` | Link "Proveedores" en navegación |



### S3-HU05-T04: Frontend — Selector de proveedor en FormularioProducto `[frontend]` `[2 puntos]`

| Archivo | Acción |
|---------|--------|
| `components/FormularioProducto.vue` | Agregar `<select>` de proveedores, enviar `id_proveedor` |
| `views/ProductosPage.vue` | Mostrar nombre del proveedor en tabla |
| `services/productosService.js` | Sin cambios (el campo `id_proveedor` viaja en el JSON existente) |



### S3-HU05-T05: Pruebas `[test]` `[1 punto]`

| Archivo | Acción |
|---------|--------|
| `repository/proveedor_repository_test.go` | **Crear** — test CRUD |
| `handler/proveedor_handler_test.go` | **Crear** — test endpoints |
| Frontend | Probar que el selector carga y envía correctamente |

---

## Endpoints API

| Método | Ruta | Auth | Handler |
|--------|------|------|---------|
| GET | `/api/proveedores` | JWT | proveedor_handler.GetProveedores |
| GET | `/api/proveedores/{id:[0-9]+}` | JWT | proveedor_handler.GetProveedor |
| POST | `/api/proveedores` | JWT | proveedor_handler.CreateProveedor |
| PUT | `/api/proveedores/{id:[0-9]+}` | JWT | proveedor_handler.UpdateProveedor |
| DELETE | `/api/proveedores/{id:[0-9]+}` | JWT | proveedor_handler.DeleteProveedor |

---

## Referencias

- Patrón backend: `repository/producto_repository.go`, `service/producto_service.go`, `handler/producto_handler.go`
- Patrón frontend: `services/productosService.js`, `views/ProductosPage.vue`
- UI del form: `components/FormularioProducto.vue`
- Documentación detallada: [[S3-HU05-instrucciones-gabriel]]
