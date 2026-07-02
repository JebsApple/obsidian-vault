---
tags: [proyecto/minegocio, sprint-3, sesion, frontend, backend, database]
updated: 2026-07-02
---

# Sesión 2026-07-02: T08 Animaciones + T15 IVA/Proveedores + Fix Productos Fantasma

Ejecución del plan [[S3-HU02-T08-T15-Plan-IVA-Proveedores-Animaciones]]. Todo implementado, compilado y desplegado a dev. **Sin cambios en Gitea** (sin push, sin commits — comandos documentados abajo para ejecutar cuando Victor decida).

## Estado de repos al cierre

| Repo | Rama | Estado |
|------|------|--------|
| Frontend | `S3-HU02` (existente) | Working tree modificado, sin commit |
| Backend | `S3-HU02-T15-iva-proveedores` (nueva, local) | Working tree modificado, sin commit |
| Database | `S3-HU02-T15-iva-proveedores` (nueva, local) | Working tree modificado, sin commit |

Nota: `Ventas.vue` ya estaba modificado antes de esta sesión (cambio previo sin commit) — no se tocó.

---

## Tarea A: S3-HU02-T08 — Animaciones (frontend)

**Archivos:** `SideBar.vue`, `styles/variables.css`, `styles/base.css`

1. **Tokens nuevos** (`variables.css`): `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)`, `--ripple-color: var(--color-brand)`, `--ripple-duration: 0.6s`.
2. **Sidebar colapso con spring**: `transition: width 0.5s var(--ease-spring)`. El contenido reemplaza la cortina (max-height, anti-patrón) por `scaleX(0.6) + translateY + opacity + blur(2px)` con transform-origin left top.
3. **Stagger al abrir**: los hijos directos de `.sidebar-nav` entran con `navItemIn` (translateX -12px → 0) y delays incrementales de 0.04s (hasta 0.24s; `.sidebar-bottom` cierra a 0.28s).
4. **Ripple rojo CSS puro** (`base.css`): clase `.ripple` + aplicación automática a `.btn-primary` y `.btn-icon` (sin tocar markup de vistas). `::after` circular centrado con `translate(-50%,-50%) scale(0→4)` + fade, 0.6s ease-out, disparado con `:active`. `pointer-events: none` — no bloquea clicks. En SideBar se agregó la clase a los 4 nav-items y al trigger de Dashboard.
5. **Mancha radial animada**: el gradiente del icono activo ya no es estático — anima `background-size 0% → 100%` (keyframe `manchaExpandir`, 0.45s) expandiéndose desde el centro del glyph al activarse.
6. **Micro-movimientos**: iconos con `transform: translateY(-1px) scale(1.1)` en hover, transición 0.2s con ease spring.

## Tarea B: S3-HU02-T15 — IVA 19% + Campo Proveedor

**DB** (`esquema.sql`, rama local nueva):
- Tabla mínima `proveedores` (id, nombre, activo) para sostener la FK — Gabriel la extiende en S3-HU05.
- `ALTER TABLE productos ADD COLUMN IF NOT EXISTS precio_sin_iva INTEGER DEFAULT 0`.
- `ALTER TABLE productos ADD COLUMN IF NOT EXISTS id_proveedor INTEGER REFERENCES proveedores(id) ON DELETE SET NULL`.
- Backfill: `precio_sin_iva = precio_venta * 100 / 119` para filas existentes.
- **Pendiente aplicar a la DB dev** (no se tocó la base, según lo acordado).

**Backend** (rama local nueva `S3-HU02-T15-iva-proveedores`):
- `models.go`: `PrecioSinIVA int` + `IDProveedor *int` en `Producto` y `CreateProductoRequest`.
- `producto_repository.go`: las 5 queries (GetByID, Create, Update, GetAllActive, BuscarProductos) incluyen ambas columnas.
- `producto_handler.go`: helper `completarPrecioSinIVA()` — si el cliente no envía `precio_sin_iva`, se calcula `precio_venta * 100 / 119` en Create y Update. Constante `porcentajeIVA = 19`.

**Frontend**:
- `FormularioProducto.vue`: desglose IVA en tiempo real bajo Precio venta (métodos `sinIVA()` = round(venta/1.19) y `ivaValor()`), select Proveedor (vacío, "Sin proveedor") tras Marca, campo `id_proveedor` en form/mounted/procesarEscaneo, y payload de guardado envía `precio_sin_iva` calculado + `id_proveedor` como número o null.
- `Productos.vue`: columna "P. Sin IVA" tras "P. Venta" en tabla Registrados (muestra `—` si aún no hay dato).
- `productos.css`: estilos `.iva-desglose/.iva-valor/.iva-sub` con tokens de marca + estilo de `select` alineado a inputs.

