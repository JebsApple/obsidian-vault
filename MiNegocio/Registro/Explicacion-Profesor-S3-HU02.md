---
tags: [proyecto/minegocio, sprint-3, hu02, profesor]
fecha: 2026-07-02
tipo: explicacion-profesor
---

# Explicacion para el Profesor — S3-HU02 Rediseno Frontend

**Sprint:** 3 | **Historia de Usuario:** HU02 — Rediseno Frontend | **Responsable:** Victor Herrera

---

## 1. Resumen General

HU02 comprende el rediseno completo del frontend de MiNegocio, incluyendo tareas de backend y base de datos cuando fue necesario. Se trabajo en 15 tareas (T01 a T15) que abarcan:

- **T01-T03**: Navegacion, Kanban, Dashboard
- **T04-T05**: Testing y validaciones
- **T06-T07**: Separacion de capas frontend y backend
- **T08-T11**: Animaciones, nomenclatura, CSS, iconos
- **T12-T13**: Codigo barras, roles, fusion vistas, recorte imagen
- **T14-T15**: Sidebar colapsable, pestanas archivador, IVA, proveedores

**3 repositorios involucrados:** frontend (Vue 3), backend (Go), base de datos (PostgreSQL)
**Servidor Gitea:** http://192.168.50.28:3000/VHerrera/

---

## 2. T01 — Navegacion (NavBar + SideBar)

### Problema
El frontend carecia de un sistema de navegacion estructurado. La barra lateral y la barra superior no estaban integradas con el sistema de autenticacion JWT, y el diseno no era responsive.

### Solucion
- **NavBar**: Barra superior horizontal con logo, enlaces de navegacion y dropdown de usuario. Visible solo en estado publico (sin autenticacion).
- **SideBar**: Navegacion lateral vertical de 256px con logo SVG "MiNegocio", grupos de enlaces (Dashboard con submenu, Punto de Venta, Inventario, Productos, Usuarios solo para admin, Sesiones como placeholder), seccion inferior con avatar de iniciales, nombre de usuario, boton de cerrar sesion y toggle de colapso.
- **LogoSVG**: Componente SVG reutilizable del logo (kiosko).
- **Auth integrado**: JWT como unica fuente de verdad. `getUserFromToken()` extrae nombre y rol del token. SideBar oculta "Usuarios" si `rol !== 'admin'`.
- **Responsive**: SideBar oculta en pantallas <768px. Breakpoint auto-expande al superar 60% del ancho.
- **Proxy `/uploads/`**: Configurado en nginx para servir imagenes de productos.

### Archivos clave
- `src/components/SideBar.vue` — navegacion lateral, estados colapsado/expandido
- `src/components/NavBar.vue` — barra superior publica
- `src/components/LogoSVG.vue` — logo SVG
- `src/App.vue` — layout condicional (NavBar sin auth / SideBar con auth)

---

## 3. T02 — Tablero Kanban de Inventario

### Problema
El inventario se mostraba solo como tabla. No habia forma visual de gestionar el estado de los productos ni moverlos entre categorias.

### Solucion (primera version)
- **KanbanBoard.vue**: Componente con 4 columnas de estado de stock (Agotado, Bajo, Normal, Exceso).
- **Drag & drop**: Nativo HTML5. Arrastrar tarjeta entre columnas actualiza el stock via `PATCH /api/inventario/{id}`.
- **Columna expandible**: Click en pill expande/contrae detalles de tarjeta (stock, precio, codigo, ID).
- **Busqueda**: `BuscadorProductos` con debounce sobre `/api/productos/buscar`.
- **Editor inline de stock**: Input numerico + boton guardar en vista de tabla.
- **Badges de color**: Rojo para agotado, amarillo para stock bajo.

### Migracion posterior (T02 extendida, julio)
- Columnas cambiadas de estado de stock a **ubicacion fisica** (Bodega, Vitrina, Sin clasificar) por solicitud del profesor.
- Ubicaciones cargadas desde `GET /api/ubicaciones`. Columna "Sin clasificar" como fallback para productos sin ubicacion.
- CRUD de ubicaciones: agregar/eliminar columnas desde el tablero.
- Backend: endpoints `GET/POST/DELETE /api/ubicaciones`, PATCH con soporte para `*int` (stock) y `*string` (ubicacion).

### Archivos clave
- `src/components/KanbanBoard.vue` — tablero Kanban
- `src/views/Inventario.vue` — vista padre, logica de negocio
- `src/services/inventarioService.js` — API calls
- `handler/inventario_handler.go`, `repository/inventario_repository.go`, `service/inventario_service.go`

