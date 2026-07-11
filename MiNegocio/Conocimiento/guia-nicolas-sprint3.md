---
tags: [proyecto/minegocio, sprint-3, guia-estudio, nicolas]
created: 2026-07-10
---

# Guía de Estudio — Nicolás Valdés — Sprint 3

> Autor en git: `NValdes <NValdes@mail.com>`. Sus commits en `proyecto/minegocio-backend` y `proyecto/minegocio-database` corresponden mayormente a **Sprint 2** (HU01 lector de código de barras, HU03 vista de inventario), y en `proyecto/minegocio-frontend` a **Sprint 2** (`ProductosPage.vue`) y **Sprint 3** (HU04 gestión de usuarios, Tarea #86). Se documentan todos porque forman una línea de trabajo coherente y son la base conceptual de código que sigue vivo hoy.
>
> **Dato importante para la defensa**: no todo lo que programó llegó a `main`. El endpoint de búsqueda por código de barras (Tarea #48) y la migración SQL de índice/constraint (Tarea #49) quedaron en ramas (`S2-HU01`, `S2-HU01-BD-indice-y-constraint-en-campo-codigo-de-barras`) que nunca se fusionaron. En cambio, su módulo de Gestión de Usuarios (Tarea #86, frontend) y el andamiaje inicial del CRUD de usuarios (backend, Tareas #84/#85) sí están en `main`, aunque el backend fue extendido después por un hotfix de otro compañero (soft-delete, reactivar, foto de perfil, fix de bcrypt).

## Archivos modificados

| Archivo | Repo | Qué hace |
|---|---|---|
| `src/views/AdminUsuariosPage.vue` | frontend | Vista de administración de usuarios: formulario de alta + tabla de usuarios registrados. En `main`. |
| `src/router/index.js` | frontend | Registra la ruta `/gestion-usuarios` protegida por rol admin. En `main`. |
| `src/views/ProductosPage.vue` (hoy renombrada/refundida en `src/views/Productos.vue` + `src/components/FormularioProducto.vue`) | frontend | UI de alta/edición de productos con lector de código de barras (auto-detección de duplicados, autofoco). Su lógica de escaneo sigue viva en `FormularioProducto.vue`. |
| `handler/usuario_handler.go` | backend | Controlador HTTP de usuarios: listar (`GetUsuarios`) y crear (`CreateUsuario`) con validaciones. Base del archivo actual en `main` (extendido después por otro integrante). |
| `service/usuario_service.go` | backend | Capa de negocio de usuarios: hash de contraseña con bcrypt antes de persistir. |
| `repository/usuario_repository.go` | backend | Acceso a datos de usuarios: `GetAll`, `Create` (incluía chequeo de email duplicado). |
| `handler/interfaces.go` / `service/interfaces.go` | backend | Contratos `UsuarioServiceI` / `UsuarioRepositoryI` que desacoplan handler-service-repository. |
| `routes/routes.go` | backend | Registro de `GET/POST /api/usuarios` en el router de `gorilla/mux`. |
| `handler/producto_handler.go`, `service/producto_service.go`, `repository/producto_repository.go` | backend | Endpoint `GetProductoPorCodigo` / `GetByCodigoBarras` (Tarea #48) — búsqueda de producto por código de barras con validación regex y SQL parametrizado. **No está en `main`.** |
| `main.go` | backend | Versión monolítica temprana: endpoints `GET /api/inventario` y `PATCH /api/inventario/{id}` (Tareas #27/#28) sobre la vista `inventario_view`, más fix de un bug de `null` en JSON. Reemplazado luego por la arquitectura en capas. |
| `inventario_view.sql` | database | Vista SQL calculada que clasifica productos en Normal/Bajo/Agotado según stock (Tarea #27, HU03). **Está en `main`.** |
| `lector-codigo-barras/sprint2_create_lector_codigo.sql` + `sprint2_drop_lector_codigo.sql` | database | Migración (y su rollback) que agrega `NOT NULL` + `UNIQUE` + índice B-Tree sobre `productos.codigo_barras` (Tarea #49). **No está en `main`.** |

## Arquitectura del código

**Backend (Go):** el proyecto sigue capas `handler → service → repository → models`, con interfaces (`handler/interfaces.go` para lo que el handler espera de un service; `service/interfaces.go` para lo que el service espera de un repository) que permiten mockear en tests e inyectar dependencias desde `main.go`. Nicolás construyó el módulo de usuarios siguiendo exactamente este patrón: `UsuarioRepository` (SQL crudo con `database/sql`) implementa `UsuarioRepositoryI`; `UsuarioService` lo envuelve y le agrega la regla de negocio (hashear contraseña con bcrypt antes de guardar); `UsuarioHandler` traduce HTTP↔JSON y aplica validaciones perimetrales (campos vacíos, longitud de password, rol válido) antes de llamar al service. `main.go` conecta todo (`repository.NewUsuarioRepository(db)` → `service.NewUsuarioService(...)` → `handler.NewUsuarioHandler(...)`) y `routes/routes.go` cablea las URLs. Este mismo patrón es el que usan `producto_handler.go`/`producto_service.go`/`producto_repository.go`, que Nicolás también tocó para agregar la búsqueda por código de barras.

Su trabajo más temprano (main.go, Tareas #27/#28) es anterior a esta arquitectura en capas: en ese momento todo el backend vivía en un único `main.go` con handlers como funciones que reciben `*sql.DB` por clausura. Ese código fue completamente reemplazado cuando el equipo migró a la estructura `handler/service/repository/models` (se ve en el historial: `handlers/productos.go` y luego `main.go` monolítico fueron borrados). Es útil que lo tenga claro para la presentación: la vista SQL `inventario_view` que él creó en la base de datos sigue viva, pero los endpoints que la consumían en el `main.go` viejo fueron reescritos como `InventarioHandler/Service/Repository` por otro integrante.

**Frontend (Vue 3):** `views/` consumen `services/` (no `fetch` directo, salvo en código antiguo como el `ProductosPage.vue` original de Nicolás, que sí hacía `fetch` directo — un patrón que el equipo luego migró a `services/productosService.js`, ver commit `S3-HU02-T06: migrar fetch() directos a servicios`). `AdminUsuariosPage.vue`, en cambio, ya sigue la convención vigente hoy: usa `getToken()` de `services/authService.js` para adjuntar el JWT en cada `fetch`, y usa el modal inyectado (`this.$modal.confirm`) en vez de `confirm()` nativo del navegador. La ruta `/gestion-usuarios` que registró en `router/index.js` está protegida por el guard global `router.beforeEach`, que verifica `to.meta.requiresAuth` y `to.meta.requiresAdmin` contra el rol decodificado del JWT (`getUserFromToken()?.rol !== 'admin'`).

**Base de datos:** `inventario_view.sql` es una vista derivada (`CREATE OR REPLACE VIEW`) sobre la tabla `productos`, no una tabla nueva — el criterio de negocio (umbral de stock Normal/Bajo/Agotado) vive en SQL, no en el backend Go, y por eso el backend solo hace `SELECT` sobre `inventario_view` en vez de recalcular el estado en Go.

## Explicación por archivo

### `src/views/AdminUsuariosPage.vue`
Vista Vue (Options API) que implementa el módulo de Gestión de Usuarios (Tarea #86, HU04). Reemplazó una vista placeholder ("en desarrollo"). Tiene dos bloques: un formulario de alta (`form.nombre`, `email`, `password`, `confirmPassword`, `rol`) con validación 100% en el cliente antes de pegarle al backend (campos vacíos, `email.includes('@')`, `password.length < 8`, `password !== confirmPassword`), y una tabla que lista usuarios vía `GET /api/usuarios` con el header `Authorization: Bearer <token>` obtenido de `getToken()` (`services/authService.js`). El botón de baja llama a `DELETE /api/usuarios/{id}` (que en el backend hace soft-delete si el usuario está activo, o hard-delete si ya estaba inactivo — ver `usuario_service.go` → `Delete`), y hay un botón de reactivar que pega a `PATCH /api/usuarios/{id}/reactivar`. Antes de desactivar/reactivar usa `this.$modal.confirm(...)` (modal propio inyectado por `inject: ['$modal']`, no `window.confirm`).

La versión final que Nicolás dejó en su último commit ya no tiene comentarios de "reutilizando estructura de Productos" (los limpió él mismo en un commit de refactor de comentarios). El botón de reactivar (`reactivarUsuario`) y el uso de `capitalizar` de `utils/texto` fueron incorporados en el mismo lote de commits suyos del 8 de julio.

### `src/router/index.js`
Define las rutas de la SPA con `vue-router` y un guard global (`router.beforeEach`) que redirige a `/login` si la ruta requiere auth y no hay token válido, o a `/` si requiere rol admin y el usuario no lo tiene. Nicolás agregó la ruta `/gestion-usuarios` apuntando a `AdminUsuariosPage.vue` con `meta: { requiresAuth: true, requiresAdmin: true, role: 'admin' }`. Dato curioso para la defensa: en su primer intento (`fc74d443`) importó un componente `GestionUsuarios.vue` que **no existía** en el proyecto; en su siguiente commit (`29b9d9c`) se autocorrigió y apuntó la ruta al componente real, `AdminUsuariosPage.vue`. Es un buen ejemplo de iteración rápida y de por qué conviene correr el build antes de commitear.

### `src/views/ProductosPage.vue` (código histórico — hoy vive fusionado en `Productos.vue` + `FormularioProducto.vue`)
Este archivo ya no existe con ese nombre: el equipo lo renombró a `Productos.vue` y luego lo separó en componentes (`BuscadorProductos`, `GaleriaProductos`, `FormularioProducto`) en refactors posteriores no autorados por Nicolás. Pero su contenido técnico sigue siendo relevante porque ahí implementó el flujo de **lector de código de barras** (Sprint 2, HU01): un input con `ref="codigoInput"` que recibe el disparo de la pistola lectora (el lector emite el código y un Enter), capturado con `@keyup.enter="procesarEscaneo"`. `procesarEscaneo()` hace: (1) `trim()` del código para descartar espacios basura del lector, (2) valida con regex `^\d+$` que sea solo dígitos, (3) busca si el código ya existe en el array local de productos — si existe, precarga el formulario en modo edición y muestra una alerta naranja de "código duplicado"; si no existe, limpia el formulario dejando el código cargado para alta rápida y muestra una alerta verde. También forzaba el foco de vuelta al input del scanner con `$nextTick` + `this.$refs.codigoInput.focus()` para no tener que clickear entre lecturas.

Esa misma lógica (`procesarEscaneo`, el `ref="codigoInput"`, el mensaje de "duplicado") está hoy, casi textual, en `src/components/FormularioProducto.vue` — prueba de que aunque el archivo fue reestructurado, la funcionalidad que él diseñó sigue en producción.

### `handler/usuario_handler.go`
Controlador HTTP (capa de transporte) para usuarios. `GetUsuarios` delega a `usuarioService.GetAll()` y devuelve 200 con el JSON. `CreateUsuario` decodifica el body a un struct anónimo (`Nombre`, `Email`, `Password`, `Rol`) y aplica tres validaciones antes de llamar al service: campos no vacíos, contraseña ≥ 8 caracteres, y rol restringido a `"admin"` o `"vendedor"` (si no, 400). Solo si todo pasa llama a `usuarioService.Create(...)` y devuelve 201. El archivo actual en `main` agregó después (no por Nicolás) `UploadFotoUsuario`, `DeleteUsuario` y `ReactivarUsuario`, pero mantiene exactamente la misma firma y estilo que él estableció (`w.Header().Set("Content-Type", ...)`, `json.NewEncoder(w).Encode(map[string]string{"status": ..., "mensaje": ...})`).

### `service/usuario_service.go`
Capa de negocio: `Create(nombre, email, password, rol)` usa `bcrypt.GenerateFromPassword` con `bcrypt.DefaultCost` para hashear la contraseña **antes** de pasarla al repository — el repository nunca ve la contraseña en texto plano. `GetAll()` es un simple passthrough al repositorio. Es el punto donde se decidió meter la lógica criptográfica (no en el handler, para no acoplar HTTP con seguridad; no en el repository, para no acoplar SQL con reglas de negocio).

### `repository/usuario_repository.go`
Acceso a datos con `database/sql` puro (sin ORM). La versión de Nicolás implementaba `Create` verificando primero con `SELECT EXISTS(...)` si el email ya existía, devolviendo un error de negocio (`"el correo electrónico ya se encuentra registrado"`) antes de intentar el `INSERT`. Su `GetByCredentials` original (heredado del archivo, no escrito por él) tenía un bug de seguridad real: comparaba `password_hash = $2` contra la contraseña en texto plano recibida del login, con un `// TODO: aplicar hash a la contraseña antes de comparar` — es decir, el login nunca hasheaba nada. Ese bug fue corregido después (no por Nicolás) usando `bcrypt.CompareHashAndPassword`. Vale la pena que lo tenga presente porque es un ejemplo real de deuda técnica detectada en el propio código que tocó.

### `handler/interfaces.go` y `service/interfaces.go`
Centralizan los contratos de la arquitectura en capas. Nicolás agregó `UsuarioServiceI` (lo que el handler necesita del service: `GetAll`, `Create`) en `handler/interfaces.go`, y `UsuarioRepositoryI` (lo que el service necesita del repository) en `service/interfaces.go`. Esto es lo que permite testear `UsuarioHandler` con un mock de `UsuarioServiceI` sin tocar la base de datos real.

### `routes/routes.go`
Registra `GET /api/usuarios` y `POST /api/usuarios` envueltos en `middleware.AuthMiddleware`, siguiendo la misma simetría que las rutas de productos/ventas/inventario ya existentes. Cambió la firma de `SetupRoutes` para recibir `*handler.UsuarioHandler` como parámetro adicional (inyección de dependencias desde `main.go`).

### `handler/producto_handler.go`, `service/producto_service.go`, `repository/producto_repository.go` (Tarea #48 — rama sin fusionar)
Implementó `GetProductoPorCodigo` (handler) → `GetByCodigoBarras` (service) → `GetByCodigoBarras` (repository), replicando el patrón de capas para exponer `GET /api/productos/codigo/{codigo}`. El handler sanitiza con `strings.TrimSpace`, valida con regex `^\d+$`, y distingue `sql.ErrNoRows` (404) de otros errores (500), con logging de auditoría vía `log.Printf`. El repository usa `QueryRow` parametrizado (`$1`) para evitar SQL injection. **Este código no llegó a `main`**: vive solo en las ramas `S2-HU01` / `#48-S2-HU01`. El `producto_handler.go` actual en `main` no tiene este método — la búsqueda por código de barras hoy se resuelve distinto, vía el endpoint genérico `BuscarProductos` (`q ILIKE` sobre nombre o código).

### `main.go` (versión histórica, Tareas #27/#28)
Antes de la arquitectura en capas, todo el backend era este único archivo. Nicolás agregó ahí `GET /api/inventario` (consulta `inventario_view` con un `JOIN` a `productos` para filtrar solo activos) y `PATCH /api/inventario/{id}` (actualiza `stock`, validando que no sea negativo). También corrigió un bug real: `getProductosHandler` devolvía `null` en JSON cuando no había productos porque el slice de Go quedaba en su valor cero (`nil`); lo cambió a `productos := []Producto{}` para que serialice como `[]` — un bug clásico de Go/JSON que rompía el frontend si iteraba sobre `null`. Todo este archivo fue reemplazado luego por la estructura `handler/service/repository`, pero el bug fix y el diseño de los dos endpoints de inventario son su aporte original.

### `inventario_view.sql`
Vista SQL (`CREATE OR REPLACE VIEW inventario_view AS SELECT id, nombre, stock, CASE ... END AS estado FROM productos`) que clasifica cada producto en `'Normal'` (stock ≥ 5), `'Bajo'` (1–4) o `'Agotado'` (0). Es la pieza de HU03 que el `main.go` viejo (y hoy el `InventarioHandler` en capas) consulta directamente con `SELECT * FROM inventario_view`, delegando la regla de negocio del umbral de stock a SQL en vez de calcularla en Go.

### `lector-codigo-barras/sprint2_create_lector_codigo.sql` / `sprint2_drop_lector_codigo.sql` (Tarea #49 — rama sin fusionar)
Migración (con su rollback simétrico) que agrega tres cosas sobre `productos.codigo_barras`: `NOT NULL` (impide códigos vacíos), `UNIQUE` vía constraint (`uq_productos_codigo_barras`, impide códigos repetidos) y un índice B-Tree (`idx_productos_codigo_barras`) para que la búsqueda por código sea rápida. El drop hace exactamente lo inverso en orden seguro (primero el índice, luego el constraint, luego el `NOT NULL`). Es el complemento natural de `GetByCodigoBarras` (backend) y `procesarEscaneo` (frontend): sin este índice/constraint, dos productos podrían compartir código de barras. **Ojo:** el esquema vigente en `main` (`esquema.sql`) no tiene esta restricción — la tabla `productos` en producción permite hoy códigos de barras duplicados o nulos.

## Preguntas de estudio

1. En `AdminUsuariosPage.vue`, ¿por qué la desactivación de un usuario usa `DELETE /api/usuarios/{id}` en vez de un endpoint específico como `PATCH .../desactivar`? ¿Qué hace el backend según si el usuario ya estaba inactivo o no (mirar `UsuarioService.Delete`)?
2. En el router, ¿qué diferencia hay entre `requiresAuth` y `requiresAdmin` en `meta`, y qué pasa exactamente en `router.beforeEach` si un vendedor intenta entrar a `/gestion-usuarios`?
3. ¿Por qué `UsuarioService.Create` hashea la contraseña con bcrypt en la capa de **service** y no en el **handler** ni en el **repository**? ¿Qué problema traería hashearla en cualquiera de esas otras dos capas?
4. El repositorio de usuarios original tenía un `GetByCredentials` que comparaba la contraseña en texto plano contra `password_hash`. ¿Por qué eso es un bug de seguridad grave, y qué línea de código concreta lo arregla en la versión actual?
5. En `procesarEscaneo()` (lector de código de barras), ¿qué pasa si el código escaneado ya existe en el array `productos`? ¿Y si contiene letras? Explicar el flujo completo, incluyendo qué mensaje ve el usuario en cada caso.
6. ¿Por qué el `GetProductoPorCodigo` (Tarea #48) nunca se fusionó a `main`, y qué endpoint cumple hoy una función parecida (búsqueda de producto por código)?
7. ¿Qué problema concreto arreglaba el cambio de `var productos []Producto` a `productos := []Producto{}` en el `main.go` viejo? ¿Por qué un slice `nil` en Go se serializa como `null` en JSON y no como `[]`?
8. La migración `sprint2_create_lector_codigo.sql` agrega `NOT NULL` y `UNIQUE` a `codigo_barras`. Si esa migración nunca se aplicó a la base de datos de producción, ¿qué inconsistencia podría existir hoy entre dos productos con el mismo código de barras?
9. ¿Qué hace `inventario_view.sql` que no podría (o no debería) hacerse directamente en el handler de Go? ¿Qué ventaja tiene calcular el estado (`Normal`/`Bajo`/`Agotado`) en SQL en vez de en el backend?
10. En su primer commit del router agregó una ruta apuntando a un componente `GestionUsuarios.vue` inexistente. ¿Cómo se hubiera detectado ese error antes de commitear (qué comando/paso del flujo de trabajo lo habría atajado)?

## Archivos clave para repasar

- **`src/views/AdminUsuariosPage.vue`** — es el único entregable suyo 100% funcional y mergeado a `main` en Sprint 3; es lo que más probablemente le pregunten en vivo.
- **`service/usuario_service.go` + `repository/usuario_repository.go`** — para explicar bcrypt, el patrón de capas, y el bug de seguridad del login que encontró/heredó.
- **`src/router/index.js`** — para explicar el guard de rutas (`requiresAuth`/`requiresAdmin`) y el error de `GestionUsuarios.vue` que corrigió él mismo.
- **`ProductosPage.vue` / `FormularioProducto.vue` (lector de código de barras)** — aunque el archivo cambió de nombre, es su feature más elaborada técnicamente (regex, manejo de foco, detección de duplicados) y conecta directo con la migración SQL de Tarea #49.
- **`lector-codigo-barras/sprint2_create_lector_codigo.sql`** — para poder explicar por qué existe (integridad de datos) y admitir con seguridad que no está aplicada en `main` si se lo preguntan.
