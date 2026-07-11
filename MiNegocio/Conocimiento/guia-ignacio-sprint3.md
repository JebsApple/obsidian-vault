---
tags: [minegocio, sprint3, guia-estudio, ignacio]
created: 2026-07-10
---

# Guía de Estudio — Ignacio Varela — Sprint 3

> Nota sobre identidades git: Ignacio aparece con dos autores distintos en el historial: `IVarela` (email `IVarela@mail.com`, commits del 2026-05-26 al 2026-06-23) e `IgVml` (email `ignacio.varela.muzatto@alumnos.uta.cl`, commits del 2026-06-12 al 2026-06-30). Son la misma persona.
>
> Los commits de `IVarela` corresponden casi en su totalidad al **scaffolding inicial del proyecto Frontend** (Vue CLI: `App.vue`, `main.js`, `router/index.js`, vistas placeholder, assets de `public/`, limpieza de `dist/`) y a cambios triviales en Backend (borrar un comentario, renombrar un README). Ese código fue reescrito casi por completo por el equipo en sprints posteriores (fusión de vistas, renombrado a español, migración a servicios), así que hoy no queda contenido suyo identificable ahí — se omite del detalle técnico por instrucción explícita de no documentar renombres/triviales sin sustancia.
>
> El trabajo real y defendible de Sprint 3 es, bajo la identidad `IgVml`, la **funcionalidad de Ventas (Punto de Venta / POS)**, construida de punta a punta: tabla SQL → capas Go (repository/service/handler/routes) → componente Vue + servicio de consumo. Esta guía se centra en eso.

## Archivos modificados

| Archivo | Repo | Qué hace |
|---|---|---|
| `postgres/registro-ventas/sprint2_create_registro_ventas.sql` | database | Crea la tabla `registro_ventas` (una fila = un producto vendido). Es la tabla que usa hoy el backend en producción. |
| `postgres/registro-ventas/sprint2_drop_registro_ventas.sql` | database | Script de rollback: `DROP TABLE IF EXISTS registro_ventas`. |
| `postgres/registro-sesiones/sprint2_create_registro_sesiones` | database | Crea la tabla `registro_sesiones` (login/logout por usuario). Diseñada pero **no consumida** todavía por ningún handler Go actual. |
| `postgres/registro-sesiones/sprint2_drop_registro_sesiones.sql` | database | Rollback de `registro_sesiones`. |
| `postgres/registro-ventas/README.md.md` | database | Documento de planificación de Sprint 2 (HU05/HU06/HU07): reparte historias de usuario del equipo, explica cómo aplicar los scripts SQL. |
| `postgres/migrations/002_create_ventas_table.sql` (histórico, ya no existe en el árbol actual) | database | Primer intento de tabla `ventas` (con columnas `producto_id`, `total`, FKs `ON DELETE RESTRICT`). Fue reemplazado por `registro_ventas` y hoy no forma parte del esquema vigente (`postgres/esquema.sql` no la contiene). |
| `postgres/migrations/003_trigger_descuento_stock.sql` (histórico, ya no existe) | database | Trigger `BEFORE INSERT` en PL/pgSQL que descontaba stock automáticamente y bloqueaba la fila con `FOR UPDATE`. La misma idea (bloqueo optimista + descuento de stock) terminó implementándose en Go, en el repository/service de ventas, no en la base de datos. |
| `models/models.go` | backend | Contiene los structs `RegistroVenta`, `CreateVentaRequest`, `VentaItemRequest`, `VentaResponse` que modelan la tabla `registro_ventas` y el contrato JSON de la API de ventas. |
| `handler/venta_handler.go` | backend | Handler HTTP: expone `Create` (POST) y `GetAll` (GET) para `/api/ventas`. Valida input, obtiene el vendedor autenticado desde el JWT y delega en el service. |
| `service/venta_service.go` | backend | Orquesta la venta dentro de una transacción SQL: valida stock, inserta cada ítem, descuenta stock, calcula el total, hace commit o rollback. |
| `repository/venta_repository.go` | backend | Acceso a datos puro: `BeginTx`, `InsertVentaItem`, `GetStockForUpdate` (con `FOR UPDATE`), `DecreaseStock`, `GetAll`. |
| `routes/routes.go` | backend | Registra `/api/ventas` (POST y GET) protegidas con `middleware.AuthMiddleware`, e inyecta `ventaHandler` en el router. |
| `main.go` | backend | Wiring: instancia `VentaRepository`, `VentaService`, `VentaHandler` y los pasa a `routes.SetupRoutes`. |
| `src/views/Ventas.vue` (antes `VentasPage.vue`) | frontend | Vista de punto de venta: buscador de productos con debounce, soporte de lector de código de barras, grilla de resultados, y monta `CarritoCompras`. |
| `src/components/CarritoCompras.vue` | frontend | Componente de carrito: tabla de ítems, validación de cantidad contra stock, cálculo de subtotales/total, botón "Confirmar Venta" que llama a `ventasService`. |
| `src/services/ventasService.js` | frontend | Capa de servicio: `registrarVenta`, `getVentas`, `getVenta`, todas con `fetch` + headers de autenticación (`Bearer` token). |
| `src/styles/carritocompras.css` | frontend | Estilos scoped del carrito (tabla, footer, botones, responsive). |
| `src/router/index.js` | frontend | Agrega la ruta `/ventas` → componente `Ventas`, protegida con `meta: { requiresAuth: true }`. |
| `src/views/Productos.vue` (antes `ProductosPage.vue`) | frontend | Truncado de `nombre` (30 caracteres) y `descripcion` (50 caracteres) en la tabla de listado, para que textos largos no rompan el layout. |

