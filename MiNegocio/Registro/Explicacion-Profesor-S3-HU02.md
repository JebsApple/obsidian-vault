---
tags: [proyecto/minegocio, sprint-3, hu02, profesor]
fecha: 2026-07-02
tipo: explicacion-profesor
---

# Explicacion para el Profesor — S3-HU02 Rediseno Frontend

**Sprint:** 3 | **Historia de Usuario:** HU02 — Rediseno Frontend | **Responsable:** Victor Herrera

---

## 1. Resumen General

HU02 comprende el rediseno completo del frontend de MiNegocio. Se trabajo en 15 tareas (T01-T15) a lo largo del sprint, abarcando desde la navegacion y el tablero Kanban hasta la separacion en capas, animaciones, testing, validaciones, e integracion con IVA y proveedores.

Este documento cubre el trabajo mas reciente: **T08 (Animaciones)**, **T15 (IVA 19% + Campo Proveedor)**, la **migracion del Kanban a ubicaciones fisicas**, y las correcciones asociadas (fix productos fantasma, COALESCE, PATCH ubicacion).

---

## 2. T08 — Animaciones Sidebar (Frontend)

### Problema
La SideBar colapsable (T14) carecia de animaciones fluidas al abrir/cerrar. Los items de navegacion aparecian y desaparecian instantaneamente.

### Solucion
Se implementaron tres mejoras de animacion:

**a) Spring easing en la transicion de colapso**
- `cubic-bezier(0.34, 1.56, 0.64, 1)` para scaleX + opacity + blur
- La sidebar se expande horizontalmente con un efecto de resorte natural

**b) Stagger escalonado en entrada**
- Al abrir, cada item de navegacion aparece con un retardo incremental (0s, 0.04s, 0.08s, 0.12s, 0.16s, 0.24s)
- Animacion desde `translateY(-12px)` + `opacity(0)` -> posicion normal
- Crea un efecto de "ola" descendente

**c) Reverse stagger en salida**
- Al cerrar, los items salen en orden inverso (el ultimo item se desvanece primero)
- Delays: 0.24s -> 0.20s -> 0.16s -> 0.12s -> 0.08s -> 0.04s
- `@keyframes navItemOut` con `opacity(0)` + `translateY(8px)`
- Visualmente consistente: la entrada va de arriba a abajo, la salida de abajo a arriba

**d) Ripple CSS puro**
- Efecto de onda al hacer clic en nav-items usando `::after` pseudo-elemento con animacion `scale(4)` + `opacity(0)`

### Archivos modificados
- `src/components/SideBar.vue` — animaciones, stagger, ripple
- `src/styles/base.css` — clase `.ripple` y keyframes

---

## 3. T15 — IVA 19% + Campo Proveedor (Full-stack)

### Problema
El sistema no desglosaba el IVA en los productos, lo cual es obligatorio para la facturacion chilena (IVA 19%). Tampoco existia relacion con proveedores.

### Solucion

**Base de datos** (`esquema.sql`):
- Nueva tabla `proveedores` (id, rut, nombre, telefono, direccion, created_at)
- Columna `precio_sin_iva NUMERIC(12,2)` en `productos`
- Columna `id_proveedor INTEGER REFERENCES proveedores(id)` en `productos`
- Columna `ubicacion VARCHAR(40)` en `productos`
- Nueva tabla `ubicaciones` (id, nombre, created_at)
- Seed data: 6 proveedores de ejemplo + 2 ubicaciones por defecto (Bodega, Vitrina)

**Backend** (Go):
- `models/models.go`: Nuevos campos `PrecioSinIva`, `IdProveedor`, `Ubicacion` en `Producto`
- `handler/producto_handler.go`: Mapeo de los nuevos campos en Get/Create/Update
- `repository/producto_repository.go`: Columnas incluidas en consultas SQL
- `routes/routes.go`: Registro de rutas PATCH inventario + ubicaciones
- `handler/inventario_handler.go`: Nuevo handler `PatchInventario` con soporte para `*int` (stock) y `*string` (ubicacion)
- `repository/inventario_repository.go`: Update condicional segun campo recibido
- `service/inventario_service.go`: Logica de negocio para PATCH
- Endpoints nuevos: `GET /api/ubicaciones`, `POST /api/ubicaciones`, `DELETE /api/ubicaciones/:id`

**Frontend** (Vue.js):
- `FormularioProducto.vue`: Calculo automatico `precio_sin_iva = precio_venta / 1.19`. Selector de proveedor poblado desde `GET /api/proveedores`. Tooltip informativo "Precio sin IVA (calculado automaticamente)"
- `Productos.vue`: Columna "P. Sin IVA" en tabla con valor formateado
- `services/inventarioService.js`: Metodos `updateUbicacion`, `getUbicaciones`, `createUbicacion`, `deleteUbicacion`

### Calculo del IVA
```
Precio sin IVA = Precio de venta / 1.19
IVA = Precio de venta - Precio sin IVA
```
El calculo se realiza automaticamente al cargar/modificar un producto. No requiere entrada manual.

---

## 4. Migracion Kanban: Stock Status -> Ubicaciones Fisicas

