---
tags: [proyecto/minegocio, taiga, sprint-3, hu02, sync]
---

# S3-HU02 -- Registro Taiga

## Tareas nuevas a crear en Taiga

### S3-HU02-T06: Separacion de capas frontend

**Tipo:** Mejora / Refactor
**Prioridad:** Alta
**Estimacion:** 4h

**Descripcion:**
Refactorizar la arquitectura CSS y de servicios del frontend para cumplir con la separacion de capas solicitada por el profesor:

- CSS jerarquico: crear `src/styles/variables.css` con tokens de diseno (colores, radios, sombras) y `src/styles/base.css` con estilos de componentes compartidos (botones, cards, tablas, badges, formularios, upload, ganancia-badge, paginacion). Refactorizar `productos.css` para que solo contenga estilos pagina-especificos.
- Importar `base.css` desde `main.js` para que este disponible globalmente.
- Servicios: crear `src/services/inventarioService.js` (getAll, updateStock, buscarProductos). Agregar `deleteProducto()` a `productosService.js`.
- Migrar vistas de `fetch()` directo a servicios: LoginPage (usa `authService.login`), InventarioPage (usa `inventarioService`), VentasPage (usa `productosService`), RegistroVentasPage (usa `ventasService`), ProductosPage (usa `productosService`), ProductosRegistrados (usa `productosService.deleteProducto`).
- Reemplazar colores hardcodeados por `var(--color-*)` en `App.vue` y vistas.
- Eliminar codigo muerto: `middleware/authGuard.js`, `plugins/axios.js`, `HelloWorld.vue`.

**Criterios de aceptacion:**
- [ ] `views/` no contiene `fetch()` directo (todo via `services/`)
- [ ] `main.js` importa `base.css`
- [ ] `variables.css` define `--color-brand`, `--color-brand-hover`, `--color-text-*`, etc.
- [ ] `base.css` incluye `.btn-primary`, `.table-card`, `.form-card`, `.badge`, `.stock-badge`, etc.
- [ ] Build pasa sin errores
- [ ] No hay colores hardcodeados `#d60000`, `#b30000`, etc.

**Archivos:**
- `src/styles/variables.css` (nuevo)
- `src/styles/base.css` (nuevo)
- `src/styles/productos.css` (modificado)
- `src/main.js` (modificado)
- `src/services/inventarioService.js` (nuevo)
- `src/services/productosService.js` (modificado)
- `src/App.vue` (modificado)
- `src/views/LoginPage.vue` (modificado)
- `src/views/InventarioPage.vue` (modificado)
- `src/views/VentasPage.vue` (modificado)
- `src/views/RegistroVentasPage.vue` (modificado)
- `src/views/ProductosPage.vue` (modificado)
- `src/views/ProductosRegistrados.vue` (modificado)
- `src/middleware/authGuard.js` (eliminado)
- `src/plugins/axios.js` (eliminado)
- `src/components/HelloWorld.vue` (eliminado)

**Rama Gitea:** `S3-HU02-T06-capas-frontend`


### S3-HU02-T07: Separacion de capas backend

**Tipo:** Mejora / Refactor
**Prioridad:** Alta
**Estimacion:** 4h

**Descripcion:**
Refactorizar la arquitectura del backend Go para cumplir con la separacion de capas solicitada por el profesor (handler/service/repository/models con interfaces):

- Mover `BuscarParams` de `repository/producto_repository.go` a `models/models.go` (el handler no debe importar repository).
- Completar interfaces: crear `InventarioServiceI` en `handler/interfaces.go`, `InventarioRepositoryI` en `service/interfaces.go`. Completar `VentaRepositoryI`.
- DI consistente: cambiar `InventarioHandler`, `VentaHandler` y `InventarioService`, `VentaService` para que usen interfaces en vez de structs concretos.
- Mover I/O de archivos (`os.MkdirAll`, `os.WriteFile`, `os.Remove`) de `handler/producto_handler.go` a `service/producto_service.go`. Agregar `UploadImagen` y `DeleteImagen` al service.
- Auth middleware: inyectar claims del JWT en `r.Context()` (nuevo archivo `middleware/context.go` con context keys).
- Upload middleware: reemplazar side channel via `r.MultipartForm.Value` por comunicacion via `context.Context`.
- main.go: leer `UPLOAD_DIR` de variable de entorno, pasar a `NewProductoService`.

