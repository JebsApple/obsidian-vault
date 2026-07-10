---
tags: [minegocio, sprint3, guia-estudio, victor]
created: 2026-07-10
---

# Guía de Estudio — Víctor Herrera — Sprint 3

## Archivos modificados

| Archivo | Repo | Qué hace |
|---|---|---|
| `middleware/auth_middleware.go` | backend | Middleware JWT: valida el token y (tras el fix) guarda `user_id`/`rol` en el `context.Context` de la request |
| `handler/venta_handler.go` | backend | Handler HTTP de ventas; toma el `id_vendedor` del contexto (JWT) en vez de confiar en el body |
| `service/venta_service.go` | backend | Lógica de negocio de una venta: transacción, chequeo de stock, inserción de items, descuento de stock |
| `repository/venta_repository.go` | backend | Acceso a datos de `registro_ventas`: inserta items, hace `SELECT ... FOR UPDATE` del stock, lista ventas |
| `config/jwt.go` | backend | Genera y firma los JWT (access + refresh) con claims `user_id`, `nombre`, `rol` |
| `handler/auth_handler.go` | backend | Endpoints de login/registro/refresh; delega en `AuthServiceI` |
| `handler/usuario_handler.go` | backend | CRUD de usuarios + subida de foto de perfil + soft-delete/reactivar |
| `service/usuario_service.go` | backend | Reglas de negocio de usuarios: hash bcrypt al crear, soft-delete "inteligente" |
| `repository/usuario_repository.go` | backend | SQL de usuarios: login por credenciales (con bcrypt), CRUD, `activo`, `foto_url` |
| `handler/proveedor_handler.go` | backend | CRUD HTTP de proveedores + reactivar |
| `service/proveedor_service.go` | backend | Reglas de negocio de proveedores: soft-delete "inteligente" |
| `repository/proveedor_repository.go` | backend | SQL de proveedores: create/update/delete/reactivate/hard-delete |
| `handler/inventario_handler.go` | backend | Endpoints de inventario + CRUD de `ubicaciones` (columnas del kanban) |
| `repository/inventario_repository.go` | backend | SQL de inventario y ubicaciones; rename/delete de ubicación propaga a `productos.ubicacion` en transacción |
| `handler/interfaces.go` / `service/interfaces.go` | backend | Contratos (interfaces) entre capas handler→service→repository, para poder mockear en tests |
| `models/models.go` | backend | Structs compartidos: `Usuario`, `Proveedor`, `CreateVentaRequest`, `RegistroVenta`, etc. |
| `routes/routes.go` | backend | Registro de todas las rutas `/api/...` con `mux`, envueltas en `AuthMiddleware` |
| `middleware/upload.go` | backend | Valida tamaño (5MB) y "magic bytes" del archivo subido (foto de perfil / imagen de producto) |
| `postgres/esquema.sql`, root `esquema.sql` | database | Dump del esquema completo: tablas `productos`, `usuarios`, `proveedores`, `ubicaciones`, FKs, seed de ubicaciones base |
| `registro-ventas/sprint2_create_registro_ventas.sql` | database | Creación original de `registro_ventas` con la FK `id_vendedor → usuarios(id)` que disparaba el bug |
| `postgres/setup_produccion.sql`, `postgres/backup_server.sql` | database | Script de seed de producción; Víctor reemplazó el hash placeholder del admin por un hash bcrypt real |
| `src/views/Analisis.vue` | frontend | Dashboard con gráficos (Chart.js/vue-chartjs) y exportación PDF/Excel |
| `src/components/KanbanBoard.vue` | frontend | Tablero kanban de inventario con columnas dinámicas por ubicación física, drag & drop |
| `src/views/AdminUsuariosPage.vue` | frontend | CRUD de usuarios en el frontend (crear, listar, desactivar/eliminar, reactivar) |
| `src/views/AdminProveedoresPage.vue` | frontend | CRUD de proveedores en el frontend, con modal de alta/edición |
| `src/services/proveedoresService.js` | frontend | Wrapper `fetch` de los endpoints `/api/proveedores` |
| `src/services/ventasService.js` | frontend | Wrapper `fetch` de `/api/ventas` (registrar y listar) |
| `src/services/inventarioService.js` | frontend | Wrapper `fetch` de `/api/inventario` y `/api/ubicaciones` |
| `src/services/authService.js` | frontend | Login, logout, decodificación del JWT, refresh token, subida de foto de perfil |
| `src/components/ModalFotoPerfil.vue` | frontend | Modal de subida/recorte (Cropper.js) de la foto de perfil |
| `src/components/SideBar.vue` | frontend | Sidebar colapsable, ahora unificada para estado logueado y no logueado |
| `src/App.vue` | frontend | Shell de la app: decide layout, monta `SideBar` siempre (ya no condicional a login) |
| `src/views/Login.vue` | frontend | Vista de login; ya no depende de `NavBar`, usa el `SideBar` global de `App.vue` |
| `src/components/NavBar.vue` | frontend | Navbar superior — quedó huérfana tras unificar la navegación en `SideBar` (ver Reglas/Hallazgos) |
| `src/router/index.js` | frontend | Definición de rutas Vue Router y sus `meta.requiresAuth` |
| `src/config/funcionalidades.js` | frontend | Flag `HABILITAR_WIP` para ocultar features en el build de producción |