---

## 4. T03 — Dashboard Principal (AnalisePage)

### Problema
No existia un dashboard central con indicadores clave del negocio.

### Solucion
- **AnalisePage.vue**: Vista unificada que funciona como Landing (publico, sin auth) y Dashboard (autenticado).
- **4 KPIs**: Total productos, Ventas del dia, Stock bajo, Agotados — consultados via `/api/productos` y `/api/ventas`.
- **Ultimas 5 ventas**: Lista con producto, cantidad, fecha.
- **Accesos rapidos**: Botones a las secciones principales (Ventas, Inventario, Productos).
- **Badge de ganancia**: En `FormularioProducto`, verde si `precio_venta > precio_compra`, rojo si no.
- **Sin librerias externas**: KPIs calculados con JavaScript nativo, CSS Grid para layout.

### Archivos clave
- `src/views/AnalisePage.vue` — dashboard/landing unificado
- `src/components/FormularioProducto.vue` — badge de ganancia

---

## 5. T04 — Testing Frontend (Vitest)

### Problema
No existian pruebas automatizadas en el frontend. Los cambios se validaban solo con build y prueba manual.

### Solucion
- **Vitest 2.1.9** + `@vue/test-utils` + `happy-dom`. Configurado via `vitest.config.js`.
- **10 suites de test, 54 tests en total**:

| Suite | Tests | Que cubre |
|-------|-------|-----------|
| authService | 8 | login, logout, token, expiracion |
| productosService | 8 | CRUD, busqueda |
| ventasService | 4 | creacion venta, listado |
| inventarioService | 5 | getAll, updateStock, updateUbicacion, ubicaciones |
| KanbanBoard | 6 | columnas ubicacion, clasificacion, drag & drop, expand |
| Login | 3 | renderizado, validacion |
| AnalisePage | 4 | landing vs dashboard, KPIs |
| SideBar | 5 | render, roles, navegacion |
| authGuard | 7 | control de acceso por ruta |
| AdminUsuariosPage | 4 | placeholder, contenido |

- Tests ejecutados con `npx vitest run`. Resultado: **54/54 tests pasando**.

### Archivos clave
- `src/__tests__/*.test.js` — 10 archivos de test
- `vitest.config.js` — configuracion Vitest

---

## 6. T05 — Validaciones + Mensajes de Error Globales

### Problema
El frontend usaba `alert()` y `confirm()` nativos del navegador para errores y confirmaciones. No habia validacion consistente en formularios.

### Solucion
- **AppModal**: Componente modal global inyectado via `provide/inject`. Soporta:
  - `$modal.alert(mensaje)` — modal informativo
  - `$modal.confirm(mensaje)` — modal de confirmacion (si/no)
  - Slots personalizados (header, body, footer)
- **Integracion**: Reemplazo de `alert()`/`confirm()` en CarritoCompras, ProductosPage, ProductosRegistrados, Inventario, Ventas.
- **Validaciones en formularios**:
  - `FormularioProducto`: nombre requerido, precio > 0, stock >= 0, codigo barras opcional
  - `LoginPage`: email/username requerido, password requerido, spinner durante submit
  - Mensajes de error en espanol

### Archivos clave
- `src/components/AppModal.vue` — modal global
- `src/main.js` — provide del modal

---

## 7. T06 — Separacion de Capas Frontend

### Problema
Las vistas hacian `fetch()` directo a la API, mezclaban logica de negocio con presentacion, y los estilos CSS estaban desorganizados.

### Solucion
**Arquitectura CSS jerarquica:**
- `src/styles/variables.css`: Tokens de diseno (colores `--color-brand: #d60000`, radios, sombras, tipografia `Space Grotesk`)
- `src/styles/base.css`: Estilos compartidos (`.btn-primary`, `.btn-secondary`, `.table-card`, `.form-card`, `.badge`, `.stock-badge`, `.upload-area`, inputs, cards)
- `src/styles/productos.css`: Estilos especificos de pagina de productos
- `src/styles/componentes.css`: Estilos de componentes reutilizables
- Import desde `main.js` para disponibilidad global

**Servicios dedicados:**
- `src/services/inventarioService.js`: getAll, updateStock, buscarProductos, updateUbicacion, CRUD ubicaciones
- `src/services/productosService.js`: getProductos, createProducto, updateProducto, deleteProducto
- `src/services/ventasService.js`: getVentas, createVenta
- `src/services/authService.js`: login, logout, getToken, isTokenExpired, getUserFromToken

