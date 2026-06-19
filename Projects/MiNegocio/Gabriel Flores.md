---
tags: [proyecto/minegocio, integrante, gabriel, backend]
---

# Gabriel Flores — Backend Go (Arquitectura en Capas)

## Responsabilidad

Estructura completa del backend: configuración, inicialización, routing, handlers, servicios, repositorios, y middleware de autenticación.

## Arquitectura (flujo de una petición)

```
main.go (conexiones + wiring)
  → routes.go (gorilla/mux: qué ruta llama a qué handler)
    → middleware/auth_middleware.go (valida JWT antes de llegar al handler)
      → handler/ (recibe HTTP request, parsea JSON, llama al service)
        → service/ (lógica de negocio, orquesta repositorios)
          → repository/ (SQL queries a PostgreSQL)
            → models/ (structs de datos)
```

## Archivos a su cargo

### `main.go`

**Línea por línea:**

1. `func corsMiddleware(next http.Handler) http.Handler` — wrapper que añade headers CORS (`Access-Control-Allow-Origin: *`, métodos, headers) y maneja OPTIONS (preflight). Sin esto, el frontend en otro puerto no podría llamar al backend.
2. `db, err := config.ConnectDB()` — conecta a PostgreSQL usando variables de entorno (DB_PASSWORD es obligatoria).
3. `defer db.Close()` — cierra la conexión al terminar el programa.
4. Creación de repositorios → servicios → handlers (inyección de dependencias manual).
5. `router := routes.SetupRoutes(...)` — pasa todos los handlers al configurador de rutas.
6. `os.MkdirAll("uploads/productos", 0755)` — crea directorio para imágenes si no existe.
7. `router.PathPrefix("/uploads/").Handler(...)` — sirve archivos estáticos de imágenes.
8. `http.ListenAndServe(":"+port, h)` — inicia el servidor HTTP.

### `config/db.go`

**Línea por línea:**

1. `ConnectDB()`:
   - Lee `DB_PASSWORD` de entorno (falla si no existe — seguridad: no permite default).
   - Construye connection string con `fmt.Sprintf` usando `getEnv()` para host (default `172.17.0.1` = IP del gateway Docker), port (5432), user (postgres), dbname (cliente_dev), sslmode (disable).
   - `sql.Open("postgres", connStr)` abre la conexión (no la verifica — la verificación ocurre al primer query).

2. `getEnv(key, fallback)` — helper: si la variable de entorno existe la usa, si no usa el valor por defecto. Patrón común en Go para config 12-factor.

### `config/jwt.go`

**Línea por línea:**

1. `var JWTSecret` — clave HMAC para firmar tokens, leída de `JWT_SECRET` o default hardcodeado (⚠️ cambiar en producción).
2. `func init()` — Go ejecuta init() automáticamente al importar el paquete. Configura duración: token normal 86400s (24h), refresh 604800s (7 días), configurable vía entorno.
3. `type Claims struct` — struct con `UserID`, `Nombre`, `Rol` + `jwt.RegisteredClaims` (estándar: issuer, exp, iat).
4. `GenerateToken()` — crea token JWT firmado con HMAC-SHA256. Claims incluyen user_id, nombre, rol.
5. `GenerateRefreshToken()` — igual pero con expiración más larga (7 días).

### `handler/auth_handler.go`

**Línea por línea:**

1. `type AuthHandler struct` — almacena referencia a `AuthServiceI` (interfaz, no struct concreto — permite testing con mocks).
2. `Login(w, r)`:
   - Setea Content-Type: application/json
   - Decodifica body JSON a `LoginRequest{user, pass}`
   - Valida: si JSON inválido → 400 "Datos inválidos"
   - Llama `h.authService.Login(req.User, req.Pass)`
   - Si error → 401 "Usuario o contraseña incorrectos"
   - Si ok → encodea `AuthResponse` (token, refresh_token)
3. `Refresh(w, r)`:
   - Similar, decodifica `RefreshTokenRequest`
   - Llama `authService.RefreshToken(req.RefreshToken)`
   - Si inválido → 401

