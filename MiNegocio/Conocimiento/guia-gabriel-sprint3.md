---
tags: [proyecto/minegocio, sprint-3, guia-estudio, gabriel]
created: 2026-07-10
---

# Guía de Estudio — Gabriel Flores — Sprint 3

> Nota de contexto importante: en git, Gabriel aparece con dos identidades — `GFlores <GFlores@mail.com>` (usada en la mayoría de sus commits del 2026-07-08) y `MelusineZoe <gabriel.flores.zela@alumnos.uta.cl>` (usada entre el 2026-06-16 y el 2026-06-26). Es la misma persona.
>
> Hallazgo relevante para la defensa: **casi todo el trabajo de Sprint 3 de Gabriel vive en ramas propias que nunca se fusionaron a `main`** (`S3-HU01-T01`, `S3-HU01-T02`, `S3-HU01-T06`, `S3-HU01-T07`, `S3-HU01-T09`, `S3-HU05-T02`, `S3-HU05-T03`, `S3-HU05-T04`, `S3-HU05-T05`). En varios casos un compañero (`VHerrera`) implementó de forma independiente una funcionalidad equivalente que sí llegó a `main` (ej. tabla `proveedores`, JWT_SECRET obligatorio, logging estructurado). Esto no invalida el trabajo — muestra dominio real de las capas backend y del flujo frontend — pero Gabriel debe estar preparado para explicar el estado real de integración si se lo preguntan.

## Archivos modificados

| Archivo | Repo | Qué hace |
|---|---|---|
| `src/services/authService.js` | frontend | Guarda/lee el JWT y el refresh token en `localStorage`, decodifica claims, expone `login`, `logout`, `refreshToken` |
| `src/middleware/authGuard.js` | frontend | Guard de ruta que bloquea navegación sin token válido (eliminado después, absorbido por `router.beforeEach`) |
| `src/plugins/axios.js` | frontend | Instancia de axios con interceptores para adjuntar el JWT y manejar 401 (eliminado después) |
| `src/router/index.js` | frontend | Registro de rutas `/ventas` (lazy-load + guard) y `/proveedores` |
| `src/views/VentasPage.vue` | frontend | Punto de venta: búsqueda de productos + botones de descarga de reporte PDF/Excel |
| `src/views/ProveedoresPage.vue` | frontend | Página CRUD completa de proveedores (tabla + modal) |
| `src/services/proveedorService.js` | frontend | Cliente HTTP para `/api/proveedores` (CRUD) |
| `src/views/Productos.vue` / `src/components/FormularioProducto.vue` | frontend | Intento de integrar selector de proveedor en el formulario de productos (prototipo con errores, nunca fusionado) |
| `docs/pdf.md`, `docs/testeo.md`, `docs/proveedores.md` | frontend | Documentación propia de las features de reportes y proveedores |
| `handler/reporte_handler.go`, `service/reporte_service.go` | backend | Endpoint `GET /api/reportes/ventas` que genera PDF (wkhtmltopdf) o Excel (excelize) |
| `repository/venta_repository.go` (método `GetVentasByPeriodo`) | backend | Query de ventas filtradas por rango de fechas para el reporte |
| `handler/venta_handler.go` | backend | Verificación de `user_id` autenticado antes de registrar una venta |
| `handler/proveedor_handler.go` | backend | Handlers HTTP CRUD de proveedores |
| `repository/proveedor_repository.go` | backend | Acceso SQL a la tabla `proveedores` |
| `repository/proveedor_service.go` | backend | Lógica de negocio de proveedores (mal ubicado: `package service` dentro de la carpeta `repository/`) |
| `models/models.go` | backend | Structs `Proveedor` y `CreateProveedorRequest` |
| `handler/interfaces.go`, `service/interfaces.go` | backend | Interfaces `ProveedorHandlerInterface` y `ProveedorServiceInterface` |
| `main.go`, `routes/routes.go` | backend | Wiring del repo/service/handler de proveedores; subrouter admin con `RequireRole`; middleware CORS |
| `handler/proveedor_handler_test.go`, `repository/proveedor_repository_test.go` | backend | Tests básicos de los endpoints y del repositorio de proveedores |
| `middleware/role_middleware.go` | backend | `RequireRole(...)` — middleware de autorización por rol |
| `middleware/logging_middleware.go`, `config/logger.go` | backend | Logger propio a archivo rotado diario + middleware que loguea método/ruta/status/duración |
| `service/auth_service.go`, `repository/usuario_repository.go` | backend | Migración de login de texto plano a bcrypt con validación dual (fallback temporal) |
| `config/jwt.go` | backend | `JWT_SECRET` obligatorio desde variable de entorno (sin fallback hardcodeado) |
| `scripts/migrate_bcrypt.go` | backend | Script standalone para re-hashear contraseñas existentes a bcrypt |
| `postgres/esquema.sql` | database | Tabla `proveedores` + FK `productos.id_proveedor` |
| `postgres/migrations/001_create_sesiones_table.sql`, `postgres/scripts/cleanup_sesiones.sql` | database | Tabla `sesiones` (control de tokens activos/revocados) + script de limpieza de sesiones expiradas |