## Arquitectura del código

**Backend (Go):** el proyecto sigue capas estrictas `handler → service → repository → models`, con `main.go` como wiring puro. Cada capa depende de una interfaz de la capa inferior (`handler/interfaces.go` define `ProveedorServiceI`, `UsuarioServiceI`, etc.; `service/interfaces.go` define `ProveedorRepositoryI`, `UsuarioRepositoryI`, etc.), lo que permite inyectar mocks en los tests (`*_test.go`) sin tocar la base de datos real. `routes/routes.go` es el único lugar que conecta URL + método HTTP + middleware + handler concreto. El middleware de autenticación (`middleware/auth_middleware.go`) envuelve casi todas las rutas salvo login/registro/refresh, y desde el fix de Víctor es la única fuente confiable del usuario autenticado (vía `context.Context`), que los handlers leen con `middleware.GetUserID(ctx)`.

El trabajo de Víctor toca prácticamente todos los módulos de negocio nuevos del Sprint 3 (ventas, usuarios, proveedores, inventario/ubicaciones) y la pieza transversal de autenticación que los atraviesa a todos. El módulo de productos (`handler/producto_handler.go`, `service/producto_service.go`) también aparece en su historial pero mayormente por refactors de capas compartidas (T07 "corregir capas backend"), no como autor original de esa lógica.

**Frontend (Vue 3):** patrón `views/` (páginas montadas por el router) que consumen `services/` (wrappers de `fetch` que agregan el header `Authorization: Bearer <token>` y traducen errores HTTP a `Error` de JS), nunca `fetch` directo desde la vista — con la excepción de `AdminUsuariosPage.vue`, que Víctor escribió usando `fetch` inline en vez de crear/usar un `usuariosService.js` (ese servicio existe en el repo pero fue escrito por otro integrante y no es el que usa esta vista; ver "Hallazgos" abajo). El estado de sesión vive en el JWT decodificado (`jwt-decode`) más un valor cacheado de la foto de perfil en `localStorage`; no hay Vuex/Pinia — `authService.js` hace ese rol con funciones sueltas. `App.vue` es el layout raíz: monta `SideBar` una sola vez (siempre, logueado o no) y decide el resto del layout (panel colapsado, menú contextual del avatar, modal de foto de perfil) de forma centralizada.

**Base de datos:** PostgreSQL con productos, usuarios, proveedores y ubicaciones como tablas centrales, todas con soft-delete vía columna `activo boolean`. La tabla `registro_ventas` (creada en Sprint 2, tocada aquí por el fix del vendedor) tiene FK `id_vendedor → usuarios(id)`; esa FK es la que exponía el bug crítico cuando el backend mandaba `id_vendedor = 0`.

## Explicación por archivo

### `middleware/auth_middleware.go` + `handler/venta_handler.go` (el fix crítico)

Este es el núcleo del hotfix más importante del sprint. `AuthMiddleware` parsea y valida el JWT con `jwt.ParseWithClaims`, pero **antes del fix**, después de validar el token simplemente llamaba a `next.ServeHTTP(w, r)` con el `request` original, sin request nuevo ni contexto — las claims parseadas (`claims.UserID`, `claims.Rol`) se descartaban por completo apenas terminaba la función. El middleware confirmaba "este token es válido" pero nunca comunicaba *quién* era ese usuario al resto de la cadena de handlers.