**Criterios de aceptacion:**
- [ ] `handler/` no importa `repository/`
- [ ] `handler/` no hace I/O de archivos
- [ ] Todos los handlers usan interfaces (no structs concretos)
- [ ] Todos los servicios usan interfaces de repositorio (no structs concretos)
- [ ] `go build ./...` pasa
- [ ] `go vet ./...` pasa
- [ ] `go test ./...` pasa
- [ ] JWT claims accesibles via `ClaimsFromContext(ctx)`
- [ ] Upload middleware se comunica via `context.Context`

**Archivos:**
- `models/models.go` (modificado)
- `repository/producto_repository.go` (modificado)
- `handler/interfaces.go` (modificado)
- `service/interfaces.go` (modificado)
- `handler/inventario_handler.go` (modificado)
- `handler/venta_handler.go` (modificado)
- `service/inventario_service.go` (modificado)
- `service/venta_service.go` (modificado)
- `service/producto_service.go` (modificado)
- `handler/producto_handler.go` (modificado)
- `middleware/auth_middleware.go` (modificado)
- `middleware/context.go` (nuevo)
- `middleware/upload.go` (modificado)
- `main.go` (modificado)
- `handler/producto_handler_test.go` (modificado)
- `service/producto_service_test.go` (modificado)

**Rama Gitea:** `S3-HU02-T07-capas-backend`


## Comentarios para Taiga por tarea

### S3-HU02-T01 -- NavBar y SideBar

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Se recuperaron los componentes NavBar, SideBar y LogoSVG del rediseno anterior (STL-redesign). 
> 
> **Commits en rama `S3-HU02-T01-navegacion-barra-lateral`:**
> 1. `estilos base (variables, reset, botones, cards, layout)` -- 4 archivos, 675 lineas
> 2. `componente LogoSVG con icono kiosko` -- LogoSVG.vue, 79 lineas
> 3. `componente NavBar con logo y menu de usuario` -- NavBar.vue, 247 lineas
> 4. `componente SideBar colapsable con avatar iniciales` -- SideBar.vue, 431 lineas
> 5. `layout App.vue con auth guard, router y config api` -- App.vue + router + main.js + api.js
> 6. `authService con getUserFromToken (JWT como unica fuente)` -- authService.js
> 7. `LoginPage redisenado con card, spinner y branding` -- LoginPage.vue, 223 lineas
> 8. `config dev (favicon, proxy uploads, placeholder AdminUsuarios)` -- config + placeholder
> 9. `fix: reemplazar emoji por texto en AdminUsuariosPage` -- [ Pendiente ] sin emoji
> 
> **Pruebas realizadas:**
> - Build: `npm run build` exitoso
> - LoginPage: formulario con validacion de campos, spinner en boton, pantalla completa centrada
> - SideBar: colapsable (se ocilla/muestra), avatar con iniciales del usuario
> - NavBar: sincronizada con estado de autenticacion, boton cerrar sesion funcional
> - Auth guard: rutas protegidas redirigen a /login si no hay token
> - Auth guard: redireccion a /servicios si hay token (no se queda en login)
> - Responsive: SideBar se oculta en <768px
> - Proxy uploads: imagenes de productos cargadas desde /uploads/
> 
> **Pendiente:** Revisar con companeros si AdminUsuariosPage necesita mas funcionalidad (placeholder actual)


### S3-HU02-T02 -- KanbanBoard de Inventario

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Se recupero el componente KanbanBoard del rediseno anterior. Tablero drag & drop con 4 columnas de estado de stock. Panel de busqueda y agregado de productos en InventarioPage.
> 
> **Commits en rama `S3-HU02-T02-tablero-kanban`:**
> 1. `componente KanbanBoard con 4 columnas de estado de stock` -- KanbanBoard.vue, 340 lineas
> 2. `panel drag & drop en InventarioPage con editor inline de stock` -- InventarioPage.vue, 472 lineas
> 3. `fix: reemplazar simbolos por texto en botones inline edit` -- OK/X en vez de Unicode check/cross
> 
> **Columnas del Kanban:**
> - Agotado: stock = 0
> - Bajo: stock 1-4
> - Normal: stock 5-20
> - Exceso: stock > 20
> 
> **Pruebas realizadas:**
> - Build: `npm run build` exitoso
> - DnD: arrastrar tarjeta entre columnas llama PATCH /api/inventario/{id} para actualizar stock
> - Busqueda: input con debounce busca productos por nombre via /api/productos/buscar
> - Resultados de busqueda se muestran con stock actual y campo para ingresar nuevo stock
> - Boton Agregar: envia PATCH con nuevo stock y recarga la tabla
> - Tabla de inventario: muestra ID, nombre, stock con badge de color, estado
> 
> **Dependencia backend:** Requiere endpoint `PATCH /api/inventario/{id}` (implementado en feat/S3-HU02 del backend)