## Arquitectura del código

**Backend (Go):** el proyecto sigue capas `handler → service → repository → models`, con wiring centralizado en `main.go` y rutas en `routes/routes.go` (usa `gorilla/mux`). Gabriel replicó correctamente este patrón para la feature de proveedores: `proveedor_repository.go` (SQL puro con `database/sql`), un service que orquesta ese repositorio, un handler que decodifica JSON y responde HTTP, e interfaces (`ProveedorHandlerInterface`, `ProveedorServiceInterface`) para desacoplar capas — mismo patrón que ya existía para `producto` y `venta`. El detalle a notar: su `proveedor_service.go` quedó físicamente dentro de la carpeta `repository/` aunque declara `package service`, lo cual compila (el nombre de carpeta no tiene que coincidir con el package en Go) pero rompe la convención de organización del resto del proyecto.

Su trabajo de autenticación (`config/jwt.go`, `service/auth_service.go`, `repository/usuario_repository.go`) tocó el corazón del módulo de auth que ya existía (JWT con `golang-jwt/jwt/v5`, claims con `user_id`/`nombre`/`rol`). Se conecta con `middleware/auth_middleware.go` (no modificado por él, pero consume `config.JWTSecret` y `config.Claims` que sí tocó) y con `middleware/role_middleware.go` (sí escrito por él), que se usa como middleware de mux (`admin.Use(middleware.RequireRole("admin"))`) para restringir rutas de escritura de productos y proveedores a rol admin.

En el **frontend (Vue 3, Options API)**, el patrón es `views/ → services/ → llamadas fetch/axios a /api/...`. `authService.js` centraliza todo lo relacionado a JWT (guardar, decodificar, refrescar) y es consumido tanto por `router/index.js` (guard `beforeEach`) como por componentes. `proveedorService.js` sigue el mismo patrón que `productosService.js`/`ventasService.js` ya existentes: un objeto con métodos `getAll/create/update/delete` que llaman a `/api/proveedores`. `ProveedoresPage.vue` es una página CRUD estándar del proyecto (tabla + modal, sin librería de formularios externa).

**Database:** las migraciones en `postgres/esquema.sql` y `postgres/migrations/` siguen convención SQL plano (no hay ORM); Gabriel agregó la tabla `proveedores` con índices y una FK `ON DELETE SET NULL` hacia `productos`, y una tabla `sesiones` para trackear tokens activos/revocados (pensada para complementar el JWT con revocación en servidor, algo que el JWT stateless por sí solo no permite).

**Relación con el resto del equipo:** ninguna de estas ramas llegó a fusionarse a `main`. En paralelo, `VHerrera` implementó una tabla `proveedores` más simple (sin los campos de fecha/índices/comentarios de Gabriel) y una versión de JWT_SECRET obligatorio y logging estructurado (`log/slog` en vez del logger a archivo de Gabriel) que sí están en `main` hoy. Es decir, la arquitectura y el enfoque de Gabriel eran correctos, pero el trabajo quedó duplicado por falta de integración de ramas.

## Explicación por archivo

### `src/services/authService.js`
Módulo sin clase que expone funciones puras para manejar el ciclo de vida del JWT en el cliente: `login()` hace `POST /api/login` y guarda `token`/`refresh_token` en `localStorage`; `getToken()`/`isTokenExpired()` usan `jwt-decode` para leer el campo `exp` del token y compararlo con `Date.now()`; `refreshToken()` llama a `POST /api/auth/refresh` y si falla fuerza `logout()` + redirección a `/login`. Es el archivo que sentó las bases del manejo de sesión en el frontend — el archivo actual conserva exactamente estas funciones (con agregados posteriores de otros compañeros para foto de perfil), lo que confirma que este diseño sobrevivió como la solución final de autenticación del frontend.

