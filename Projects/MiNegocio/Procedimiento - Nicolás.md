---
tags: [proyecto/minegocio, sprint-3, procedimiento, nicolas]
---

# Procedimiento — Nicolás

## S3-HU01-T03: Docker multi-arquitectura + Pipeline Jenkins `[backend]` `[test]` `[bugfix]`
**Fechas:** 23 jun → 30 jun

1. En `Dockerfile`, agregar `GOOS=linux GOARCH=amd64` explícito en el `go build`:
   ```dockerfile
   RUN GOOS=linux GOARCH=amd64 go build -o main .
   ```
2. Crear/actualizar `Jenkinsfile` del backend:
   - Stage **Checkout**: `checkout scm`
   - Stage **Test**: `go test ./...`
   - Stage **Build Docker**: `docker build -t minegocio-backend:latest .`
   - Stage **Deploy**: `docker save ... | ssh deploy ...` (ver plantilla en Propuesta Taiga Sprint 3)
3. Configurar webhook en Gitea → Jenkins para push a `main`.
4. Verificar que el build pase en Jenkins y la imagen corra en producción (192.168.50.25).

## S3-HU01-T04: SonarQube local + Jenkins `[backend]` `[test]`
**Fechas:** 30 jun → 4 jul

1. Agregar stage opcional en `Jenkinsfile` para `sonar-scanner`.
2. Verificar conectividad: URL `http://192.168.50.28:9000`, usuario `equipo6`, pass en vault.
3. Documentar cómo ejecutar SonarQube localmente: `sonar-scanner -Dsonar.projectKey=minegocio-backend ...`.
4. Verificar que el análisis pase sin errores bloqueantes.

## S3-HU04-T01: Endpoint backend creación de usuarios `[backend]` `[database]`
**Fechas:** 2 jul → 5 jul

1. Crear `handler/usuario_handler.go`:
   - `CreateUsuario(w, r)` — handler para `POST /api/usuarios`, requiere JWT + rol admin.
   - Parsear body JSON: `{nombre, email, password, rol}`.
   - Validar: email único (consultar DB primero), password ≥ 8 chars, rol ∈ {"admin", "vendedor"}.
2. Crear `service/usuario_service.go` — passthrough con bcrypt.
3. Agregar a `repository/usuario_repository.go`:
   - `Create(u models.Usuario) error` — INSERT con bcrypt hash del password.
4. En `routes/routes.go`, registrar con middleware: `router.Handle("/api/usuarios", authMiddleware.RequireRole("admin")(handler.CreateUsuario))`.
5. NO crear endpoint público de registro.

## S3-HU04-T02: Endpoint listar usuarios para admin `[backend]`
**Fechas:** 5 jul → 7 jul

1. En `handler/usuario_handler.go`, agregar `GetUsuarios(w, r)` para `GET /api/usuarios`.
2. En repository: `GetAll() ([]models.Usuario, error)` — SELECT id, nombre, email, rol, creado_en, ultimo_login. Sin password_hash.
3. Misma protección: JWT + rol admin.

## S3-HU04-T03: Página frontend Gestión de Usuarios `[frontend]`
**Fechas:** 5 jul → 8 jul

1. Crear `src/views/GestionUsuarios.vue`:
   - Formulario: nombre, email, password, selector rol (admin/vendedor), botón crear.
   - Validaciones frontend: email con @, password mínimo 8 chars, campos obligatorios.
   - Tabla debajo con usuarios existentes (llama a GET /api/usuarios), columna acción para desactivar (cambiar activo=false, no DELETE).
2. En `src/router/index.js`, ruta `/gestion-usuarios` con `meta: { requiresAuth: true, role: 'admin' }`.
3. Llamadas a API con fetch nativo + auth headers.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[Propuesta Taiga Sprint 3]] — plantilla Jenkinsfile
- [[Cuentas Jenkins-sonarqube]]