**Codigo eliminado:**
- `middleware/authGuard.js` (redundante con el guard de router)
- `plugins/axios.js` (nunca se uso)
- `components/HelloWorld.vue` (template por defecto de Vue CLI)

### Archivos clave
- `src/styles/variables.css`, `src/styles/base.css`
- `src/services/*.js`
- `src/main.js`

---

## 8. T07 — Separacion de Capas Backend

### Problema
El backend Go tenia logica mezclada: handlers accedian directamente a repository, hacian I/O de archivos, y no habia interfaces claras entre capas.

### Solucion
- **BuscarParams** movido a `models/models.go` (antes estaba disperso en handlers)
- **Interfaces completadas**: `InventarioServiceI`, `InventarioRepositoryI`, `VentaRepositoryI` en `service/interfaces.go`
- **I/O de archivos** movido de handler a service (ej: manejo de imagenes)
- **Auth middleware**: Claims del JWT (user_id, nombre, rol) inyectados en `context.Context` — los handlers los extraen via `r.Context().Value()`
- **Handlers limpios**: Ya no importan `repository/`, reciben interfaces no tipos concretos

### Verificacion
- `go build ./...`, `go vet ./...`, `go test ./...` exitosos

### Archivos clave
- `models/models.go` — BuscarParams, structs completos
- `service/interfaces.go` — interfaces de cada capa
- `middleware/auth_middleware.go` — claims en context
- `handler/*.go` — handlers sin acceso directo a repository

---

## 9. T08 — Animaciones y Consistencia Visual

### Problema
La SideBar colapsable (T14) tenia transiciones instantaneas. Los items de navegacion no tenian feedback visual al hacer clic.

### Solucion

**Spring easing en colapso:**
- `cubic-bezier(0.34, 1.56, 0.64, 1)` para scaleX + opacity + blur de la barra
- Expansion con efecto de resorte natural

**Stagger escalonado en entrada:**
- 6 items de navegacion con delays: 0s, 0.04s, 0.08s, 0.12s, 0.16s, 0.24s
- Animacion `translateY(-12px)` + `opacity(0)` -> posicion normal
- Efecto de "ola" descendente

**Reverse stagger en salida:**
- Items salen en orden inverso (ultimo primero)
- Delays: 0.24s -> 0.20s -> 0.16s -> 0.12s -> 0.08s -> 0.04s
- `@keyframes navItemOut` con `opacity(0)` + `translateY(8px)`

**Ripple CSS puro:**
- Efecto de onda en nav-items via pseudo-elemento `::after`
- Animacion `scale(4)` + `opacity(0)` en 0.6s

**Colores hardcodeados reemplazados**: `#b0b0b0` -> `--color-meta`, `#fff5f5` -> `--color-brand-subtle`, `#ddd` -> `--color-border-input`, `#999` -> `--color-text-muted`

### Archivos clave
- `src/components/SideBar.vue` — animaciones, stagger, ripple
- `src/styles/base.css` — keyframes ripple, navItemOut
- `src/styles/variables.css` — tokens de color

---

## 10. T09 — Nomenclatura de Vistas (Espanol)

### Problema
Las vistas usaban nombres mixtos ingles/espanol con sufijo `Page` (ej: `AnalisePage.vue`, `LoginPage.vue`), inconsistente con el estandar del proyecto.

### Solucion
- Vistas renombradas sin sufijo `Page`:
  - `AnalisePage.vue` -> `Analise.vue`
  - `LoginPage.vue` -> `Login.vue`
  - `ProductosPage.vue` -> `Productos.vue`
  - `InventarioPage.vue` -> `Inventario.vue`
  - `VentasPage.vue` -> `Ventas.vue`
  - `ServiciosPage.vue` -> `Servicios.vue`
  - `RegistroVentasPage.vue` -> `RegistroVentas.vue`
  - `GaleriaProductos.vue` -> `Galeria.vue`
  - `ContactoPage.vue` -> `Contacto.vue`
- Rutas actualizadas en `src/router/index.js`
- Regla ESLint `multi-word` desactivada para vistas de 1 palabra
- Todos los imports y referencias actualizados

### Archivos clave
- `src/views/*.vue` — vistas renombradas
- `src/router/index.js` — rutas actualizadas

---

## 11. T10 — Limpieza de CSS Duplicado

### Problema
Reglas CSS duplicadas entre componentes: estilos de badges, botones y tablas repetidos en `GaleriaProductos`, `ProductosRegistrados`, `CarritoCompras`.