### `src/middleware/authGuard.js` y `src/plugins/axios.js` (eliminados en Sprint 3, tarea de limpieza de otro integrante)
`authGuard.js` era un guard de ruta clásico de vue-router (`(to, from, next) => ...`) que redirigía a `/login` si no había token válido. `axios.js` creaba una instancia de axios con `baseURL: '/api'` y dos interceptores: uno de request que refresca el token si está expirado antes de adjuntarlo en `Authorization`, y uno de response que fuerza logout ante un 401. Ambos archivos fueron borrados por el commit `a385491` ("HU01-T05: elimina HelloWorld.vue, middleware/, plugins/... App.vue usa authService.logout()") de otro integrante, que consolidó esa lógica directamente en `router/index.js` (el `router.beforeEach` que existe hoy es funcionalmente el sucesor de `authGuard.js`). Importante: aunque el archivo ya no existe, la lógica que proponía sí quedó viva en el router actual.

### `src/router/index.js`
El router actual centraliza rutas con `meta: { requiresAuth, requiresAdmin }` y un único `router.beforeEach` que reemplaza los guards por-ruta. Gabriel contribuyó dos cosas puntuales: (1) el cambio de `/ventas` a carga diferida (`component: () => import(...)`) con `beforeEnter: authGuard`, y (2) el registro de la ruta `/proveedores` apuntando a `ProveedoresPage.vue` con lazy import. Ninguno de los dos commits llegó a `main`; la ruta de proveedores que existe hoy en producción es `/admin/proveedores` → `AdminProveedoresPage.vue`, agregada por otro integrante.

### `src/views/VentasPage.vue`
Vista de punto de venta con buscador de productos (`fetch` directo a `/api/productos/buscar` con el token del `localStorage`) y un carrito manejado por el componente hijo `CarritoCompras`. Gabriel agregó dos botones (`descargarReporte('pdf')` / `descargarReporte('xlsx')`) que hacen `window.location.href = /api/reportes/ventas?formato=...&desde=...&hasta=...` para forzar la descarga del archivo generado por el backend. Detalle técnico: el método usa `this.desde`/`this.hasta`, que no existen en `data()` — el archivo compila igual porque Vue no valida propiedades inexistentes en tiempo de compilación, pero en ejecución esos valores serían `undefined`. Esta versión vive solo en la rama `S3-HU01-T09` y nunca se fusionó.

### `src/views/ProveedoresPage.vue` y `src/services/proveedorService.js`
Página CRUD completa: tabla con columnas nombre/RUT/email/teléfono/dirección/estado, y un modal reutilizado tanto para crear como editar (controlado por la bandera `editando`). `proveedorService.js` expone `getAll/getByID/create/update/delete`, todos apuntando a `/api/proveedores`, replicando el patrón ya usado por `productosService.js`. Es un CRUD frontend correcto y completo. Vive en la rama local `S3-HU05-T03` y nunca llegó a `main`; el commit `3c64f36` ("integrar AdminProveedoresPage + proveedoresService — rescate puntual de HU05-T03") de otro integrante tomó ideas de este trabajo para crear `AdminProveedoresPage.vue`, la página que sí está en producción hoy.

### `src/views/Productos.vue` / `src/components/FormularioProducto.vue` (rama `S3-HU05-T05`, prototipo no fusionado)
Intento de agregar un selector de proveedor al formulario de creación/edición de productos. Contiene errores reales que vale la pena poder explicar: en `Productos.vue` se declara `form: { id_proveedor: null }` como una **segunda** clave `form` dentro del mismo objeto `data()` (la primera ya existía con los campos del producto) — en JavaScript, cuando un objeto literal repite una clave, la última sobrescribe a la anterior, así que ese cambio habría roto silenciosamente el formulario de productos existente. También se define un método llamado `mounted()` dentro de `methods: {}` esperando que se ejecute como hook de ciclo de vida — no ocurre, porque Vue solo reconoce `mounted` como hook si está declarado al nivel superior del componente, no dentro de `methods`. En `FormularioProducto.vue` el `<select>` de proveedor se agrega correctamente cargando `proveedores` en el hook `mounted()` real. Ninguno de estos cambios llegó a `main`; la integración de proveedor que sí funciona en producción (`FormularioProducto.vue` actual, líneas ~45-51) fue escrita enteramente por `VHerrera`.