## Tarea C (agregada por Victor): Fix productos fantasma Inventario/Stock

**Causa raíz encontrada (2 focos):**

1. **Scan silencioso en Go** (`producto_repository.go`): `GetAllActive` y `BuscarProductos` escaneaban `codigo_barras/imagen_url/descripcion/categoria/marca` **sin COALESCE** y con `if err == nil { append }` — cualquier producto con NULL en esas columnas fallaba el Scan y **desaparecía en silencio** de `/api/productos` (Registrados), pero sí aparecía en `/api/inventario` (que solo lee id/nombre/stock). Esos eran los fantasmas.
2. **Dependencia de `inventario_view`**: la definición de la vista vive en la DB; si quedó una versión vieja (sin filtro activo o creada sobre otra tabla), inventario mostraba filas desalineadas de productos.

**Fix aplicado:**
- Backend: COALESCE en todas las columnas anulables + los errores de Scan ahora se propagan (no se descartan filas). `inventario_repository.go` consulta `productos` directamente (estado calculado con CASE en SQL, mismos umbrales) — ya no depende de la vista.
- Frontend (`Inventario.vue`): los productos registrados (`getProductos()`) son la única fuente de verdad — la lista de inventario se construye desde ellos; entradas de `/api/inventario` sin producto registrado se descartan; nombre/stock vienen siempre del producto. Helper `estadoDesdeStock()` con los mismos umbrales de la vista (>=5 Normal, 1-4 Bajo, 0 Agotado). Esto unifica ambas pantallas **incluso con el backend viejo desplegado**.
- DB: `inventario_view` recreada con `WHERE activo = true` en esquema.sql (consistencia mientras exista).

## Pruebas realizadas

- [x] `go build ./...` + `go vet ./...` — OK
- [x] `npm run build` — OK (app.7b6a5aca.js / app.414741e1.css)
- [x] Deploy a dev: `/var/www/dev/frontend/` → HTTP 200 en :8080
- [x] Bundle desplegado verificado: contiene `ripple-effect`, `manchaExpandir`, `contenidoAbrir`, `navItemIn`, `iva-desglose`, `estadoDesdeStock`, `precio_sin_iva`, "Sin proveedor"
- [x] IVA: 1190 → neto 1000, IVA 190 (validado por fórmula, front y back alineados)

**Verificación visual pendiente de Victor en http://192.168.50.25:8080** (login y revisar: colapso sidebar con rebote, stagger, ripple en botones/nav, desglose IVA en formulario, columna P. Sin IVA, inventario sin fantasmas — ojo: el fix backend de fantasmas requiere rebuild del contenedor para verse en dev; el fix frontend ya unifica las listas).

## Qué falta para que T15 funcione end-to-end en dev

1. Aplicar los ALTER de `esquema.sql` a la DB dev (tabla proveedores + columnas).
2. Rebuild de la imagen `minegocio-backend:dev` con la rama T15.
3. Sin eso: el desglose IVA visual funciona, pero `precio_sin_iva`/`id_proveedor` no se persisten (el backend actual ignora los campos extra del JSON) y la columna P. Sin IVA muestra `—`.

## Commits preparados (NO ejecutados)

```bash
# Frontend (rama S3-HU02) — Commit 1: T08 animaciones
cd /home/icin/minegocio-frontend
git add src/components/SideBar.vue src/styles/base.css src/styles/variables.css
git commit -m "S3-HU02-T08: mejorar animacion sidebar con spring + stagger + ripple en iconos y botones"

# Frontend — Commit 2: T15 IVA + proveedores
git add src/components/FormularioProducto.vue src/views/Productos.vue src/styles/productos.css
git commit -m "S3-HU02-T15: agregar desglose IVA 19% y campo id_proveedor en formulario producto"

# Frontend — Commit 3: fix fantasmas
git add src/views/Inventario.vue
git commit -m "S3-HU02-BugFix: unificar inventario con productos registrados eliminando fantasmas"

# Backend (rama S3-HU02-T15-iva-proveedores) — Commit 1: T15
cd /home/icin/minegocio-backend
git add models/models.go handler/producto_handler.go
git commit -m "S3-HU02-T15: agregar precio_sin_iva e id_proveedor en modelo y calculo IVA 19%"

# Backend — Commit 2: T15 queries + fix fantasmas
git add repository/producto_repository.go repository/inventario_repository.go
git commit -m "S3-HU02-BugFix: COALESCE en columnas anulables y consulta directa a productos en inventario"

# Database (rama S3-HU02-T15-iva-proveedores)
cd /home/icin/minegocio-database
git add esquema.sql
git commit -m "S3-HU02-T15: tabla proveedores, columnas precio_sin_iva e id_proveedor, vista con filtro activo"
```