## Arquitectura del código

El backend sigue una arquitectura en capas estricta: **handler → service → repository → models**, y el trabajo de Ignacio respeta exactamente ese patrón para el dominio "Ventas":

- **`models/models.go`** define las structs de transporte (`CreateVentaRequest`, `VentaItemRequest`) y de persistencia (`RegistroVenta`), con tags JSON. No tiene lógica, solo forma los datos que viajan entre capas.
- **`repository/venta_repository.go`** es la única capa que toca SQL. Expone métodos atómicos (`GetStockForUpdate`, `InsertVentaItem`, `DecreaseStock`) que reciben una `*sql.Tx` ya abierta — no decide cuándo hacer commit/rollback, eso es responsabilidad del service.
- **`service/venta_service.go`** contiene la regla de negocio central: abre una transacción, por cada ítem del carrito bloquea la fila de stock (`SELECT ... FOR UPDATE`), valida que haya stock suficiente, inserta la venta y descuenta el stock, todo dentro de la misma transacción — si cualquier paso falla, se hace rollback (`defer tx.Rollback()`) y no queda stock descontado a medias. Este service también depende de `ProductoRepository` (de otro compañero) para mantener consistencia con el dominio de productos.
- **`handler/venta_handler.go`** es la capa HTTP: decodifica JSON, valida que el carrito no esté vacío, y **obtiene el `id_vendedor` desde el contexto de autenticación JWT** (`middleware.GetUserID`) en vez de confiar en lo que mande el cliente — esto conecta con el middleware de autenticación hecho por otro integrante (Gabriel, JWT).
- **`routes/routes.go`** y **`main.go`** son las piezas de wiring: registran las rutas `/api/ventas` bajo `AuthMiddleware` y arman la cadena de dependencias (`db → repo → service → handler → router`) siguiendo el mismo patrón que ya usan `productos`, `inventario` y `usuarios`.

En la base de datos, la tabla realmente usada en producción hoy es `registro_ventas` (definida en `postgres/registro-ventas/sprint2_create_registro_ventas.sql`), con FK a `productos` y a `usuarios`, e índices sobre `id_producto`, `id_vendedor` y `fecha_venta` para acelerar reportes. El primer diseño de Ignacio (tabla `ventas` + trigger PL/pgSQL `fn_descontar_stock`/`trg_descontar_stock` en `postgres/migrations/`) quedó descartado: la validación de stock y el descuento se resolvieron finalmente en Go (dentro de la transacción del service), no como trigger de base de datos. Es útil que lo tenga presente porque muestra una decisión de arquitectura real (lógica de negocio en la aplicación vs. en la base de datos) que puede justificar en la defensa.

