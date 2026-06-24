---
tags: [proyecto/minegocio, sprint-3, procedimiento, hu01]
---

# Procedimiento — HU01: Deuda Técnica y Bugfixes

## S3-HU01-T01: bcrypt para passwords `[backend]` `[database]` `[bugfix]`
**Asignado:** Gabriel | **Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Hoy el sistema guarda las contraseñas en texto plano — si alguien accede a la base de datos, ve todas las claves. Vamos a usar **bcrypt**, un algoritmo que las "hashea" (revuelve) para que no se puedan leer. Es el estándar.

### Conceptos clave

- `bcrypt.GenerateFromPassword()` — convierte texto plano en un hash irreversible. Eso se guarda en la DB.
- `bcrypt.CompareHashAndPassword()` — al iniciar sesión, compara lo que escribió el usuario contra el hash guardado, sin revelar el original.

### Pasos

1. **Cambiar la lógica de login.** Hoy el repositorio busca coincidencia exacta (`WHERE password_hash = $2`), que no sirve con bcrypt porque cada hash es distinto. En `service/auth_service.go`, primero obtené el hash con un SELECT simple, luego usá `bcrypt.CompareHashAndPassword`.

2. **Hashear al registrar.** En `service/auth_service.go`, antes de insertar, llamá a `bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)`. Lo que devuelve (ej: `$2a$10$...`) se guarda en `password_hash`.

3. **Migrar usuarios existentes.** Creá `scripts/migrate_bcrypt.go` que lea todos los usuarios, genere el hash de cada password y haga UPDATE. Se ejecuta una vez.

4. **Validación dual (opcional).** Durante la transición: intentá bcrypt primero, si falla compará texto plano. Eliminá el legacy cuando todos migren.

---

## S3-HU01-T02: JWT_SECRET por variable de entorno `[backend]` `[bugfix]`
**Asignado:** Gabriel | **Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

La clave secreta del JWT está escrita en el código. Si alguien la ve, puede falsificar tokens y hacerse pasar por cualquiera. Vamos a leerla de una variable de entorno, que es la forma correcta.

### Pasos

1. En `config/jwt.go`, cambiar por `var jwtSecret = os.Getenv("JWT_SECRET")`. Sin valor por defecto.

2. Agregar verificación: si está vacío, `log.Fatal("JWT_SECRET no está definido")`.

3. Jenkins debe inyectarla via Jenkins Credentials (encriptado).

4. Dev: `.env` o export manual en terminal.

---

## S3-HU01-T03: Docker multi-arquitectura + Pipeline Jenkins `[backend]` `[test]` `[bugfix]`
**Asignado:** Nicolás | **Fechas:** 23 jun → 30 jun

### ¿Qué estamos haciendo y por qué?

Hoy el backend se despliega a mano. Vamos a automatizarlo con Jenkins: cuando alguien haga push a `main`, Jenkins corre tests, buildca la imagen Docker y la sube al servidor. Además arreglamos el Dockerfile que no especifica arquitectura.

### Conceptos clave

- **Docker:** empaqueta la app con todo lo necesario para correr.
- **Jenkins:** robot que ejecuta tareas automáticas al detectar un push.
- **Gitea:** nuestro GitHub propio en 192.168.50.28:3000.
- **GOOS/GOARCH:** variables que le dicen a Go para qué sistema compilar.

### Pasos

1. **Arreglar Dockerfile.** En la raíz del backend, cambiar el `go build` a:
   ```dockerfile
   RUN GOOS=linux GOARCH=amd64 go build -o main .
   ```

2. **Crear/actualizar Jenkinsfile.** Etapas:
   - **Checkout:** `checkout scm`
   - **Test:** `go test ./...`
   - **Build Docker:** `docker build -t minegocio-backend:latest .`
   - **Deploy:** enviar imagen al servidor de producción

3. **Configurar webhook en Gitea.** Settings → Webhooks → URL de Jenkins + Push events.

