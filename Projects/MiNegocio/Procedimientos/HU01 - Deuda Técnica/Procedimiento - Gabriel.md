---
tags: [proyecto/minegocio, sprint-3, procedimiento, gabriel, hu01]
---

# Procedimiento — Gabriel — HU01: Deuda Técnica

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU01-T01: bcrypt para passwords `[backend]` `[database]` `[bugfix]`
**Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Hoy el sistema guarda las contraseñas en texto plano — si alguien accede a la base de datos, ve todas las claves. Vamos a usar **bcrypt**, un algoritmo que las "hashea" (revuelve) para que no se puedan leer. Es el estándar de la industria.

### Conceptos clave

- `bcrypt.GenerateFromPassword()` — convierte texto plano en un hash irreversible. Eso se guarda en la DB.
- `bcrypt.CompareHashAndPassword()` — al iniciar sesión, compara lo que escribió el usuario contra el hash guardado, sin revelar el original.

### Pasos

1. **Cambiar la lógica de login.** Hoy el repositorio usa `WHERE password_hash = $2`, que busca coincidencia exacta del texto plano. Eso no sirve con bcrypt porque cada hash es distinto (aunque el password sea el mismo). En `service/auth_service.go`, cambiala: primero obtené el hash con un SELECT simple (`SELECT password_hash FROM usuarios WHERE email = $1`), luego usá `bcrypt.CompareHashAndPassword` para verificar.

2. **Hashear al registrar.** En `service/auth_service.go`, antes de insertar un usuario nuevo, llamá a `bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)`. Lo que devuelve (un string como `$2a$10$...`) se guarda en `password_hash`. El password original nunca se almacena.

3. **Migrar usuarios existentes.** Como ya hay usuarios creados con contraseñas en texto plano, necesitás un script `scripts/migrate_bcrypt.go` que:
   - Lea todos los usuarios
   - Por cada uno, genere el hash bcrypt de su password actual
   - Haga UPDATE en la DB
   Se ejecuta una sola vez y después se elimina (o se deja comentado).

4. **Validación dual (opcional pero seguro).** Durante la transición, implementá un modo híbrido: intentá bcrypt primero; si falla, compará contra texto plano (la forma legacy). Cuando confirmes que todos migraron, eliminá el paso legacy.

---

## 2. S3-HU01-T02: JWT_SECRET por variable de entorno `[backend]` `[bugfix]`
**Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

La clave secreta del JWT está escrita en el código fuente. Si alguien la descubre, puede falsificar tokens y hacerse pasar por cualquier usuario. Vamos a leerla de una variable de entorno, que es la forma correcta de manejar secretos.

### Pasos

1. En `config/jwt.go`, cambiá la asignación por `var jwtSecret = os.Getenv("JWT_SECRET")`. **No le pongas valor por defecto** — si alguien se olvida de definirla, queremos que explote, no que use un secreto débil.

2. Agregá una verificación al inicio del programa: si `JWT_SECRET` está vacío, `log.Fatal("JWT_SECRET no está definido")`. Así el error es obvio.

3. Jenkins debe inyectar esta variable con "Jenkins Credentials" (encriptado). No la pongas en texto plano en el Jenkinsfile.

4. Para desarrollo local: usá un archivo `.env` o exportala manualmente antes de ejecutar.

---

## 3. S3-HU01-T05: Limpieza de código muerto (parte Gabriel) `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Quedaron archivos y funciones que **no se usan**. Código muerto confunde y dificulta el mantenimiento.

### Pasos

1. **Eliminar axios.** El frontend usa `fetch` nativo (el que trae el navegador). `src/plugins/axios.js` no lo importa nadie. Borrá el archivo y sacá `"axios"` de `package.json`.

2. **Eliminar authGuard.js.** `src/middleware/authGuard.js` era un intento viejo de proteger rutas. Hoy la protección se hace con `meta: { requiresAuth: true }` en el router. Borralo.

3. **Eliminar alias /api/login.** En `routes/routes.go` hay una ruta `/api/login` duplicada que apunta al mismo handler. Borrá el `router.HandleFunc("/api/login", ...)` extra.

4. **Eliminar structs no usados.** En `models/models.go`, si `RegisterRequest` y `TokenResponse` no se referencian en ningún lado, borralos.

5. **Simplificar GenerateToken/GenerateRefreshToken.** Creá una función privada `func generateToken(userID int, nombre, rol string, exp time.Duration)` y hacé que `GenerateToken` y `GenerateRefreshToken` solo la llamen con distintos parámetros. Menos duplicación = menos bugs.

---

## 4. S3-HU01-T06: Control de acceso por rol (infraestructura) `[backend]` `[frontend]` `[bugfix]`
**Fechas:** 27 jun → 2 jul

### ¿Qué estamos haciendo y por qué?

Hoy cualquiera con token puede hacer cualquier cosa. Vamos a distinguir **admin** (todo) de **vendedor** (solo lectura/ventas). Hacés la infraestructura backend para que Ignacio la use en el frontend.

### Pasos

1. **Pasar usuario al contexto.** En `middleware/auth_middleware.go`, después de validar el JWT, los claims tienen `user_id`, `nombre`, `rol`. Usá `context.WithValue()` para guardarlos en `r.Context()`. Cualquier handler o middleware después puede leerlos.

2. **Crear RequireRole.** En `middleware/role_middleware.go`, creá una función `RequireRole(roles ...string)` que:
   - Lea el rol del context (del paso 1)
   - Si no está en la lista de roles aceptados, responda 403 con mensaje claro
   - Si tiene el rol, llame a `next.ServeHTTP(w, r)` para continuar

3. **Proteger rutas.** En `routes/routes.go`, aplicá `RequireRole("admin")` en las rutas de crear, modificar y eliminar productos. Las GET quedan abiertas para admins y vendedores.

4. **Resolver interfaces.** En `handler/interfaces.go` y `service/interfaces.go`, hay interfaces a medias. Decidí: o todas las capas usan interfaces (como AuthHandler) o se eliminan las que no aportan. Lo peor es tenerlas a medias.

---

## 5. S3-HU01-T07: Sistema de Logs `[backend]`
**Fechas:** 2 jul → 6 jul

### ¿Qué estamos haciendo y por qué?

Hoy cuando algo falla no hay rastro de qué pasó. Los logs registran cada request, su resultado y duración. Sirven para diagnosticar errores y auditar el sistema.

### Pasos

1. **Crear middleware de logging.** En `main.go` o `middleware/logger.go`, creá un middleware que registre: método, ruta, código de respuesta, duración en ms, timestamp.

2. **Escribir a archivo con rotación.** Los logs van a `logs/minegocio.log`. Cuando cambie el día, renombrá el archivo a `minegocio-YYYY-MM-DD.log` y empezá uno nuevo.

3. **Niveles:** INFO (éxito 2xx), WARN (error cliente 4xx), ERROR (error servidor 5xx + DB).

4. Usá el paquete `log` estándar de Go con un writer personalizado que escriba a archivo.