### `handler/reporte_handler.go` y `service/reporte_service.go`
Handler que atiende `GET /api/reportes/ventas?formato=pdf|xlsx&desde=...&hasta=...`, delega a `ReporteService`, y según el formato responde con `Content-Type` de PDF o de Excel más el `Content-Disposition: attachment`. El service llama a `ventaRepo.GetVentasByPeriodo()` y arma el PDF invocando el binario externo `wkhtmltopdf` vía `exec.Command` (pasándole el HTML del reporte por stdin) o arma un Excel con la librería `excelize`. Punto clave para la defensa: **tal como está escrito, este archivo no compila** — usa `exec.Command`, `strings.NewReader` y `excelize.NewFile()` sin importar `os/exec`, `strings` ni `github.com/xuri/excelize/v2` (el bloque `import` solo trae `bytes`, `time` y `backend-dev/repository`). Es evidentemente un prototipo escrito para documentar el diseño de la feature (ver `docs/pdf.md`), no código productivo terminado. Vive únicamente en la rama `S3-HU01-T09`.

### `repository/venta_repository.go` (método `GetVentasByPeriodo`) y `handler/venta_handler.go`
`GetVentasByPeriodo(desde, hasta time.Time)` agrega una query nueva sobre la tabla `ventas` (distinta de `registro_ventas`, que es la que usa el resto del repositorio) filtrando por rango de fechas — mismo problema de compilación: el archivo no importa `"time"` pese a usar el tipo `time.Time` en la firma. En `venta_handler.go`, el cambio agrega una verificación de que exista un `user_id` en el contexto de la petición (autenticado) antes de crear la venta, llamando a `middleware.GetUserID(r)`. La firma real de `GetUserID` en `middleware/auth_middleware.go` es `GetUserID(ctx context.Context) (int, bool)` — recibe un contexto y devuelve dos valores; el código de Gabriel la llama con `r` (el `*http.Request`) y espera un solo valor `int`, lo que tampoco compila. Es representativo del mismo patrón: la intención (validar que el vendedor sea el usuario autenticado) es correcta y necesaria, la implementación quedó a nivel de boceto.

### `repository/proveedor_repository.go`, `handler/proveedor_handler.go`, `repository/proveedor_service.go`
Este es el trío más sólido y completo de su trabajo de Sprint 3. El repository hace `INSERT/SELECT/UPDATE` directos con `database/sql` y placeholders `$1..$n`, y el `Delete` es un **soft delete** (`UPDATE proveedores SET activo = false`), consistente con el resto del sistema (productos también usa soft delete). El handler decodifica JSON con `json.NewDecoder(r.Body).Decode(&req)`, usa `mux.Vars(r)["id"]` para leer el `{id}` de la URL (aunque el archivo no importa `gorilla/mux`, otro problema de compilación) y devuelve siempre `{"status": "...", "mensaje": "..."}`, igual que los demás handlers del proyecto. El service es una capa delgada que solo reenvía llamadas al repository — patrón intencional para mantener testeable el handler vía interfaces.

### `models/models.go`, `handler/interfaces.go`, `service/interfaces.go`
Agregó los structs `Proveedor` (con `omitempty` en `FechaCreacion`) y `CreateProveedorRequest` (DTO de entrada, sin `ID` ni `Activo`), y las interfaces `ProveedorHandlerInterface`/`ProveedorServiceInterface` con los cinco métodos CRUD. Mismo patrón que ya existía para `ProductoServiceI` y `ProductoRepositoryI` en el archivo — separar el DTO de request del modelo de dominio, y definir interfaces para poder mockear en tests.

### `main.go`, `routes/routes.go`
En `main.go` agregó el wiring típico: `proveedorRepo := repository.NewProveedorRepository(db)` → `proveedorService := service.NewProveedorService(proveedorRepo)` → `proveedorHandler := handler.NewProveedorHandler(proveedorService)`, y lo pasó a `routes.SetupRoutes(...)`. En `routes.go` (commit `4a2eece`) además agregó un middleware CORS manual (`Access-Control-Allow-Origin: *` + manejo de `OPTIONS`) y un subrouter `admin` que aplica `middleware.RequireRole("admin")` a las rutas de creación/edición/borrado de productos y proveedores, dejando lectura y ventas accesibles a cualquier usuario autenticado vía el subrouter `protected`.