Mientras tanto, `VentaHandler.Create` (antes del fix) decodificaba el body JSON a `models.CreateVentaRequest`, que incluye un campo `IDVendedor int`, y usaba ese valor directo para el INSERT. El frontend (`ventasService.js` → `registrarVenta`) nunca mandaba ese campo en el payload, así que Go lo dejaba en su valor por defecto: `0`. Como `registro_ventas.id_vendedor` tiene la FK `REFERENCES usuarios(id)`, y no existe (normalmente) un usuario con `id = 0`, cada intento de venta fallaba con una violación de constraint (`registro_ventas_id_vendedor_fkey`).

El fix (commits `41a5688` y su reaplicación como hotfix `5ab9938`, éste último con mensaje explícito: *"El middleware de auth validaba el JWT pero nunca guardaba las claims en el contexto de la request..."*) agrega tres piezas: (1) tipos y constantes de contexto (`authContextKey`, `UserIDKey`, `UserRolKey`) y helpers `GetUserID(ctx)` / `GetUserRol(ctx)`; (2) el middleware ahora construye `ctx := context.WithValue(r.Context(), UserIDKey, claims.UserID)` y llama `next.ServeHTTP(w, r.WithContext(ctx))`, propagando el contexto enriquecido; (3) `VentaHandler.Create` deja de leer `IDVendedor` del body y en su lugar hace `userID, ok := middleware.GetUserID(r.Context())`, devolviendo 401 si no hay usuario en contexto. El campo `IDVendedor` del JSON entrante ahora se ignora por completo — la fuente de verdad es siempre el JWT.

Nota histórica: hubo un intento previo de este mismo fix (`b0d5b13`, 30 de junio) que usaba una función `middleware.ClaimsFromContext(r)` — esa versión se perdió en un refactor de capas posterior (`d2cf3ed`, T07) y el bug volvió a aparecer, por lo que Víctor tuvo que re-diagnosticarlo y corregirlo de nuevo el 10 de julio con el enfoque `GetUserID` actual.

### `service/venta_service.go` + `repository/venta_repository.go`

`VentaService.Create` recibe el `CreateVentaRequest` ya con `IDVendedor` seteado por el handler y ejecuta una transacción SQL por cada item del carrito: abre `tx` con `BeginTx()`, por cada producto hace `GetStockForUpdate(tx, id)` (un `SELECT ... FOR UPDATE`, que bloquea la fila para evitar condiciones de carrera si dos ventas concurrentes descuentan el mismo producto), valida que `stock >= cantidad`, inserta la fila en `registro_ventas` vía `InsertVentaItem` (que ahora persiste el `id_vendedor` real) y descuenta el stock con `DecreaseStock`. Si cualquier paso falla, el `defer tx.Rollback()` deshace todo; si todos los items se procesan bien, hace `tx.Commit()`. El repositorio es una capa fina sobre `database/sql`, sin ORM.

### `service/proveedor_service.go` + `service/usuario_service.go` (patrón soft-delete "inteligente")

Ambos servicios implementan el mismo patrón, comentado explícitamente en el código: *"Delete es 'inteligente': si el [recurso] esta activo lo desactiva (soft delete); si ya estaba inactivo, lo elimina definitivamente."* La función `Delete(id)` primero hace `GetByID(id)` para leer el estado actual; si `Activo == true`, llama a `repo.Delete(id)` (que hace `UPDATE ... SET activo = false`); si ya estaba `false`, llama a `repo.HardDelete(id)` (que hace un `DELETE FROM ...` real, irreversible). Esto significa que el mismo botón/endpoint de "eliminar" tiene dos comportamientos distintos según el estado previo del registro — el frontend refleja esto mostrando textos de confirmación distintos ("¿Desactivar?" vs "Esta acción lo eliminará definitivamente"). El mismo patrón existe también en `service/producto_service.go` (`SoftDeleteProducto`/`Reactivate`), aunque ese archivo no fue escrito originalmente por Víctor — sólo lo tocó en refactors de interfaces.

Los repositorios (`proveedor_repository.go`, `usuario_repository.go`) exponen los tres métodos necesarios (`Delete` = soft, `Reactivate` = `UPDATE activo = true`, `HardDelete` = `DELETE`), y las interfaces en `service/interfaces.go` los declaran explícitamente para que el servicio pueda mockearlos en tests.

### `handler/usuario_handler.go` — CRUD de usuarios y foto de perfil