---

# Ronda 2 (misma jornada): refinamientos + Kanban Ubicaciones

Pedidos de Victor tras revisar la ronda 1:

## 1. Fix animación de cierre de sidebar
El nav aparecía desplazado hacia arriba un frame al cerrar. Causa: al aplicar `.sidebar--collapsed` el padding del logo salta instantáneamente de `22px 24px 28px` a `10px 24px` mientras la animación de salida corre. Fix: `transition: padding 0.5s var(--ease-spring)` en `.sidebar-logo` + la salida ya no usa translateY (se pliega en su lugar con scaleX+opacity+blur).

## 2. Kanban por ubicaciones (full stack)
Las columnas dejan de derivarse del stock y pasan a ser **ubicaciones físicas administrables**: Bodega, Vitrina, Sin clasificar (defaults) + agregar/eliminar manual.

- **DB**: tabla `ubicaciones` (seed con las 3 default), columna `productos.ubicacion` (default 'Sin clasificar').
- **Backend**: `GET/POST /api/ubicaciones`, `DELETE /api/ubicaciones/{id}` (protege 'Sin clasificar', reubica productos en transacción); PATCH `/api/inventario/{id}` ahora acepta `{stock}` y/o `{ubicacion}` (campos puntero opcionales).
- **Frontend**: KanbanBoard con columnas dinámicas por prop, botón basura por columna (hover, con confirm), riel "+" con input inline (Enter crea / Esc cancela), drag&drop asigna ubicación (ya NO toca el stock — se eliminó el stockMap 0/3/10/1). Fallback: si el backend no tiene `/api/ubicaciones`, tablero read-only con columnas default.

## 3. Animaciones consistentes de botones/overlays
Lenguaje único: hover lift (translateY -1px + sombra), press (scale 0.97), con `--ease-spring`. Aplicado a `.btn-primary` (base y productos.css), `.btn-secondary`, `.btn-icon`, `.btn-pag`. Modales con `overlayFade` + `modalPop` (Productos y crop de FormularioProducto).

## 4. Logo landing unificado
NavBar (landing pública): `MiNegocio` plano #2C3E50 → `<span class="brand-mi">Mi</span>Negocio` con Mi rojo (--color-brand) y resto negro puro, mismo letter-spacing que la sidebar.

## Auditoría
Ver [[Auditoria-2026-07-02-S3-HU02-T08-T15]] — **APROBADO con observaciones**. Crítico evitado: PATCH `{ubicacion}` contra backend viejo se decodificaba como `stock=0` (arrastrar una tarjeta vaciaba stock); mitigado con tablero editable solo si `/api/ubicaciones` responde.

## Pruebas ronda 2
- [x] `go build` + `go vet` + `go test ./...` — OK
- [x] `npm run build` — OK (app.5a3b863e.js / app.698fe7f2.css)
- [x] Deploy a dev :8080 → HTTP 200, cambios verificados en bundle

## Commits preparados ACTUALIZADOS (reemplazan a los de ronda 1 — NO ejecutados)

```bash
# Frontend (rama S3-HU02)
cd /home/icin/minegocio-frontend
git add src/components/SideBar.vue src/styles/base.css src/styles/variables.css src/styles/componentes.css
git commit -m "S3-HU02-T08: animacion sidebar spring + stagger + ripple y lenguaje de animacion consistente en botones"

git add src/components/FormularioProducto.vue src/views/Productos.vue src/styles/productos.css
git commit -m "S3-HU02-T15: desglose IVA 19% y campo id_proveedor en formulario producto"

git add src/components/KanbanBoard.vue src/views/Inventario.vue src/services/inventarioService.js
git commit -m "S3-HU02: kanban por ubicaciones (Bodega/Vitrina/Sin clasificar) con CRUD y fix productos fantasma"

git add src/components/NavBar.vue
git commit -m "S3-HU02: unificar logo MiNegocio de landing con el resto (Mi en rojo)"

# Backend (rama S3-HU02-T15-iva-proveedores)
cd /home/icin/minegocio-backend
git add models/models.go handler/producto_handler.go
git commit -m "S3-HU02-T15: precio_sin_iva e id_proveedor en modelo y calculo IVA 19%"

git add repository/producto_repository.go
git commit -m "S3-HU02-BugFix: COALESCE en columnas anulables — filas con NULL desaparecian de productos en silencio"

git add repository/inventario_repository.go service/inventario_service.go handler/inventario_handler.go routes/routes.go
git commit -m "S3-HU02: endpoints de ubicaciones para kanban y PATCH inventario con stock/ubicacion opcionales"

# Database (rama S3-HU02-T15-iva-proveedores)
cd /home/icin/minegocio-database
git add esquema.sql
git commit -m "S3-HU02: proveedores, precio_sin_iva, id_proveedor, tabla ubicaciones y vista con filtro activo"
```