### Problema
El KanbanBoard original clasificaba productos por estado de stock (Agotado/Bajo/Normal/Exceso), lo cual mostraba informacion redundante (el stock ya se ve en la tabla). El profesor solicito columnas por **ubicacion fisica** (Bodega, Vitrina, etc.).

### Solucion
- `KanbanBoard.vue`: Columnas dinamicas desde `props.ubicaciones`. Fallback "Sin clasificar" para productos sin ubicacion. Tres columnas por defecto: Bodega, Vitrina, Sin clasificar
- Drag & drop nativo (HTML5 API) entre columnas emite `product-moved`
- Boton "Agregar ubicacion" con rail lateral + input inline
- Boton "Eliminar ubicacion" (hover en header) con confirmacion
- Columna expandible (detalle vs compacto)
- `Inventario.vue`: Carga ubicaciones desde `GET /api/ubicaciones`, persiste movidas con PATCH

### Tests actualizados
- 6 tests en `KanbanBoard.test.js` usan `getProductosPorUbicacion` en vez de `getProductosPorStatus`
- Verifican: 3 columnas default, clasificacion correcta, toggle expand, emision de eventos, drag & drop entre columnas
- **54/54 tests pasando** en 10 suites

---

## 5. Correcciones Adicionales

### Fix productos fantasma (Backend)
**Problema:** La vista `inventario_view` en PostgreSQL mostraba productos que ya no existian en la tabla `productos` (registros huerfanos).
**Solucion:** Se agrego `INNER JOIN` con verificacion directa: `SELECT p.id, p.nombre, ... FROM productos p INNER JOIN inventario i ON p.id = i.id_producto` en vez de depender exclusivamente de la vista.

### Fix COALESCE (Backend)
**Problema:** Valores `NULL` en `precio_sin_iva` e `id_proveedor` causaban errores al serializar JSON en Go (campo `*float64` vs `float64`).
**Solucion:** Uso de `COALESCE(precio_sin_iva, 0)` y verificacion de `NULL` en el escaneo de filas.

### Fix PATCH ubicacion (Backend)
**Problema:** El handler `PatchInventario` original solo aceptaba `stock` como entero. No permitia actualizar `ubicacion`.
**Solucion:** El payload ahora acepta `{"stock": 5}`, `{"ubicacion": "Vitrina"}`, o ambos. Uso de `*int` y `*string` para detectar que campos se enviaron.

---

## 6. Commits y Control de Versiones

### Frontend (rama `S3-HU02`, 5 commits -> Gitea)
| Commit | Descripcion |
|--------|-------------|
| 1 | `S3-HU02-T08: animacion close sidebar reverse stagger` |
| 2 | `S3-HU02-T02: migrar kanban a columnas por ubicacion fisica` |
| 3 | `S3-HU02-T02: adaptar tests kanban a columnas por ubicacion` |
| 4 | `S3-HU02-T15: IVA 19% + campo proveedor en formulario producto` |
| 5 | `S3-HU02: fixes inventario ventas y estilos` |

### Backend (rama `S3-HU02-T15-iva-proveedores`, 2 commits -> Gitea)
| Commit | Descripcion |
|--------|-------------|
| 1 | `S3-HU02-T15: IVA 19% + campo id_proveedor en models/handler/routes` |
| 2 | `S3-HU02: endpoints ubicaciones CRUD + fix COALESCE + fix fantasmas + PATCH int/string` |

### Base de datos (rama `S3-HU02-T15-iva-proveedores`, 1 commit -> Gitea)
| Commit | Descripcion |
|--------|-------------|
| 1 | `S3-HU02-T15: tabla proveedores + tabla ubicaciones + columnas IVA + seed data` |

---

## 7. Estado General HU02

| Tarea | Nombre | Estado |
|-------|--------|--------|
| T01 | Navegacion (NavBar + SideBar) | En Gitea |
| T02 | Tablero Kanban Inventario | En Gitea **(migrado a ubicaciones)** |
| T03 | Dashboard Principal | En Gitea |
| T04 | Testing Frontend (Vitest, 54 tests) | En Gitea |
| T05 | Validaciones + AppModal | En Gitea |
| T06 | Separacion Capas Frontend | En Gitea |
| T07 | Separacion Capas Backend | En Gitea |
| T08 | Animaciones + Consistencia Visual | En Gitea |
| T09 | Nomenclatura Vistas (Espanol) | En Gitea |
| T10 | Limpieza CSS Duplicado | En Gitea |
| T11 | Iconos para Assets | En Gitea |
| T12 | Codigo Barras + Acceso Roles | En Gitea |
| T13 | Fusion Vistas + Recorte Imagen | En Gitea |
| T14 | Sidebar Colapsable + Pestanas Archivador + Fix POS | En Gitea |
| T15 | IVA 19% + Campo Proveedor | En Gitea |

---

## 8. Enlaces Gitea

- Frontend: `http://192.168.50.28:3000/VHerrera/MiNegocio-frontend/src/branch/S3-HU02`
- Backend: `http://192.168.50.28:3000/VHerrera/MiNegocio-backend/src/branch/S3-HU02-T15-iva-proveedores`
- Database: `http://192.168.50.28:3000/VHerrera/MiNegocio-database/src/branch/S3-HU02-T15-iva-proveedores`