`CreateUsuario` valida a mano (nombre/email/password/rol no vacíos, password ≥ 8 caracteres, rol ∈ {`admin`,`vendedor`}) antes de delegar en el servicio, que hashea la contraseña con `bcrypt.GenerateFromPassword` (costo por defecto) en `UsuarioService.Create`. `UploadFotoUsuario` es el endpoint de subida de foto: lee del `r.MultipartForm.Value["_validatedMIME"/"_validatedBytes"]` — estos campos los deja escritos `middleware.UploadMiddleware` (ver abajo) después de validar tamaño y firma real del archivo — genera un nombre único con `uuid.New()`, escribe el archivo en `uploads/usuarios/` y persiste la URL en la tabla `usuarios` vía `UpdateFotoURL`. Si falla el `UPDATE` en base de datos, borra el archivo recién escrito (`os.Remove`) para no dejar huérfanos en disco. `DeleteUsuario`/`ReactivarUsuario` son los endpoints REST que disparan el soft-delete "inteligente" descrito arriba.

### `middleware/upload.go`

Middleware reutilizado tanto por la subida de foto de usuario como de imagen de producto. Limita el tamaño a 5MB (`maxUploadSize`), lee los primeros bytes del archivo subido y los compara contra "magic bytes" conocidos (`0xFFD8FF` para JPEG, `0x89504E47` para PNG, cabecera `RIFF...WEBP` para WebP) en `DetectImageMIME` — es decir, no confía en el `Content-Type` que manda el navegador, sino que inspecciona el contenido real del archivo. Si el formato no es válido devuelve 400 antes de que el handler llegue a tocar disco.

### `handler/inventario_handler.go` + `repository/inventario_repository.go` — backend del Kanban

Además de los endpoints clásicos de inventario (`GetInventario`, `PatchStock` para actualizar stock y/o ubicación), este handler expone el CRUD completo de `ubicaciones`, que son las columnas dinámicas del tablero kanban del frontend: `GetUbicaciones`, `CreateUbicacion` (valida nombre entre 1 y 40 caracteres), `PatchUbicacion` (renombrar) y `DeleteUbicacion`. Hay una ubicación protegida, `"Sin clasificar"` (constante `nombreUbicacionFallback`), que no se puede renombrar ni eliminar — actúa como columna de rescate. En el repositorio, `RenameUbicacion` y `DeleteUbicacion` corren en transacción porque `productos.ubicacion` guarda el **nombre** de la ubicación como texto plano (no un FK numérico): al renombrar hay que propagar el nuevo nombre a todos los productos que apuntaban al nombre viejo, y al eliminar hay que reasignar sus productos a `'Sin clasificar'` antes de borrar la fila, para no dejar productos "huérfanos" con una ubicación inexistente.

### `src/views/Analisis.vue` — Dashboard

Vista principal de análisis, con dos estados: landing (no logueado, muestra features y CTA a `/login`) y dashboard (logueado). Carga datos en paralelo con `Promise.all` desde tres servicios (`productosService`, `ventasService`, `usuariosService`) en `cargarDatos()`. Calcula en el cliente (sin endpoints de agregación en el backend): total de productos, productos agotados, valor de inventario (`Σ precio_venta × stock`), ventas de hoy, producto más vendido, ventas agrupadas por mes (últimos 6 meses) y ventas agrupadas por vendedor (cruzando `id_vendedor` de cada venta contra la lista de usuarios para mostrar el nombre). Los gráficos usan `vue-chartjs` + `chart.js` (`Bar`, registrando sólo los plugins que usa: `Title`, `Tooltip`, `Legend`, `BarElement`, `CategoryScale`, `LinearScale`). La exportación a PDF usa `jsPDF` + `jspdf-autotable` para generar una tabla tabulada de todas las ventas; la exportación a Excel usa `xlsx` (`json_to_sheet` + `writeFile`) generando un `.xlsx` descargable directo en el navegador, sin pasar por el backend.

### `src/components/KanbanBoard.vue` — Kanban con columnas dinámicas

Componente "tonto" (recibe `productos` y `ubicaciones` por props, no hace fetch propio) que renderiza una columna por cada ubicación recibida. Filtra los productos de cada columna con `getProductosPorUbicacion`, comparando el texto `producto.ubicacion` contra el nombre de la columna (`ubicacionDe` devuelve `null` si el producto apunta a una ubicación que ya no existe como columna visible, evitando que se pierda silenciosamente). El drag & drop es HTML5 nativo: `handleDragStart` serializa el producto completo a JSON en `dataTransfer`, `handleDrop` lo deserializa y emite `product-moved` con `{ productId, nuevaUbicacion }` para que la vista padre (`Inventario.vue`) llame al servicio. El componente también gestiona la UI de alta/renombrado/borrado de columnas (emitiendo eventos hacia el padre, sin llamar servicios directamente) y un modo "columna expandida" (`expandedCol`) que agranda una columna para ver el detalle de cada tarjeta.