### `handler/proveedor_handler_test.go`, `repository/proveedor_repository_test.go`
Tests mínimos, no exhaustivos. El de handler monta un `mux.Router` vacío (el comentario `// ... wiring de handler` deja explícito que falta registrar la ruta real) y solo verifica que un `GET /api/proveedores` devuelva 200 — tal como está, fallaría porque el router de prueba no tiene rutas registradas. El de repository sí conecta a una base real vía `config.ConnectDB()` y prueba `Create` + `GetAll`, pero **no importa `"backend-dev/models"`** pese a usar `models.CreateProveedorRequest{...}`, otro error de compilación. Buen ejemplo de tests escritos como documentación de intención más que como suite funcional.

### `middleware/role_middleware.go`
`RequireRole(roles ...string)` devuelve un middleware de `net/http` que lee el rol del usuario (`GetUserRole(r)`) y solo deja pasar la petición si coincide con alguno de los roles permitidos; si no, responde `403 Forbidden` con JSON. Se usa encadenado a nivel de subrouter en `routes.go` (`admin.Use(middleware.RequireRole("admin"))`), un patrón estándar de `gorilla/mux` para aplicar middlewares a un grupo de rutas sin repetir código en cada handler.

### `middleware/logging_middleware.go` y `config/logger.go`
Logger propio construido sobre el paquete estándar `log`: `InitLogger()` crea (o abre) un archivo `logs/minegocio-YYYY-MM-DD.log` y configura tres loggers (`info`/`warn`/`error`) que escriben simultáneamente a archivo y a stdout vía `io.MultiWriter`. `LoggingMiddleware` envuelve cada request, mide la duración con `time.Since`, captura el status code real con un `responseWriter` custom que sobreescribe `WriteHeader`, y loguea método, ruta, status, duración e IP. Funcionalmente correcto y compila. No llegó a `main`: el mismo día, otro integrante implementó logging estructurado con el paquete estándar `log/slog` (formato JSON, niveles configurables por variable de entorno, `request_id` vía UUID en el contexto), que es la versión que quedó en producción.

### `service/auth_service.go`, `repository/usuario_repository.go` (migración a bcrypt)
Antes del cambio, `GetByCredentials` comparaba la contraseña en texto plano directamente en la consulta SQL (`WHERE ... AND password_hash = $2`). Gabriel cambió la query para traer el hash y comparar en la capa de aplicación con `bcrypt.CompareHashAndPassword`, y agregó una **validación dual** en `Login()`: primero intenta bcrypt: si falla, compara contra texto plano como fallback temporal (imprimiendo una advertencia por consola) para no romper el login de usuarios que aún no fueron migrados. Es una estrategia real de migración de contraseñas legacy sin downtime, pero el fallback en texto plano deja una ventana de tiempo donde ambas rutas de validación conviven — el punto correcto es que ese fallback debe eliminarse una vez que `migrate_bcrypt.go` corrió sobre todos los usuarios.

### `config/jwt.go` (`JWT_SECRET` obligatorio)
Reemplazó `getJWTSecret()` (que devolvía un secreto hardcodeado como fallback si no había variable de entorno — inseguro) por `LoadConfig()`, que hace `panic` si `JWT_SECRET` no está definida, forzando a que el servidor no arranque sin secreto configurado explícitamente. Efecto colateral a notar: en el mismo cambio se eliminó `GenerateRefreshToken()` (que usaba `JWTRefreshExpiration`, más largo) y se reemplazaron sus llamadas por `GenerateToken()` (que usa `JWTExpiration`, más corto) — es decir, el refresh token dejó de tener una expiración distinta y más larga que el access token, lo cual es una regresión funcional respecto al diseño original de refresh tokens.

### `scripts/migrate_bcrypt.go`
Script standalone (`package main`, se ejecuta con `go run`) que recorre `usuarios` activos, detecta si el `password_hash` ya está en formato bcrypt (chequeando el prefijo `$2a$`/`$2b$` y longitud > 60) para no re-hashear dos veces, y si no lo está, lo hashea con `bcrypt.GenerateFromPassword` y actualiza la fila. Es el complemento operativo de la migración de `auth_service.go`: uno cambia cómo se valida el login hacia adelante, el otro convierte los datos existentes.

### `postgres/esquema.sql` (tabla `proveedores`)
Agrega `CREATE TABLE proveedores` con `id SERIAL`, `rut UNIQUE`, `activo BOOLEAN DEFAULT true`, timestamps de creación/actualización, tres índices (`nombre`, `rut`, `activo`) y comentarios de documentación (`COMMENT ON TABLE/COLUMN`). Agrega también `productos.id_proveedor INTEGER` con `FOREIGN KEY ... REFERENCES proveedores(id) ON DELETE SET NULL` — decisión correcta: si se borra un proveedor, los productos asociados no se borran ni quedan con una FK inválida, solo pierden la referencia. La versión que terminó en `main` (escrita por otro integrante) es más austera: mismos campos básicos pero sin timestamps, sin índices explícitos y sin comentarios.