### Solucion
- Reglas de badges (`.badge-low`, `.badge-out-of-stock`) movidas de `GaleriaProductos.vue` a `base.css`
- Estilos de tablas unificados en `base.css` (usados por `Inventario`, `Productos`, `RegistroVentas`)
- Estilos inline de `CarritoCompras.vue` migrados a clases globales
- Revision de `productos.css` y `componentes.css` para eliminar solapamientos con `base.css`

### Archivos clave
- `src/styles/base.css` — reglas consolidadas
- `src/views/Galeria.vue` — badges removidos
- `src/views/CarritoCompras.vue` — estilos inline migrados

---

## 12. T11 — Iconos para Assets

### Problema
La interfaz carecia de iconos. Los botones de accion (editar, eliminar, agregar) usaban solo texto.

### Solucion
- Integracion de **Tabler Icons** via CDN (`@tabler/icons-webfont`)
- Iconos en acciones principales: editar (`ti ti-edit`), eliminar (`ti ti-trash`), agregar (`ti ti-plus`)
- SideBar: iconos junto a cada link de navegacion
- NavBar: iconos en enlaces del menu
- KanbanBoard: icono de eliminacion de columna, boton de agregar
- Sin SVG locales — todos via webfont de Tabler Icons (sin dependencia adicional)

### Archivos clave
- `src/components/SideBar.vue` — iconos en navegacion
- `src/components/NavBar.vue` — iconos en menu
- `src/components/KanbanBoard.vue` — iconos de accion

---

## 13. T12 — Codigo de Barras + Acceso por Roles

### Problema
El escaner de codigo de barras en Ventas no filtraba correctamente y el stock no se refrescaba tras una venta. El control de acceso por rol no estaba implementado.

### Solucion
- **Escaner de codigo barras**: Filtro de inventario por codigo en `Inventario.vue`. Autofoco en input de scanner al cargar la vista.
- **Refresco de stock**: Tras crear una venta, el stock se recarga desde `GET /api/productos` para reflejar cambios inmediatamente.
- **Control de acceso por rol**: La ruta `/admin/usuarios` requiere `rol === 'admin'` ademas de autenticacion. SideBar oculta enlace "Usuarios" para no-admins.
- **Seed de usuarios DEV**: Admin (admin/1234) y vendedor (user/1234) en base de datos.

### Archivos clave
- `src/views/Ventas.vue` — escaner + refresco post-venta
- `src/views/Inventario.vue` — filtro por codigo
- `src/router/index.js` — guard con verificacion de rol
- `src/components/SideBar.vue` — `v-if="esAdmin"` en enlace Usuarios

---

## 14. T13 — Fusion de Vistas + Recorte de Imagen (Cropperjs)

### Problema
Habia dos vistas de productos separadas (galeria y registrados) con logica duplicada. No existia recorte de imagen al subir fotos de productos.

### Solucion
- **Fusion de vistas**: `GaleriaProductos.vue` y `ProductosRegistrados.vue` unificadas en una sola vista `Productos.vue` con pestanas (Galeria / Registrados).
- **Cropperjs**: Libreria `cropperjs` integrada en `FormularioProducto.vue`. Al seleccionar una imagen, se abre un modal de recorte con relacion de aspecto 1:1.
- **Acordeon en Dashboard**: `AnalisePage.vue` con secciones expandibles/colapsables para organizar KPIs y graficos.
- **Jenkinsfile**: Pipeline de CI/CD configurado para build y deploy automatico.

### Archivos clave
- `src/views/Productos.vue` — vista unificada
- `src/components/FormularioProducto.vue` — cropperjs integrado
- `src/views/AnalisePage.vue` — acordeon en dashboard
- `Jenkinsfile` — pipeline CI/CD

---

## 15. T14 — Sidebar Colapsable + Pestanas Archivador + Fix POS

### Problema
La SideBar era fija (no colapsable), los switches de vista (Tablero/Stock, Galeria/Registrados) usaban diseno simple tipo "pill", y el POS (Punto de Venta) tenia bugs con el `id_vendedor`.

### Solucion
**Sidebar colapsable siempre disponible:**
- Boton de colapso siempre visible (antes solo en pantallas <60% ancho)
- Al colapsar: solo queda logo + chevron-down para reexpandir
- Transicion suave con spring easing

