---
tags: [proyecto/minegocio, integrante, gabriel, auth, backend]
---

# Gabriel Flores — S2-HU03: JWT + Sesiones (Autenticación)

## Tasks del S2-Post-STL-Revert-Plan

- **Backend:** Portar `config/jwt.go`, `middleware/auth_middleware.go`, `handler/auth_handler.go`, `service/auth_service.go` a la rama post-revert. NO portar archivos de reestructuración antigua.
- **Frontend:** LoginPage guarda token en localStorage, router debería tener `beforeEach` global con `meta.requiresAuth`.
- **Sesiones:** Endpoints `/api/sesiones/inicio` y `/api/sesiones/cierre`.

---

## Arquitectura general (capas)

Cuando el profe pregunte "¿en qué capa está la lógica de X?", recordar:

```
routes.go          → "acá se definen las rutas y qué middleware las protege"
middleware/        → "acá se intercepta la request antes del handler (JWT, upload)"
handler/           → "acá se parsea el HTTP request y se delega al service"
service/           → "acá está la lógica de negocio (generar tokens, hashear passwords)"
repository/        → "acá están las queries SQL"
models/            → "acá están las estructuras de datos compartidas"
```

---

## Tu Feature: JWT Auth (Backend)

### Flujo Login

```
POST /api/login (pública, sin JWT)
  → routes.go:26 → authHandler.Login
    → handler/auth_handler.go → parsea LoginRequest{user, pass}
      → service/auth_service.go → Login(user, pass)
        → repository/usuario_repository.go → GetByCredentials(user)
          → SELECT ... FROM usuarios WHERE (nombre=$1 OR email=$1) AND activo=true
        → bcrypt.CompareHashAndPassword
        → config/jwt.go → GenerateToken(claims{UserID, Nombre, Rol})
      → responde TokenResponse{status:"ok", token, refresh_token}
```

### Flujo Refresh Token

```
POST /api/auth/refresh (pública)
  → authHandler.Refresh → parsea RefreshTokenRequest
    → authService.RefreshToken(refreshToken)
      → jwt.ParseWithClaims → extrae UserID, Nombre, Rol
      → config.GenerateToken (nuevo token de acceso, mismo refresh)
```

### Archivo por archivo

#### `config/jwt.go`

```go
var JWTSecret          // clave HMAC desde JWT_SECRET env
type Claims struct {   // payload del token
    UserID, Nombre, Rol string
    jwt.RegisteredClaims  // exp, iat, issuer
}
GenerateToken()         → JWT 24h firmado HMAC-SHA256
GenerateRefreshToken()  → JWT 7 días
```

**Pregunta típica:** "¿Dónde se define la duración del token?" → `config/jwt.go`, 86400s (24h) vía `JWT_EXPIRY` env.

#### `middleware/auth_middleware.go`

```go
AuthMiddleware(next http.Handler) http.Handler
  → Extrae header "Authorization"
  → Verifica "Bearer " prefix
  → jwt.ParseWithClaims → valida firma y expiración
  → Si inválido → 401 "Token inválido o expirado"
  → Si válido → next.ServeHTTP(w, r)  // pasa al handler
```

⚠️ **Deuda técnica:** No extrae los claims (user_id, rol) para pasarlos al handler. El handler no sabe qué usuario hizo la request. El profe puede preguntar "¿cómo mejorarían esto?" → respuesta: "Extraer claims del token y ponerlos en el context de la request con `context.WithValue`."

#### `handler/auth_handler.go`

| Método | Ruta | Qué hace |
|--------|------|----------|
| `Login` | `POST /api/login` | Decodifica `LoginRequest`, llama `authService.Login`, responde token |
| `Register` | `POST /api/register` | Decodifica `RegisterRequest`, llama `authService.Register` |
| `Refresh` | `POST /api/auth/refresh` | Decodifica `RefreshTokenRequest`, llama `authService.RefreshToken` |

#### `service/auth_service.go`

Es el **único service con lógica real** (los demás son passthrough):