### `src/services/proveedoresService.js`, `ventasService.js`, `inventarioService.js`

Los tres siguen el mismo patrón mínimo: función `authHeaders()` que lee el token de `localStorage` y arma los headers, y un objeto exportado con un método `async` por endpoint que hace `fetch`, chequea `res.ok` y si falla intenta parsear el JSON de error para lanzar un `Error` con el mensaje del backend (o un mensaje genérico si el parseo falla). Es el mismo contrato que usan las vistas para no manejar `fetch` crudo — salvo la excepción de `AdminUsuariosPage.vue` señalada en el apartado anterior.

### `src/services/authService.js`

No es un módulo con clase/objeto sino funciones sueltas exportadas (`login`, `logout`, `getToken`, `isTokenExpired`, `getUserFromToken`, `refreshToken`, `uploadFotoPerfil`, `getFotoPerfilUrl`/`setFotoPerfilUrl`). El estado "de sesión" no vive en un store: se deriva del JWT decodificado en el momento (`jwt-decode`), y sólo la URL de la foto de perfil se cachea aparte en `localStorage` bajo la key `foto_perfil_url` (para no tener que decodificar el token sólo para pintar el avatar). `uploadFotoPerfil(file)` arma un `FormData`, obtiene el `id` del usuario actual del propio JWT (`getUserFromToken().id`) y sube a `/api/usuarios/{id}/imagen`; si la respuesta trae `imagen_url`, la persiste con `setFotoPerfilUrl`.

### `src/components/ModalFotoPerfil.vue`

Modal de dos pasos: selección de archivo (click o drag&drop, valida tamaño ≤5MB y tipo JPEG/PNG en el cliente con `validarArchivo`) y recorte con `cropperjs` (aspect ratio 1:1 forzado, zoom con slider). Al confirmar (`confirmarCrop`), usa `getCroppedCanvas` de Cropper, dibuja el resultado sobre un `<canvas>` con fondo blanco (para evitar transparencia en el JPEG final), lo convierte a `Blob` con `canvas.toBlob(..., 'image/jpeg', 0.9)` y llama a `uploadFotoPerfil` de `authService.js`. Al terminar emite `foto-actualizada`, que en `App.vue` dispara `this.$refs.sidebar?.recargarFoto()` para refrescar el avatar sin recargar la página.

### `src/App.vue` + `src/components/SideBar.vue` + `src/views/Login.vue` — unificación de la sidebar

Antes del commit `1a239b7` (*"S3-HU02-T18: sidebar unificada en login"*), `App.vue` renderizaba condicionalmente dos navegaciones completamente distintas: `<NavBar v-if="!isLoggedIn">` (barra superior clásica) para el estado deslogueado, y `<SideBar v-if="isLoggedIn">` para el estado logueado — es decir, la pantalla de login tenía una identidad visual distinta al resto de la app. El fix elimina el `v-if` de `SideBar` (ahora se monta siempre) y le agrega una prop `logueado` que controla qué ítems de navegación mostrar (links a Ventas/Inventario/Productos/Admin si está logueado, sólo "Ingresar" si no). `Login.vue` dejó de tener su propia barra de navegación: ahora vive dentro del layout general de `App.vue` y comparte la sidebar con el resto del sitio. `NavBar.vue` quedó sin ningún import activo tras este cambio (ver "Hallazgos").

## Preguntas de estudio