**Pestanas tipo archivador:**
- Switches redisenados con curva concava invertida en la union (tecnica `mask: radial-gradient`)
- Estilos unificados en `src/styles/productos.css` como fuente unica
- Accesibilidad: `role="tablist"`/`role="tab"`/`role="tabpanel"`, `aria-selected`, `aria-controls`
- Micro-animaciones: rotacion elastica en flecha de colapso, scale en hover de iconos

**Fix POS:**
- `id_vendedor` extraido del JWT en lugar de estar hardcodeado
- Ventas se registran con el usuario autenticado

### Archivos clave
- `src/components/SideBar.vue` — colapso siempre activo, transiciones
- `src/styles/productos.css` — estilos archivador unificados
- `src/components/CarritoCompras.vue` — fix id_vendedor del JWT

---

## 16. T15 — IVA 19% + Campo Proveedor (Full-stack)

### Problema
El sistema no desglosaba el IVA en los productos (obligatorio para facturacion chilena, IVA 19%). No existia relacion con proveedores.

### Solucion

**Base de datos** (`esquema.sql`):
- Tabla `proveedores` (id, rut, nombre, telefono, direccion, created_at)
- Columna `precio_sin_iva NUMERIC(12,2)` en `productos`
- Columna `id_proveedor INTEGER REFERENCES proveedores(id)` en `productos`
- Columna `ubicacion VARCHAR(40)` en `productos`
- Tabla `ubicaciones` (id, nombre, created_at)
- Seed: 6 proveedores (Distribuidora Alimenticia, Carnes del Sur, etc.) + 2 ubicaciones (Bodega, Vitrina)

**Backend** (Go):
- `models/models.go`: `PrecioSinIva *float64`, `IdProveedor *int`, `Ubicacion *string` en `Producto`
- `handler/producto_handler.go`: Mapeo de nuevos campos
- `repository/producto_repository.go`: Columnas en SELECT/INSERT/UPDATE
- `routes/routes.go`: Rutas PATCH inventario + endpoints ubicaciones
- `handler/inventario_handler.go`: `PatchInventario` con soporte `*int` (stock) y `*string` (ubicacion)
- `repository/inventario_repository.go`: UPDATE condicional
- `service/inventario_service.go`: Logica de negocio
- Endpoints: `GET/POST/DELETE /api/ubicaciones`

**Frontend** (Vue.js):
- `FormularioProducto.vue`: Calculo `precio_sin_iva = precio_venta / 1.19`. Selector de proveedor. Tooltip informativo.
- `Productos.vue`: Columna "P. Sin IVA" en tabla
- `inventarioService.js`: metodos `updateUbicacion`, `getUbicaciones`, `createUbicacion`, `deleteUbicacion`

**Calculo del IVA:**
```
Precio sin IVA = Precio de venta / 1.19
IVA = Precio de venta - Precio sin IVA
```
Calculo automatico al cargar/modificar producto. Sin entrada manual.

### Archivos clave
- `esquema.sql` — tablas proveedores, ubicaciones, columnas
- `models/models.go` — campos en struct Producto
- `handler/*.go`, `repository/*.go`, `service/*.go` — logica backend
- `src/components/FormularioProducto.vue` — UI IVA + proveedor
- `src/views/Productos.vue` — columna Precio Sin IVA
- `src/services/inventarioService.js` — API calls

---

## 17. Correcciones Adicionales (BugFixes)

### Fix productos fantasma
**Problema:** La vista `inventario_view` en PostgreSQL mostraba registros huerfanos (productos eliminados de `productos` pero con entrada en `inventario`).
**Solucion:** Consulta directa con `INNER JOIN` entre `productos p` e `inventario i ON p.id = i.id_producto` en vez de depender de la vista.

### Fix COALESCE
**Problema:** Valores `NULL` en `precio_sin_iva` e `id_proveedor` causaban errores de serializacion JSON.
**Solucion:** `COALESCE(precio_sin_iva, 0)` y verificacion de `NULL` en escaneo de filas Go.

### Fix PATCH ubicacion
**Problema:** `PatchInventario` original solo aceptaba `stock` como entero. No permitia actualizar `ubicacion`.
**Solucion:** Payload acepta `{"stock": 5}`, `{"ubicacion": "Vitrina"}`, o ambos. Uso de punteros (`*int`, `*string`) para detectar campos enviados.

### Fix escaneo codigo barras
**Problema:** Input de scanner no tenia autofoco al cargar Ventas. Filtro no funcionaba correctamente con codigos escaneados.
**Solucion:** Autofoco via `ref` + `$nextTick`. Filtro por `codigo_barras` y `nombre` en `itemsFiltrados`.