- **Login:** busca usuario por credenciales → bcrypt verify → genera tokens
- **Register:** bcrypt hash → insert usuario → genera tokens
- **RefreshToken:** parsea refresh token → extrae claims → genera nuevo token de acceso

#### `repository/usuario_repository.go`

```go
GetByCredentials(user) → SELECT ... WHERE (nombre=$1 OR email=$1) AND activo=true
Insert(nombre, email, passwordHash, rol) → INSERT ... RETURNING id, nombre, email, rol
```

Usa placeholders `$1`, `$2` de PostgreSQL (previene SQL injection).

---

## Tu Feature: Sesiones (Backend)

### Rutas (routes.go:51-52)

```go
protected.HandleFunc("/sesiones/inicio", sesionHandler.RegistrarInicio).Methods("POST")
protected.HandleFunc("/sesiones/cierre", sesionHandler.RegistrarCierre).Methods("POST")
```

### Flujo

```
POST /api/sesiones/inicio {id_usuario: 1}
  → SesionHandler.RegistrarInicio → parsea SesionRequest{IDUsuario}
    → sesionService.RegistrarInicio(idUsuario) → passthrough
      → sesionRepository.InsertInicio(idUsuario)
        → INSERT INTO registro_sesiones (id_usuario, inicio_sesion) VALUES ($1, NOW())

POST /api/sesiones/cierre {id_usuario: 1}
  → SesionHandler.RegistrarCierre
    → sesionService.RegistrarCierre(idUsuario)
      → sesionRepository.InsertCierre(idUsuario)
        → UPDATE registro_sesiones SET cierre_sesion=NOW()
          WHERE id_usuario=$1 AND cierre_sesion IS NULL
          ORDER BY inicio_sesion DESC LIMIT 1
```

### Models

```go
SesionRequest { IDUsuario int }
SesionItem    { ID, IDUsuario, UsuarioNombre, InicioSesion, CierreSesion }
```

---

## Tu Feature: Frontend Auth

### LoginPage.vue — ruta `/login`

```javascript
login() → fetch POST /api/login
  → guardarSesion(data) → localStorage.setItem('token', data.token)
                           localStorage.setItem('usuario', JSON.stringify({nombre, email, rol}))
  → this.$router.push('/analisis')

registrar() → fetch POST /api/register (similar)
```

**Dato clave:** No hay axios. No hay interceptors. No hay authGuard en el router. El router (`router/index.js`) **no tiene** `beforeEach` — cualquier ruta es accesible sin token. La protección visual es: NavBar oculta enlaces si no hay token (`v-if="!token"`).

### authHeaders() en services

Cada service (`ventasService.js`, `productosService.js`) tiene:

```javascript
function authHeaders() {
  const token = localStorage.getItem('token') || ''
  return { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` }
}
```

---

## Keywords para la exposición

| Pregunta del profe | Respuesta |
|---|---|
| ¿Dónde se genera el JWT? | En `config/jwt.go:GenerateToken()` |
| ¿Dónde se valida el JWT en cada request? | En `middleware/auth_middleware.go` |
| ¿Qué pasa si el token expiró? | El middleware responde 401 "Token inválido o expirado" |
| ¿Cómo se almacena la sesión? | No hay sesión del lado del servidor — es stateless JWT. Solo se registran inicio/cierre en `registro_sesiones` |
| ¿Qué protege el middleware JWT? | Todas las rutas bajo `/api` excepto `/api/login` y `/api/register` |
| ¿Cómo se enteran los handlers de quién es el usuario? | **No pueden** — el middleware no pasa los claims al context. Es deuda técnica. |
| ¿Dónde están los secretos? | `JWT_SECRET` env var, con fallback a un string hardcodeado (⚠️ cambiar en prod) |

---

## Post-Revert: qué cambió

- JWT se portó manteniendo estructura (no se mergeó `origin/S2-HU03` directamente — se portó manual)
- Se agregó refresh token endpoint (`POST /api/auth/refresh`)
- LoginPage ahora guarda token en localStorage (antes del revert, el STL-redesign tenía su propio store/auth.js)
- Sesiones son feature aparte con sus propios handler/service/repository