1. **¿Por qué fallaban las ventas con una violación de FK antes del hotfix, aunque el login y la autenticación "funcionaban bien"?** Explicá la diferencia entre "el JWT es válido" y "el `user_id` del JWT está disponible para el handler", y por qué ambas cosas no son lo mismo en Go con `context.Context`.
2. En `middleware/auth_middleware.go`, ¿qué hacía literalmente la línea `next.ServeHTTP(w, r)` antes del fix, y por qué cambiarla a `next.ServeHTTP(w, r.WithContext(ctx))` resuelve el problema? ¿Qué es `context.WithValue` y por qué se necesita un tipo custom (`authContextKey`) en vez de usar un `string` plano como key?
3. El campo `id_vendedor` sigue existiendo en `models.CreateVentaRequest` y en el JSON que en teoría podría mandar el cliente. ¿Por qué eso ya no es un problema de seguridad después del fix? ¿Qué pasaría si un usuario malicioso mandara `id_vendedor: 5` en el body de la petición hoy?
4. Explicá el patrón de "delete inteligente" en `ProveedorService.Delete` y `UsuarioService.Delete`: ¿qué decide si se ejecuta un soft-delete o un hard-delete, y por qué el servicio necesita leer el registro (`GetByID`) antes de decidir?
5. En `InventarioRepository.RenameUbicacion` y `DeleteUbicacion`, ¿por qué es necesario envolver la operación en una transacción SQL? ¿Qué pasaría si el `UPDATE` de `productos.ubicacion` fallara después de haber renombrado ya la fila en `ubicaciones`?
6. ¿Por qué `productos.ubicacion` es una columna de texto libre en vez de un `id_ubicacion INTEGER REFERENCES ubicaciones(id)`? ¿Qué inconveniente concreto de diseño genera eso (pista: mirá qué tiene que hacer `RenameUbicacion` que no tendría que hacer con una FK)?
7. En `Analisis.vue`, los cálculos de ventas por mes/vendedor y el valor de inventario se hacen enteramente en el cliente, sobre datos ya traídos con `getVentas()`/`getProductos()`. ¿Qué limitación tiene ese enfoque a medida que crece el volumen de datos, y cómo lo resolverías moviendo la agregación al backend?
8. `ModalFotoPerfil.vue` dibuja el canvas recortado sobre un fondo blanco explícito antes de convertirlo a Blob. ¿Por qué es necesario ese paso si el usuario sube un PNG con transparencia y el archivo final se guarda como JPEG?
9. ¿Qué diferencia concreta de comportamiento tiene `AdminUsuariosPage.vue` respecto al resto de las vistas del proyecto en cuanto a cómo llama al backend? ¿Por qué eso no cumple la convención `views → services` documentada en el proyecto?
10. Antes del hotfix de sidebar unificada, ¿qué componentes se encargaban de la navegación en el estado logueado vs. no logueado, y qué inconsistencia visual/de UX generaba tener dos componentes distintos? ¿Qué prop nueva se le agregó a `SideBar` para resolverlo sin duplicar el componente?

## Archivos clave para repasar

- **`middleware/auth_middleware.go` + `handler/venta_handler.go`** — el fix crítico del sprint; probablemente la pregunta más profunda que te van a hacer es sobre esto.
- **`service/proveedor_service.go` / `service/usuario_service.go`** — patrón de soft-delete "inteligente", muy corto pero conceptualmente denso (repasá el flujo `GetByID → if Activo → Delete else HardDelete`).
- **`src/views/Analisis.vue`** — es el archivo más largo y visual que hiciste; repasá especialmente `cargarDatos()` y `calcularVentasPorVendedor` para poder explicar de dónde sale cada número del dashboard.
- **`repository/inventario_repository.go`** (`RenameUbicacion`/`DeleteUbicacion`) — para explicar por qué esas dos operaciones necesitan transacción y qué pasaría sin ella.
- **`src/App.vue` + `src/components/SideBar.vue`** — para el hotfix de coherencia visual del login; tené claro qué prop (`logueado`) reemplazó al `v-if` condicional de dos componentes distintos.

## Hallazgos durante la revisión

- `src/components/NavBar.vue` quedó huérfano: desde el commit `1a239b7` (sidebar unificada) ningún archivo lo importa. Sigue en el repo pero es código muerto.
- `AdminUsuariosPage.vue` usa `fetch` directo en vez de un service, violando la convención `views → services` del proyecto. Existe un `src/services/usuariosService.js`, pero fue escrito por otro integrante del equipo (autor `Apuru`) y es usado sólo por `Analisis.vue`, no por `AdminUsuariosPage.vue`.
- `docs/S3-ventas-migration.md`, `handler/ventas.go`, `middleware/context.go` y el binario `main` aparecieron en el historial de commits de Víctor pero ya no existen en el repo (fueron borrados/renombrados en refactors posteriores) — no se documentaron por no ser código actual.
- Varios scripts SQL viejos de Sprint 2 (`registro-sesiones/`, `registro-ventas/sprint2_drop_*.sql`) aparecen en su historial sólo porque los borró en un commit de limpieza (`S3-HU02-T13: limpiar scripts SQL obsoletos de sprint2`), no porque los haya escrito.