### Fix POS id_vendedor
**Problema:** `id_vendedor` hardcodeado en CarritoCompras.
**Solucion:** Extraccion desde JWT via `getUserFromToken()`.

---

## 18. Commits y Control de Versiones

### Frontend (rama `S3-HU02`, 5 commits -> Gitea)
| # | Commit | Descripcion |
|---|--------|-------------|
| 1 | `S3-HU02-T08: animacion close sidebar reverse stagger` | Animaciones T08 |
| 2 | `S3-HU02-T02: migrar kanban a columnas por ubicacion fisica` | Kanban migrado |
| 3 | `S3-HU02-T02: adaptar tests kanban a columnas por ubicacion` | Tests actualizados |
| 4 | `S3-HU02-T15: IVA 19% + campo proveedor en formulario producto` | IVA + proveedor |
| 5 | `S3-HU02: fixes inventario ventas y estilos` | Bugfixes + CSS |

### Backend (rama `S3-HU02-T15-iva-proveedores`, 2 commits -> Gitea)
| # | Commit | Descripcion |
|---|--------|-------------|
| 1 | `S3-HU02-T15: IVA 19% + campo id_proveedor en models/handler/routes` | Modelos + producto handler |
| 2 | `S3-HU02: endpoints ubicaciones CRUD + fix COALESCE + fix fantasmas + PATCH int/string` | Ubicaciones + fixes |

### Base de datos (rama `S3-HU02-T15-iva-proveedores`, 1 commit -> Gitea)
| # | Commit | Descripcion |
|---|--------|-------------|
| 1 | `S3-HU02-T15: tabla proveedores + tabla ubicaciones + columnas IVA + seed data` | Esquema completo |

---

## 19. Testing y Verificacion

### Resultados
| Prueba | Resultado |
|--------|-----------|
| `go build ./...` | ✅ OK |
| `go vet ./...` | ✅ OK |
| `go test ./...` | ✅ OK (config, handler, middleware, service) |
| `npm run build` | ✅ OK (app.js + app.css compilados) |
| `npx vitest run` | **54/54 tests** en 10 suites |
| Deploy dev :8080 | ✅ HTTP 200, bundle verificado |

### Auditoria de seguridad
- Endpoints detras de `AuthMiddleware`
- Input validado (nombre 1-40 chars, stock >= 0, ubicacion no vacia)
- SQL 100% parametrizado
- DELETE de ubicacion protege fallback "Sin clasificar" y reubica productos en transaccion
- Sin secretos ni credenciales en codigo
- Sin `v-html` nuevo (XSS prevenido por Vue)

---

## 20. Estado General HU02

| Tarea | Nombre | Estado | Repo |
|-------|--------|--------|------|
| T01 | Navegacion (NavBar + SideBar) | Gitea | Frontend |
| T02 | Tablero Kanban Inventario | Gitea | Frontend + Backend |
| T03 | Dashboard Principal (AnalisePage) | Gitea | Frontend |
| T04 | Testing Frontend (Vitest) | Gitea | Frontend |
| T05 | Validaciones + AppModal | Gitea | Frontend |
| T06 | Separacion Capas Frontend | Gitea | Frontend |
| T07 | Separacion Capas Backend | Gitea | Backend |
| T08 | Animaciones + Consistencia Visual | Gitea | Frontend |
| T09 | Nomenclatura Vistas (Espanol) | Gitea | Frontend |
| T10 | Limpieza CSS Duplicado | Gitea | Frontend |
| T11 | Iconos para Assets | Gitea | Frontend |
| T12 | Codigo Barras + Acceso Roles | Gitea | Frontend |
| T13 | Fusion Vistas + Recorte Imagen | Gitea | Frontend |
| T14 | Sidebar Colapsable + Pestanas Archivador + Fix POS | Gitea | Frontend |
| T15 | IVA 19% + Campo Proveedor | Gitea | Full-stack |

---

## 21. Enlaces Gitea

- **Frontend (rama S3-HU02):** http://192.168.50.28:3000/VHerrera/MiNegocio-frontend/src/branch/S3-HU02
- **Backend (rama S3-HU02-T15-iva-proveedores):** http://192.168.50.28:3000/VHerrera/MiNegocio-backend/src/branch/S3-HU02-T15-iva-proveedores
- **Database (rama S3-HU02-T15-iva-proveedores):** http://192.168.50.28:3000/VHerrera/MiNegocio-database/src/branch/S3-HU02-T15-iva-proveedores
- **Entorno dev:** http://192.168.50.25:8080