4. **Probar.** Hacé un push a `main` y verificá que Jenkins ejecute todo sin errores y la imagen corra en producción.

---

## S3-HU01-T04: SonarQube local + Jenkins `[backend]` `[test]`
**Asignado:** Nicolás | **Fechas:** 30 jun → 4 jul

### ¿Qué estamos haciendo y por qué?

SonarQube analiza el código y encuentra bugs, código duplicado, vulnerabilidades. La rúbrica pide usarlo. Servidor en `http://192.168.50.28:9000`.

### Pasos

1. Agregar stage en Jenkinsfile para `sonar-scanner` con `sonar.projectKey=minegocio-backend`.

2. Verificar conectividad a `http://192.168.50.28:9000` con usuario `equipo6` y pass de vault.

3. Probar análisis local con `sonar-scanner`.

4. Asegurar que no hay errores bloqueantes. Si los hay, corregirlos.

---

## S3-HU01-T05: Limpieza de código muerto `[backend]` `[frontend]`
**Asignado:** Gabriel, Ignacio, Victor | **Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Quedaron archivos, funciones y variables que **no se usan**. Código muerto confunde, alarga builds y dificulta el mantenimiento. Cada uno limpia su área.

### Gabriel

1. Eliminar `src/plugins/axios.js` y `axios` de `package.json` (el frontend usa fetch nativo).

2. Eliminar `src/middleware/authGuard.js` (la protección ahora va por `meta.requiresAuth` en el router).

3. En `routes/routes.go`, eliminar el alias duplicado `/api/login`.

4. En `models/models.go`, eliminar `RegisterRequest` y `TokenResponse` si no se usan.

5. En `config/jwt.go`, colapsar `GenerateToken` y `GenerateRefreshToken` en una función privada `generateToken(userID, nombre, rol, exp)` y llamarla desde ambas.

### Ignacio

1. En `src/services/ventasService.js`, eliminar `getVenta(id)` (llama a endpoint inexistente).

2. Eliminar `src/views/ContactoPage.vue` y `src/styles/contacto.css` (página sin uso).

3. En `service/venta_service.go`, eliminar campo `productRepo *repository.ProductoRepository` (nunca se usa).

4. Extraer `authHeaders()` duplicado a `src/utils/authHeaders.js` y usarlo desde `productosService.js` y `ventasService.js`.

### Victor

1. Eliminar `src/components/HelloWorld.vue` (componente por defecto de Vue).

2. En `middleware/upload.go`, eliminar variable `var magicBytes` (no se usa).

3. Consolidar CSS de botones/badges entre `GaleriaProductos.vue` (scoped) y `src/styles/productos.css`.

4. Crear `src/utils/stockStatus.js` con `STOCK_BAJO = 4` y `getStockStatus(stock)` que devuelva "agotado"/"bajo"/"normal"/"exceso". Reemplazar lógica inline en componentes.

5. En `App.vue`, reemplazar `localStorage.removeItem(...)` duplicado por `import { logout } from './services/authService'`.

---

## S3-HU01-T06: Control de acceso por rol `[backend]` `[frontend]` `[bugfix]`
**Asignado:** Gabriel, Ignacio | **Fechas:** 27 jun → 2 jul

### ¿Qué estamos haciendo y por qué?

Hoy cualquiera con token puede hacer任何 cosa. Vamos a distinguir entre **admin** (todo) y **vendedor** (solo lectura/ventas). Gabriel hace la infraestructura backend, Ignacio aplica los cambios en ventas.

### Gabriel — Infraestructura

1. En `middleware/auth_middleware.go`, después de validar el JWT, extraer `user_id`, `nombre`, `rol` de los claims y guardarlos en `r.Context()` con `context.WithValue`.

2. Crear `middleware/role_middleware.go` con `RequireRole(roles ...string)` que:
   - Lee el rol del context
   - Si no está en la lista, responde 403
   - Si está, llama a `next.ServeHTTP(w, r)`