En el frontend, la arquitectura es **views → components → services**, sin `fetch` directo desde la vista (regla del proyecto). `Ventas.vue` es la vista que orquesta la búsqueda de productos (usa `inventarioService`, hecho por otro compañero) y delega la gestión del carrito a `CarritoCompras.vue`, que a su vez usa `ventasService.js` para hablar con `POST /api/ventas`. La comunicación entre `Ventas.vue` y `CarritoCompras.vue` es por props (`items`) y eventos (`update-items`, `venta-completada`), el patrón estándar de Vue 3 Options API que usa el resto del proyecto. El endpoint que consume (`/api/ventas`) es exactamente el que expone `venta_handler.go` en el backend, cerrando el circuito full-stack.

## Explicación por archivo

### `postgres/registro-ventas/sprint2_create_registro_ventas.sql`
Crea la tabla `registro_ventas` con `id_venta SERIAL PRIMARY KEY`, `id_producto` (FK a `productos`), `precio_producto` (snapshot del precio al momento de la venta, no una referencia al precio actual del producto — decisión correcta para no alterar el histórico si el precio cambia después), `cantidad` (con `CHECK (cantidad > 0)`), `fecha_venta` (default `now()`), e `id_vendedor` (FK a `usuarios`, `ON DELETE SET NULL` para no perder el historial de ventas si se borra el usuario). Incluye tres índices (`id_producto`, `id_vendedor`, `fecha_venta`) pensados para las consultas típicas de reportes. Es la tabla real que usa `venta_repository.go` hoy (`INSERT INTO registro_ventas ... RETURNING id_venta`).

### `postgres/registro-sesiones/sprint2_create_registro_sesiones`
Tabla paralela para registrar inicio/cierre de sesión por usuario (`id_usuario`, `inicio_sesion`, `cierre_sesion NULL` = sesión abierta). Fue diseñada en el mismo sprint que ventas pero **no tiene ningún handler/repository Go que la use actualmente** (se verificó con `grep` sobre todo el backend). Es una funcionalidad preparada pero no conectada al backend — vale la pena que Ignacio lo aclare si le preguntan, para no dar la impresión de que está en uso. Nota menor: el archivo no tiene extensión `.sql` (a diferencia de su script de rollback), inconsistencia de nomenclatura.

### `postgres/registro-ventas/README.md.md`
Documento de planificación de Sprint 2 que reparte las historias de usuario del equipo (HU05 Registrar Venta, HU06 Crear y Buscar Productos, HU07 Lector de Código de Barras) y documenta cómo aplicar los scripts SQL (`psql -U postgres -d cliente_dev -f ...`). Muestra que Ignacio fue quien definió el alcance original de "Ventas" como historia de usuario, incluyendo el endpoint `POST /api/ventas` y la vista `VentasPage.vue`.

### `models/models.go` (sección de Ventas)
Define el contrato de datos de la API de ventas: `RegistroVenta` (fila completa devuelta por `GET /api/ventas`, incluye `NombreProducto` vía JOIN), `CreateVentaRequest` (body de `POST /api/ventas`: lista de `Items` + `IDVendedor`), `VentaItemRequest` (un ítem del carrito: `ProductoID`, `Cantidad`, `PrecioVenta`) y `VentaResponse` (respuesta con `Status`, `Mensaje`, `IDVenta`, `Total`). El comentario `// Venta models (S2-HU02) — aligned with registro_ventas table` dentro del archivo confirma la trazabilidad con la tabla SQL.

### `repository/venta_repository.go`
Capa de acceso a datos sin lógica de negocio. `BeginTx()` abre una transacción; `GetStockForUpdate(tx, productoID)` hace `SELECT stock FROM productos WHERE id = $1 FOR UPDATE` — el `FOR UPDATE` bloquea la fila para que dos ventas concurrentes del mismo producto no lean el mismo stock "viejo" (evita condición de carrera); `InsertVentaItem` inserta una fila en `registro_ventas` y devuelve el `id_venta` generado; `DecreaseStock` hace el `UPDATE productos SET stock = stock - $1`; `GetAll` hace un `LEFT JOIN` con `productos` para traer el nombre del producto junto con cada venta, ordenado por fecha descendente.

### `service/venta_service.go`
`Create(req)` es el método central: abre transacción, y para cada ítem del carrito hace, en orden, `GetStockForUpdate` → valida `stock < item.Cantidad` (si no alcanza, corta con error "stock insuficiente para uno o más productos") → `InsertVentaItem` → `DecreaseStock`, acumulando el `total` en memoria. Si todos los ítems se procesan sin error, hace `tx.Commit()`; si algo falla en cualquier punto, el `defer tx.Rollback()` deshace todo (ninguna venta parcial queda guardada ni stock descontado a medias). `GetAll()` simplemente delega al repository. Depende de `ProductoRepository` en el constructor aunque en el código mostrado no lo usa directamente para lectura — se inyecta para mantener consistencia con el patrón de dependencias del proyecto.