### `handler/producto_handler.go`

Contiene 7 métodos: `GetProductos`, `BuscarProductos`, `CreateProducto`, `UpdateProducto`, `DeleteProducto`, `UploadProductoImagen`, `DeleteProductoImagen`. Cada uno sigue el mismo patrón: decodificar request → validar → llamar service → responder JSON.

### `service/auth_service.go`

**Línea por línea:**

1. `Login(user, pass)`:
   - Llama `usuarioRepo.GetByCredentials(user, pass)` — busca en DB donde `(nombre = $1 OR email = $1) AND password_hash = $2`
   - Si encuentra: genera token JWT + refresh token con user info
   - Retorna `AuthResponse{status:"ok", token, refresh_token}`
2. `RefreshToken(refreshToken)`:
   - Parsea el refresh token con `jwt.ParseWithClaims`
   - Si válido: extrae claims (userID, nombre, rol)
   - Genera NUEVO token de acceso (no refresh — el refresh sigue siendo el mismo)
   - Retorna solo el nuevo token de acceso

### `service/producto_service.go`

Lógica para CRUD de productos. `GetAllActive()` filtra con `activo = true`. `BuscarProductos()` construye query dinámicamente según filtros. `SoftDeleteProducto()` hace UPDATE activo=false en vez de DELETE real.

### `repository/usuario_repository.go`

**Línea por línea:**

1. `GetByCredentials(user, pass string)`:
   - `SELECT id, nombre, email, rol, activo FROM usuarios WHERE (nombre = $1 OR email = $1) AND password_hash = $2 AND activo = true`
   - `$1` y `$2` son placeholders de PostgreSQL (evita SQL injection)
   - `OR` permite login por nombre de usuario o por email
   - `password_hash` se compara directamente (⚠️ deuda técnica: debería ser bcrypt)

### `middleware/auth_middleware.go`

**Línea por línea:**

1. `AuthMiddleware(next http.Handler) http.Handler` — patrón decorator de Go. Retorna un handler que:
   - Extrae header `Authorization`
   - Verifica que empiece con "Bearer "
   - Si no → 401 "Token requerido"
   - Extrae el token (saca "Bearer " del string)
   - Lo parsea y valida con `jwt.ParseWithClaims` usando `JWTSecret`
   - Si expiró o inválido → 401
   - Si válido → `next.ServeHTTP(w, r)` (pasa al handler real)
   - **No extrae los claims** (user_id, rol) para pasarlos al handler — solo valida existencia. ❌ Esto significa que los handlers no saben qué usuario hizo la petición.

### `models/models.go`

Define todas las structs del proyecto con sus tags JSON. Punto central de datos compartido entre handler → service → repository.

### `routes/routes.go`

**Línea por línea:**

1. `func SetupRoutes(...) *mux.Router` — recibe los 4 handlers como parámetros (inyección de dependencias desde main.go).
2. Crea `mux.NewRouter()`.
3. **Rutas públicas** (sin middleware): POST `/api/login`, POST `/api/auth/login`, POST `/api/auth/refresh`.
4. **Rutas protegidas** (con `AuthMiddleware`): todos los endpoints de productos, inventario y ventas.
5. Imagen upload tiene doble middleware: `AuthMiddleware` + `UploadMiddleware` (valida tipo MIME y tamaño).

### `middleware/upload.go`

Valida que las imágenes subidas sean JPG/PNG/WebP y ≤ 5MB usando `DetectImageMIME()` que lee los primeros bytes del archivo (magic numbers) en vez de confiar en la extensión.

## Colaboradores

- **MelusineZoe:** Implementó JWT (login, refresh, claims) sobre la estructura que Gabriel creó.
- **NValdes:** Agregó endpoints de inventario (`inventario_handler.go`, `service`, `repository`).
- **IgVml:** Agregó funciones de ventas (`venta_handler.go`, `venta_service.go`).
- **LaManzana:** Agregó tests unitarios, interfaces y Jenkinsfile.