### `postgres/migrations/001_create_sesiones_table.sql` y `postgres/scripts/cleanup_sesiones.sql`
Tabla `sesiones` para llevar registro de tokens emitidos: `usuario_id` (FK a `usuarios`, `ON DELETE CASCADE`), `token_hash` único, `fecha_creacion`, `fecha_expiracion` y `estado` restringido por `CHECK` a `'activo'` o `'revocado'`, con índices sobre `usuario_id` y `fecha_expiracion` pensados para las dos consultas más frecuentes (sesiones de un usuario, sesiones vencidas). `cleanup_sesiones.sql` es un `DELETE` de mantenimiento que borra sesiones vencidas o revocadas — pensado para correr periódicamente (cron) y evitar que la tabla crezca indefinidamente. Es la contraparte de base de datos a una estrategia de JWT con revocación server-side, algo que un JWT puro (stateless) no soporta por sí solo.

## Preguntas de estudio

1. ¿Por qué `service/reporte_service.go` no compila tal como está en la rama `S3-HU01-T09`? Nombrá específicamente qué imports faltan y qué símbolos los necesitan.
2. En `service/auth_service.go`, explicá la validación dual bcrypt/texto plano en `Login()`. ¿Por qué existe ese fallback y qué riesgo de seguridad implica mientras esté activo?
3. ¿Qué le pasó a la expiración del refresh token en el commit de `config/jwt.go` (S3-HU01-T02)? ¿Por qué eliminar `GenerateRefreshToken()` y reusar `GenerateToken()` es un problema?
4. En `Productos.vue` (rama `S3-HU05-T05`), ¿qué pasa cuando un objeto literal de JavaScript declara la misma clave (`form`) dos veces dentro de `data()`? ¿Y por qué declarar un método `mounted()` dentro de `methods: {}` no lo convierte en un hook de ciclo de vida de Vue?
5. Explicá la diferencia entre `registro_ventas` y `ventas` como fuentes de datos en `repository/venta_repository.go`, y qué método de Gabriel introduce la segunda.
6. ¿Qué hace `middleware.RequireRole("admin")` y cómo se encadena a un subrouter de `gorilla/mux` en `routes.go` para proteger solo un subconjunto de rutas?
7. Describí el rol de la tabla `sesiones` y de `cleanup_sesiones.sql`. ¿Por qué un sistema con JWT stateless podría necesitar igual una tabla de sesiones en la base de datos?
8. ¿Por qué ninguna de las ramas de Sprint 3 de Gabriel llegó a fusionarse a `main`, y qué feature equivalente implementó otro integrante en su lugar para la tabla `proveedores` y para el JWT_SECRET obligatorio?
9. En `scripts/migrate_bcrypt.go`, ¿cómo evita el script re-hashear una contraseña que ya está en formato bcrypt?
10. ¿Por qué `repository/proveedor_service.go` compila a pesar de estar guardado dentro de la carpeta `repository/` aunque declara `package service`? ¿Qué problema de convención genera esto igualmente?

## Archivos clave para repasar

- **`repository/proveedor_repository.go` + `handler/proveedor_handler.go`** — el trabajo más completo y correcto de Sprint 3; mejor ejemplo para demostrar que entendió el patrón de capas del proyecto.
- **`service/auth_service.go` (bcrypt) + `config/jwt.go` (JWT_SECRET)** — el tema con más profundidad de seguridad; muy probable que un profesor pregunte sobre esto.
- **`service/reporte_service.go`** — tenerlo repasado para poder explicar con confianza por qué no compila y qué haría falta para terminarlo (imports, librería `excelize`, `wkhtmltopdf`).
- **`postgres/esquema.sql` (tabla proveedores)** — conecta directamente su trabajo de backend y frontend; útil para explicar el flujo end-to-end de la feature de proveedores.
- **El estado de las ramas sin fusionar** — tener clara la lista de ramas (`S3-HU01-T01/T02/T06/T07/T09`, `S3-HU05-T02/T03/T04/T05`) y poder explicar con seguridad que el diseño era correcto aunque la integración quedó pendiente.