### `handler/venta_handler.go`
`Create`: decodifica el JSON del body a `CreateVentaRequest`, rechaza carritos vacíos (400), y **sobrescribe `req.IDVendedor` con el valor que viene del JWT** (`middleware.GetUserID(r.Context())`) en vez de confiar en lo que el cliente mande en el body — mitigación explícita contra que alguien falsifique con qué usuario se registra la venta. Si `Create` del service falla, devuelve 400 con el mensaje de error; si todo sale bien, responde 201 con el `VentaResponse`. `GetAll`: expone el listado completo de ventas, usado por la vista de "Registro de Ventas" (hecha por otro compañero, `RegistroVentas.vue`).

### `routes/routes.go` y `main.go` (sección Ventas)
En `routes.go`, `SetupRoutes` recibe `ventaHandler` como parámetro y registra `POST /api/ventas` y `GET /api/ventas`, ambas envueltas en `middleware.AuthMiddleware`. En `main.go`, el wiring instancia `ventaRepo := repository.NewVentaRepository(db)`, luego `ventaService := service.NewVentaService(ventaRepo, productoRepo)`, luego `ventaHandler := handler.NewVentaHandler(ventaService)`, y pasa `ventaHandler` a `routes.SetupRoutes(...)`. Es inyección de dependencias manual (constructor injection), el mismo patrón que usan `productos`, `inventario` y `usuarios`.

### `src/views/Ventas.vue`
Vista de Punto de Venta. Tiene un input de búsqueda con debounce de 300ms (`onInputChange` → `setTimeout` → `buscarProductos`) que llama a `inventarioService.buscarProductos(query)`. Además soporta lectura de código de barras: `procesarEntrada()` se dispara con Enter, limpia el input inmediatamente (para que un lector de código de barras no concatene lecturas encima de texto viejo), busca coincidencia exacta por `codigo_barras`, y si la encuentra la agrega directo al carrito (validando que tenga stock antes). `agregarAlCarrito(p)` incrementa la cantidad si el producto ya está en el carrito (respetando el tope de stock con `Math.min`), o lo agrega nuevo. El componente `CarritoCompras` recibe `carrito` por prop y escucha `update-items` (sincroniza el array) y `venta-completada` (relanza la búsqueda para refrescar el stock mostrado tras vender).

### `src/components/CarritoCompras.vue`
Tabla editable del carrito: cada fila tiene un input numérico de cantidad con `:max="item.stock"` y `@input="validarCantidad"`, que clampa la cantidad entre 1 y el stock disponible (no dispara error del navegador, corrige el valor directamente). Calcula subtotal por fila (`cantidad * precio_venta`) y el total global vía `computed`. `confirmarVenta()` arma el payload (`{ items: [{ producto_id, cantidad, precio_venta }] }`) y llama a `ventasService.registrarVenta`; si tiene éxito muestra un modal con el ID de venta y el total, vacía el carrito (`$emit('update-items', [])`) y emite `venta-completada` para que la vista padre refresque stock. Usa `inject: ['$modal']` para mostrar alertas, en vez de `alert()` nativo del navegador — patrón consistente con el resto del proyecto.

### `src/services/ventasService.js`
Capa de servicio HTTP pura: `registrarVenta(payload)` hace `POST /api/ventas` con header `Authorization: Bearer <token>` (leído de `localStorage`), y si `res.ok` es falso intenta parsear el body de error para lanzar un `Error` con el mensaje del backend. `getVentas()` y `getVenta(id)` son GET análogos. Es el único punto del frontend que sabe la URL del endpoint de ventas — cumple la regla del proyecto de que las vistas no hagan `fetch` directo.

### `src/styles/carritocompras.css`
CSS scoped del carrito: tarjeta con sombra, tabla con cabecera gris (`#ECF0F1`), botón de eliminar transparente, y un media query a 768px que apila el footer en columna para mobile. Nota técnica: usa colores hardcodeados (`#FFFFFF`, `#2C3E50`, `#ECF0F1`) en vez de las variables de `variables.css`, lo cual contradice la convención de estilos del proyecto (jerarquía `variables.css → base.css → página`) — es un punto que podría salir en la revisión de código.