---

## Ronda 3 (2026-07-02, tarde) — T1..T4: colapso 80px, tests DnD, renombrar ubicaciones

Victor ya había commiteado el trabajo de las rondas 1-2 (más ajustes propios). Esta ronda se ejecutó **con commits directos** (instrucción explícita), uno por tarea.

### Tareas ejecutadas

**T1 — Sidebar colapso real (80px)** — commit `27f3381` (frontend)
- `.sidebar--collapsed`: 200px → 80px
- `.sidebar-tag` y `.sidebar-logo` pasan a `flex-direction: column` colapsados (icono arriba, texto abajo)
- El texto se abrevia: "Negocio" se envolvió en `<span class="logo-resto">` y se oculta colapsado; queda el "Mi" rojo bajo el icono
- Main-content se expande solo (ya tenía `flex: 1` + transición de width)
- Tests: colapsada muestra SVG + texto abreviado, nav oculto (display: none), expandida muestra nav

**T2 — Tests DnD Kanban** — commit `08adbd8` (frontend)
- 9 tests nuevos: dragenter marca columna activa + clase `drop-zone--over`, dragleave fuera del rect limpia, `handleDragEnd` resetea, `allowDrop` fija `dropEffect: move`, `handleDragStart` serializa en `application/json` + fallback `text/plain` (y no serializa si `editable: false`), drop desde template emite `product-moved` (wiring `@drop`), drop sin datos se ignora
- Incluye limpieza de firmas: `allowDrop(event)` y `onDragLeave(event)` ya no reciben `nombre` sin uso

**T3 — Backend PATCH /api/ubicaciones/{id}** — commit `1f89f52` (backend, rama `S3-HU02-T15-iva-proveedores`)
- `repository.RenameUbicacion(id, nombreActual, nombreNuevo)`: transacción que renombra la fila de `ubicaciones` **y propaga a `productos.ubicacion`** (guarda texto, no id — sin la propagación los productos quedarían apuntando al nombre viejo)
- Handler `PatchUbicacion`: valida 1-40 chars (400), 404 si no existe, 400 si es "Sin clasificar" (protegida), 200 no-op si el nombre no cambió, 409 si el rename falla (UNIQUE duplicado)
- Refactor: `InventarioHandler` ahora recibe la interface `InventarioServiceI` (mismo patrón que `ProductoServiceI`) para poder mockear en tests
- Ruta `PATCH /api/ubicaciones/{id:[0-9]+}` con AuthMiddleware
- 8 tests de handler: exitoso, vacío→400, largo→400, inexistente→404, duplicado→409, fallback→400, mismo nombre no llama rename, JSON inválido→400
- `go build` / `go vet` / `go test ./...` verdes

**T4 — Frontend renombrar columna** — commit `ec09541` (frontend)
- `inventarioService.renameUbicacion(id, nombre)` → PATCH `/api/ubicaciones/{id}`
- KanbanBoard: botón lápiz en el header (aparece en hover, solo columnas eliminables — con id y no fallback) → input inline con el nombre actual seleccionado → Enter confirma y emite `renombrar-ubicacion {col, nombre}`, Esc/blur cancela; sin cambios o vacío no emite
- Inventario.vue: `renombrarUbicacion` llama al service y recarga todo (el backend propaga el nombre a los productos)
- Tests: lápiz visible solo en columnas con id (no en "Sin clasificar" ni columnas default), input con valor actual, Enter emite, Esc no emite, service PATCH con URL/body correctos

**Extra** — commit `610fb1d`: chore lint, imports sin uso preexistentes en `authGuard.test.js` (dejaba `npm run lint` en rojo).

### Verificación
- Frontend: 74/74 tests vitest verdes (antes 54), lint limpio, build `app.0b706e8b.js` desplegado a `/var/www/dev/frontend` y verificado en :8080 (bundle contiene el código nuevo)
- Backend: build/vet/tests verdes; **NO desplegado** — el contenedor `minegocio-backend-dev` sigue con la imagen vieja (404 en /api/ubicaciones); redesplegar sin aplicar los ALTER de esquema.sql rompería /api/productos, así que se mantiene el fallback del frontend (kanban read-only con columnas default)

### Pendiente para ver renombrar/CRUD de ubicaciones vivo en dev
1. Aplicar ALTERs de `esquema.sql` a la BD dev (ubicaciones, productos.ubicacion, precio_sin_iva, id_proveedor, proveedores)
2. Rebuild de la imagen del backend con la rama `S3-HU02-T15-iva-proveedores`