### S3-HU02-T03 -- Dashboard principal

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Se rediseno la pagina AnalisePage con KPIs, dashboard y landing. Se limpiaron estilos inline de VentasPage y se agrego badge de ganancia estimada en FormularioProducto.
> 
> **Commits en rama `S3-HU02-T03-panel-principal`:**
> 1. `pagina AnalisePage con KPIs, dashboard y landing` -- AnalisePage.vue, 478 lineas
> 2. `VentasPage elimina inline styles, usa CSS con hover nativo` -- VentasPage.vue
> 3. `badge ganancia estimada (verde/perdida rojo) en FormularioProducto` -- FormularioProducto.vue
> 4. `fix: reemplazar emojis por simbolos de texto en dashboard y landing` -- iconos [~] [#] [$] [^]
> 
> **KPIs del dashboard:**
> - Total productos (icono [~], tarjeta roja)
> - Ventas del dia (icono [#], verde)
> - Stock bajo <=4 (icono [$], amarillo)
> - Agotados = 0 (icono [^], rojo)
> - Cada card con valor numerico grande y label descriptivo
> 
> **Secciones de la landing (sin login):**
> - Hero con titulo MiNegocio + subtitulo
> - 3 features: Gestion de productos, Ventas agiles, Dashboard
> - Enlaces rapidos: Productos, Ventas, Inventario
> 
> **VentasPage:**
> - Buscador de productos inline
> - Cards de resultados con hover nativo (borde rojo)
> - Carrito de compras integrado
> 
> **FormularioProducto:**
> - Badge "Ganancia estimada por unidad: $X" en verde si precio_venta > precio_compra, rojo si no
> 
> **Pruebas realizadas:**
> - Build: `npm run build` exitoso
> - Dashboard carga KPIs desde API /api/productos y /api/ventas
> - VentasPage busqueda funcional
> - Ganancia badge se actualiza al escribir precios
> - Diseño responsive


### S3-HU02-T04 -- Testing frontend

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Se configuro Vitest y se crearon 5 suites de test para los componentes del frontend.
> 
> **Commits en rama `S3-HU02-T04-pruebas`:**
> 1. `configuracion Vitest (package.json, vitest.config, package-lock)` -- 2989 lineas
> 2. `test authGuard (rutas protegidas, login redirect)` -- authGuard.test.js, 50 lineas
> 3. `test SideBar (expansion, colapso, iniciales)` -- SideBar.test.js, 48 lineas
> 4. `test LoginPage (submit, validaciones, token)` -- LoginPage.test.js, 60 lineas
> 5. `test AnalisePage (KPIs, graficos, landing)` -- AnalisePage.test.js, 53 lineas
> 6. `test AdminUsuariosPage (placeholder pendiente)` -- AdminUsuariosPage.test.js, 25 lineas
> 
> **Suites de test:**
> | Suite | Archivo | Lineas |
> |-------|---------|--------|
> | authGuard | `authGuard.test.js` | 50 |
> | SideBar | `SideBar.test.js` | 48 |
> | LoginPage | `LoginPage.test.js` | 60 |
> | AnalisePage | `AnalisePage.test.js` | 53 |
> | AdminUsuariosPage | `AdminUsuariosPage.test.js` | 25 |
> 
> **Pruebas realizadas:**
> - `npx vitest run` -- 23/23 tests pasan
> - authGuard: ruta protegida redirige a /login sin token, permite acceso con token
> - SideBar: renderiza enlaces, se expande/colapsa, muestra iniciales del usuario
> - LoginPage: renderiza formulario, boton submit llama a login, muestra error con credenciales invalidas
> - AnalisePage: renderiza KPIs, graficos y landing
> - AdminUsuariosPage: renderiza placeholder con mensaje pendiente
> - Sin dependencias externas de test (solo vitest + @vue/test-utils)
> 
> **Nota:** Los tests dependen de componentes de T01 (SideBar, LoginPage, router). Ejecutar sobre main fallara hasta que T01 este mergeado.


### S3-HU02-T05 -- Validaciones + mensajes de error globales

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Se creo el componente AppModal global para reemplazar alert() y confirm() nativos del navegador. Se integraron validaciones en los formularios.
> 
> **Commits en rama `S3-HU02-T05-validaciones`:**
> 1. `componente AppModal global con slots para header/body/footer` -- AppModal.vue, 161 lineas
> 2. `integracion provide/inject de AppModal en App.vue` -- App.vue + vue.config.js
> 3. `migrar CarritoCompras a AppModal (confirmaciones con modal)` -- CarritoCompras.vue
> 4. `migrar ProductosPage a AppModal (alert/confirm reemplazados)` -- ProductosPage.vue
> 5. `migrar ProductosRegistrados a AppModal (confirmaciones)` -- ProductosRegistrados.vue
> 
> **AppModal:**
> - Slots personalizados: header (titulo), body (contenido), footer (botones)
> - Metodos expuestos via provide/inject: `showModal(config)` con titulo, mensaje, botones
> - Soporte para boton de confirmacion (verde) y cancelacion (gris)
> - Backdrop click para cerrar, animacion de entrada/salida
> - Reemplaza alert() y confirm() en: CarritoCompras, ProductosPage, ProductosRegistrados
> 
> **Validaciones:**
> - FormularioProducto: campos requeridos marcados, codigo de barras con estilo destacado
> - LoginPage: campos requeridos antes de submit
> - Errores de API capturados con try/catch y mostrados en pantalla
> - Mensajes en espanol y especificos
> 
> **Pruebas realizadas:**
> - Build: `npm run build` exitoso
> - Modal se muestra/oculta correctamente
> - Confirmacion de eliminacion de producto usa modal en vez de confirm()
> - CarritoCompras usa modal para confirmar venta


### S3-HU02-T06 -- Separacion de capas frontend (NUEVA en Taiga)

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Refactor completa de la arquitectura CSS y de servicios del frontend para separar en capas segun requerimiento del profesor.
> 
> **Commits en rama `S3-HU02-T06-capas-frontend`:**
> 1 commit unico con 16 archivos modificados (521 inserciones, 514 eliminaciones)
> 
> **Arquitectura CSS implementada:**
> - `variables.css` (nuevo): 43 CSS custom properties para tokens de diseno
>   - `--color-brand: #d60000`, `--color-brand-hover: #b30000`
>   - `--color-text-primary`, `--color-text-tertiary`, `--color-text-muted`, `--color-text-light`
>   - `--color-success`, `--color-warning`, `--color-danger` y sus fondos
>   - `--color-border`, `--color-border-input`, `--color-border-row`
>   - `--radius-sm/md/lg/xl/full`, `--shadow-card/sm`
>   - `--font-sans`, `--font-mono`, `--transition-fast/normal`
> - `base.css` (nuevo): importa variables.css, define ~250 lineas de estilos compartidos
>   - `.btn-primary`, `.btn-secondary`, `.btn-icon`, `.btn-danger`
>   - `.form-card`, `.form-grid`, `.field`, `input[type=text/number]`
>   - `.table-card`, `.table-header`, `table`, `thead`, `tbody`, `td`
>   - `.badge`, `.estado-tabla`, `.stock-badge`, `.stock-bajo`, `.stock-agotado`
>   - `.upload-area`, `.upload-placeholder`, `.preview-img`, `.ganancia-badge`
>   - `.paginacion`, `.btn-pag`, `.pag-info`
>   - `.msg-error`, `.error-msg`, `.msg-exito`, `.success-msg`
> - `productos.css`: reducido a comentario (estilos ahora en base.css)
> - `main.js`: importa `./styles/base.css` globalmente
> - Css variables aplicadas en `App.vue` (topbar, nav-links, login-btn, content)
> 
> **Servicios:**
> - `inventarioService.js` (nuevo): `getAll()`, `updateStock(id, stock)`, `buscarProductos(query)`
> - `productosService.js`: agregado `deleteProducto(id)`
> 
> **Vistas migradas de fetch() directo a servicios:**
> | Vista | Antes | Ahora |
> |-------|-------|-------|
> | LoginPage | fetch(/api/auth/login) | authService.login() |
> | InventarioPage | 3 fetch() directos | inventarioService.getAll/updateStock/buscarProductos |
> | VentasPage | fetch(/api/productos/buscar) | productosService.buscarProductos({q, limit}) |
> | RegistroVentasPage | fetch(/api/ventas) | ventasService.getVentas() |
> | ProductosPage | 2 fetch() directos | productosService.getProductos/deleteProducto |
> | ProductosRegistrados | fetch(/api/productos/{id} DELETE) | productosService.deleteProducto(id) |
> 
> **Codigo eliminado:**
> - `middleware/authGuard.js` (no usado, el router tiene su propio guard)
> - `plugins/axios.js` (no importado por ningun componente)
> - `components/HelloWorld.vue` (template default de Vue CLI)
> 
> **Pruebas realizadas:**
> - `npm run build` exitoso (antes corrigio error eslint: variable data no usada en LoginPage)
> - LoginPage: login funcional con authService
> - InventarioPage: carga, busca y actualiza stock via inventarioService
> - VentasPage: busca productos via productosService
> - RegistroVentasPage: carga ventas via ventasService
> - ProductosPage: carga y elimina productos via productosService
> - ProductosRegistrados: elimina productos via productosService.deleteProducto
> - App.vue usa CSS variables, fallback a valores hardcodeados si no estan definidas


### S3-HU02-T07 -- Separacion de capas backend (NUEVA en Taiga)

**Comentario de trabajo realizado (27/06/2026):**

> ## Trabajo realizado
> 
> Refactor completa de la arquitectura backend Go para cumplir con separacion de capas (handler/service/repository/models con interfaces). 17 archivos modificados (168 inserciones, 93 eliminaciones).
> 
> **Commits en rama `S3-HU02-T07-capas-backend`:**
> 1 commit unico con 17 archivos modificados
> 
> **Cambios detallados:**
> 
> 1. **BuscarParams movido a models/models.go**
>    - Antes: definido en repository/producto_repository.go, usado por handler/producto_handler.go (el handler importaba repository)
>    - Ahora: models/models.go contiene BuscarParams, handler usa models.BuscarParams
> 
> 2. **Interfaces completadas y DI consistente**
>    - `handler/interfaces.go`: agregada `InventarioServiceI` (GetAll, UpdateStock), agregados UploadImagen/DeleteImagen a ProductoServiceI
>    - `service/interfaces.go`: agregada `InventarioRepositoryI` (GetAll, UpdateStock), completada VentaRepositoryI (BeginTx, GetStockForUpdate, InsertVentaItem, DecreaseStock)
>    - `handler/inventario_handler.go`: ahora usa `InventarioServiceI` en vez de `*service.InventarioService`
>    - `handler/venta_handler.go`: ahora usa `VentaServiceI` en vez de `*service.VentaService`
>    - `service/inventario_service.go`: ahora usa `InventarioRepositoryI` en vez de `*repository.InventarioRepository`
>    - `service/venta_service.go`: ahora usa `VentaRepositoryI` + `ProductoRepositoryI` en vez de structs concretos
> 
> 3. **Filesystem I/O movido de handler a service**
>    - Antes: handler/producto_handler.go hacia os.MkdirAll, os.WriteFile, os.Remove
>    - Ahora: service/producto_service.go tiene UploadImagen (mkdir+write+DB) y DeleteImagen (os.Remove)
>    - handler llama a service en vez de hacer I/O directo
> 
> 4. **Auth middleware inyecta claims en context**
>    - `middleware/context.go` (nuevo): context key types + helpers ClaimsFromContext, SetClaimsOnContext, ValidatedImageFromContext, SetValidatedImageOnContext
>    - `middleware/auth_middleware.go`: despues de validar JWT, guarda claims en r.Context()
> 
> 5. **Upload middleware usa context**
>    - Antes: middleware guardaba datos validados en r.MultipartForm.Value["_validatedMIME"] y ["_validatedBytes"]
>    - Ahora: usa SetValidatedImageOnContext / ValidatedImageFromContext via context.Context
> 
> 6. **main.go actualizado**
>    - Lee UPLOAD_DIR de variable de entorno (default ./uploads/productos)
>    - Pasa uploadDir a NewProductoService
> 
> 7. **Tests actualizados**
>    - handler/producto_handler_test.go: mock actualizado con models.BuscarParams, UploadImagen, DeleteImagen
>    - service/producto_service_test.go: NewProductoService actualizado con uploadDir parameter
> 
> **Pruebas realizadas:**
> - `go build ./...` exitoso
> - `go vet ./...` exitoso
> - `go test ./...` exitoso (todos los tests pasan)
> - handler/producto_handler.go ya no importa repository/
> - handler/producto_handler.go ya no hace I/O de archivos
> - Todos los handlers y servicios usan interfaces
> - JWT claims accesibles via ClaimsFromContext(ctx)
> - Upload middleware se comunica via context.Context


### S3-HU02-T13 -- Fusión de vistas Productos + recorte de imagen

**Comentario de trabajo realizado (28/06/2026):**

> ## Trabajo realizado
>
> Se fusionaron las vistas `Productos` y `ProductosRegistrados` en una sola página `/productos`. Se agregó recorte de imagen con cropperjs al subir imágenes de productos. Se actualizó la SideBar con acordeón Dashboard y enlace único a Productos. Se creó Jenkinsfile para deploys seguros. Se prepararon usuarios de producción en seed_prod.sql.
>
> **Commits en rama `S3-HU02-T13-fusion-vistas-recorte-imagen` (frontend):**
> 1. `instalar cropperjs para recorte de imagen` — package.json + package-lock
> 2. `agregar modal de recorte con cropper en FormularioProducto` — crop modal con aspectRatio 1:1, canvas 800px, output JPEG
> 3. `fusionar vistas Productos y ProductosRegistrados en una sola pagina` — Productos.vue reescrito, router redirect, GaleriaProductos aspect-ratio, ProductosRegistrados eliminado
> 4. `acordeon Dashboard con WIP en SideBar y enlace unico a Productos` — Dashboard expandible con Estadísticas/Reportes deshabilitados, Productos como link directo
> 5. `crear Jenkinsfile con guardia de rama main para deploys seguros` — build + test + deploy condicional por rama
> 6. `actualizar README y tests con credenciales correctas de DB` — administrador + usuario (1234) para DEV
>
> **Commits en rama `S3-HU02-T13-fusion-vistas-recorte-imagen` (database):**
> 1. `agregar seed_prod.sql con usuarios de produccion` — Victor, Ignacio (admin) y Nicolas, Gabriel (usuario)
>
> **Productos.vue (página única fusionada):**
> - BuscadorProductos en la parte superior
> - Botón "+ Agregar Producto" → formulario en modal overlay
> - Tabla "Productos Registrados" colapsable (inicia cerrada)
> - GaleriaProductos con paginación (12 por página)
> - Botones de editar/eliminar en tabla y galería
>
> **Recorte de imagen (cropperjs):**
> - Modal overlay al seleccionar imagen
> - Cropper con aspectRatio 1:1, viewMode 2 (caja no excede canvas)
> - Canvas de salida 800px máx, JPEG calidad 0.9
> - GaleriaProductos: imagen con `aspect-ratio: 1/1` + `object-fit: cover`
>
> **SideBar actualizada:**
> - Dashboard ahora es acordeón: Resumen (link activo) + Estadísticas (WIP) + Reportes (WIP)
> - Productos es enlace único (sin submenú)
>
> **Jenkinsfile:**
> - `main` → tests + build + deploy a `/var/www/prod/frontend/`
> - Otras ramas → tests + build + deploy a `/var/www/dev/frontend/`
>
> **Usuarios de producción (seed_prod.sql):**
> | Usuario | Email | Contraseña | Rol |
> |---------|-------|------------|-----|
> | Victor | VictorAdmin@minegocio.cl | Admin226 | admin |
> | Ignacio | IgnacioAdmin@minegocio.cl | Admin226 | admin |
> | Nicolas | NicolasVendedor@minegocio.cl | User224 | usuario |
> | Gabriel | GabrielLogistica@minegocio.cl | User224 | usuario |
>
> **Pruebas realizadas:**
> - `npx vitest run` — 53/53 tests pasan
> - `npm run build` — build de producción exitoso
> - Login con administrador + usuario funciona (ambos por nombre o email)
> - FormularioProducto: recorte de imagen funcional (crop → preview → upload)
> - GaleriaProductos: imágenes con aspect-ratio flexible
> - SideBar: acordeón Dashboard expandible/colapsable, enlace Productos funcional
> - Router: `/productos-registrados` redirige a `/productos`
> - Modal overlay de formulario se abre/cierra correctamente
> - Seed dev.sql aplicado a cliente_dev (usuarios limpios, legacy eliminados)
>
> **Actualización DB (30/06):** esquema.sql refactorizado con tablas usuarios, productos, registro_ventas, índices y vistas. Seed dev.sql con usuarios administrador/usuario (1234). Migraciones en `/migrations/`. Scripts viejos de sprint2 eliminados.
> **Push a Gitea:** Rama `S3-HU02-T13-fusion-vistas-recorte-imagen` actualizada con 4 commits nuevos (limpieza + esquema + seed + fix POS).

### S3-HU02-T14 -- Sidebar colapsable + pestañas archivador + fix POS

**Comentario de trabajo realizado (30/06/2026):**

> ## Trabajo realizado
>
> Rama: `S3-HU02-T14-sidebar-colapsable-pestanas-archivador` (creada desde `S3-HU02`). Fusión de las anteriores T14 (nombre en inglés) y T15 (mismo alcance). Pusheada a Gitea el 30/06.
>
> **Commits (5 commits renombrados de T15 a T14):**
> 1. `S3-HU02-T14: pestañas estilo archivador en Productos/Inventario y sidebar colapsable siempre disponible` — estructura inicial ArchivadorTab + Sidebar colapsable en todo breakpoint
> 2. `S3-HU02-T14: mejorar sidebar con transiciones suaves, animacion cortina y mancha radial en icono activo` — easing cubic-bezier, keyframes cortinaAbrir/cortinaCerrar, icono activo con radial-gradient rojo + background-clip:text
> 3. `S3-HU02-T14: redisenar pestanas archivador modelo por capas con rojo deslizante` — barra gris continua + rojo deslizante ::before que navega 50% con translateX + curvita cóncava ::after + panel z-index superior
> 4. `S3-HU02-T14: migrar vistas inventario y productos a clases sel-inicio/sel-fin para pestanas capas` — clases de posición para el deslizamiento
> 5. `S3-HU02-T14: eliminar id_vendedor hardcodeado del body, backend lo toma del JWT` — fix POS
>
> **Pestañas archivador (3 iteraciones):**
> - Iteración 1: estructura ArchivadorTab con curva cóncava via mask radial
> - Iteración 2: curva invertida, 50/50, relleno rojo en activa, mancha radial icono
> - Iteración 3 (definitiva): modelo por capas — barra gris de fondo + rojo deslizante ::before (50% width, translateX) + curvita cóncava ::after que voltea + panel z-index 3
>
> **Sidebar colapsable siempre disponible:**
> - `puedeColapsar = true` siempre (antes solo <60% ancho)
> - Animación cortina: altura + opacidad + translateY con ease-out-expo
> - Transiciones de .sidebar y .main-content alineadas con cubic-bezier(0.16,1,0.3,1)
>
> **Fix POS (Punto de Venta):**
> - Causa raíz: `id_vendedor: 1` hardcodeado en CarritoCompras.vue, usuario real es ID 5
> - Solución: backend extrae `UserID` del JWT via `middleware.ClaimsFromContext(r)` y sobreescribe `req.IDVendedor`. El body del request es ignorado para este campo.
> - Frontend: eliminado `id_vendedor: 1` del payload
> - Docker: fix `DB_HOST=172.17.0.1` (host.docker.internal no resuelve en Linux)
> - Tests realizados: ventas sin id_vendedor → OK (usa JWT user_id=5). Ventas con id_vendedor=999 → OK (ignorado, usa JWT).
>
> **Pruebas realizadas:**
> - `npm run build` — build producción exitoso (app.cbb8dec0.js / app.24150eaa.css)
> - Deploy a dev: rsync a /var/www/dev/frontend/ → HTTP 200
> - CSS desplegado contiene: vt-active, flex:1 1 0, background-clip:text, cortinaAbrir
> - `go build ./...` + `go vet ./...` — exitoso
> - Ventas API: POST /api/ventas con y sin id_vendedor → OK, ventas registradas con id_vendedor correcto
> - Login administrador (ID 5): genera token JWT con user_id=5