### `src/router/index.js` (ruta de Ventas)
Agrega la ruta `{ path: '/ventas', name: 'ventas', component: Ventas, meta: { requiresAuth: true } }`. El `meta.requiresAuth` es leído por un guard global (hecho por otro compañero) que redirige a `/login` si no hay sesión. También existe un redirect por defecto: si el usuario no es admin, `/` y las rutas de admin redirigen a `/ventas`, lo que la convierte en la pantalla de aterrizaje principal del sistema para vendedores.

### `src/views/Productos.vue` (truncado de texto)
Cambio puntual: en la celda de la tabla de productos, el nombre se corta a 30 caracteres y la descripción a 50, agregando `...` si se exceden (`p.nombre.length > 30 ? p.nombre.slice(0, 30) + '...' : p.nombre`). El mensaje del commit aclara que también se amplió en la base de datos la columna `descripcion` a `varchar(200)` (`ALTER TABLE productos ALTER COLUMN descripcion TYPE character varying(200)`) para evitar que se corte a nivel de base de datos — es un fix de UI (evitar que texto largo rompa el layout de la tabla) acompañado de un cambio de esquema en dev.

## Preguntas de estudio

1. En `venta_service.go`, ¿por qué se usa `SELECT stock FOR UPDATE` antes de descontar el stock, y qué pasaría si se usara un `SELECT` normal en su lugar bajo dos ventas simultáneas del mismo producto?
2. ¿Por qué el `id_vendedor` se sobrescribe en el handler con el valor del JWT (`middleware.GetUserID`) en vez de tomarlo del body del request que manda el frontend?
3. Explicá el ciclo completo de `tx.Rollback()` con `defer` en `venta_service.go`: ¿en qué casos se ejecuta, y por qué eso garantiza que nunca quede un stock descontado sin la venta correspondiente guardada (o viceversa)?
4. La tabla real usada en producción es `registro_ventas`, no `ventas`. ¿Qué diferencias de diseño hay entre el primer intento (`postgres/migrations/002_create_ventas_table.sql` + trigger `003_trigger_descuento_stock.sql`) y el diseño final? ¿Por qué se terminó descontando el stock en Go y no con un trigger de PostgreSQL?
5. ¿Por qué `precio_producto` se guarda como columna propia en `registro_ventas` en vez de simplemente hacer JOIN contra `productos.precio_venta` al momento de mostrar el historial?
6. En `Ventas.vue`, ¿qué problema resuelve limpiar `this.textoBusqueda = ''` de forma síncrona apenas se dispara `procesarEntrada()`, antes de esperar la respuesta del backend? (pensalo en términos de un lector de código de barras que "tipea" rápido)
7. ¿Cómo viaja el evento `venta-completada` desde `CarritoCompras.vue` hasta `Ventas.vue`, y para qué se usa ahí?
8. La tabla `registro_sesiones` fue diseñada en el mismo sprint que `registro_ventas`. ¿Está en uso hoy por el backend? ¿Cómo lo comprobarías vos mismo en el código?
9. ¿Qué endpoint expone `venta_handler.go` además de `Create`, y qué vista del frontend lo consume?
10. ¿Por qué `CarritoCompras.vue` usa `inject: ['$modal']` en vez de `alert()`/`confirm()` nativos del navegador?

## Archivos clave para repasar

- `service/venta_service.go` — es el corazón de la lógica de negocio (transacción, validación de stock, rollback); es lo primero que va a preguntar cualquier profesor sobre "cómo funciona una venta".
- `repository/venta_repository.go` — para poder explicar el `FOR UPDATE` y por qué evita condiciones de carrera, un tema clásico de examen sobre concurrencia en bases de datos.
- `postgres/registro-ventas/sprint2_create_registro_ventas.sql` — el diseño de la tabla real en uso; conocerlo de memoria (FKs, constraints, índices) da seguridad para responder preguntas de modelado.
- `src/components/CarritoCompras.vue` — conecta validación de UI (stock), cálculo de totales y la llamada final al backend; es el componente más grande que escribió en frontend.
- `handler/venta_handler.go` — para explicar cómo se conecta el JWT con la venta (seguridad: no confiar en el `id_vendedor` del cliente).