3. En `routes/routes.go`, aplicar `RequireRole("admin")` en rutas de crear/editar/eliminar productos.

4. Resolver inconsistencia: en `handler/interfaces.go` y `service/interfaces.go`, o todas las capas usan interfaces o ninguna.

### Ignacio — Aplicación en frontend

1. En `CarritoCompras.vue`, reemplazar `id_vendedor: 1` por `JSON.parse(localStorage.getItem('usuario')).id`.

2. Si no hay usuario en localStorage, mostrar error o redirigir a login (no asumir que existe).

3. Coordinar con Gabriel: verificar que el `id_vendedor` enviado coincida con el del token.

---

## S3-HU01-T07: Sistema de Logs `[backend]`
**Asignado:** Gabriel | **Fechas:** 2 jul → 6 jul

### ¿Qué estamos haciendo y por qué?

Hoy cuando algo falla no hay rastro. Los logs son el "diario de a bordo": registran cada request, status, duración. Sirven para diagnosticar errores y auditar el sistema.

### Pasos

1. Crear middleware HTTP (en `main.go` o `middleware/logger.go`) que registre: método, ruta, status, duración.

2. Escribir a `logs/minegocio.log` con rotación diaria (renombrar al cambiar de día).

3. Niveles: INFO (éxito), WARN (4xx), ERROR (5xx + errores DB).

4. Usar `log` estándar de Go con writer personalizado a archivo.

---

## S3-HU01-T08: EndPoints documentados `[backend]`
**Asignado:** Ignacio | **Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

No hay ningún documento que liste los endpoints con sus parámetros y respuestas. La rúbrica lo pide y es necesario para que cualquiera entienda la API.

### Pasos

1. Listar todos los endpoints desde `routes/routes.go`.

2. Por cada uno documentar: método, ruta, parámetros (query/body/headers), ejemplo request, ejemplo response (200/400/401/404/500), si requiere JWT.

3. Incluir tabla de códigos de error del sistema.

4. Incluir mapa de URLs: dev=`http://192.168.50.25:8080`, prod=`http://192.168.50.25:8000`, backend directo=`http://192.168.50.25:3001`.

5. Generar PDF con el documento.

---

## S3-HU01-T10: Quitar comentarios en inglés del código `[backend]` `[frontend]`
**Asignado:** Victor | **Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Hay comentarios en inglés y código comentado que no se borró. Criterio: si el código se explica solo, el comentario sobra. Los comentarios útiles deben estar en español.

### Pasos

1. Recorrer todo el código (frontend + backend).

2. Comentarios en inglés → español. Comentarios redundantes (explican lo obvio) → eliminar. Código comentado → eliminar.

3. Usar criterio ponytail: comentario vale cuando explica el **por qué**, no el **qué**.

4. Revisar hallazgos de [[PonytailAudit-2026-06-19]].

---

## S3-HU01-T11: Reparar READMEs del proyecto `[backend]` `[frontend]`
**Asignado:** Victor | **Fechas:** 27 jun → 30 jun

### ¿Qué estamos haciendo y por qué?

Los READMEs están desactualizados e inconsistentes (uno dice nginx, otro Docker). Son la puerta de entrada al proyecto para cualquier visitante.

### Frontend README

Descripción, stack (Vue 3, vue-router, fetch nativo), dev (`npm install` + `npm run serve`), prod (`npm run build` + copiar `dist/` a nginx), URLs.

### Backend README

Descripción, stack (Go, gorilla/mux, PostgreSQL), variables de entorno (`DB_PASSWORD`, `JWT_SECRET`), dev (`go run .`), prod (Docker build + run), URLs.

### Resolver inconsistencia

Elegir Docker como método oficial de deploy. Aclarar que nginx sirve el frontend y el backend corre en Docker aparte.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[Deuda Técnica]]
- [[PonytailAudit-2026-06-19]]
- [[Propuesta Taiga Sprint 3]]
