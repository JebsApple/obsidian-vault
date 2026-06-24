---
tags: [proyecto/minegocio, sprint-3, procedimiento, hu04]
---

# Procedimiento — HU04: Admin / Gestión de Usuarios

## S3-HU04-T01: Endpoint backend creación de usuarios `[backend]` `[database]`
**Asignado:** Nicolás | **Fechas:** 2 jul → 5 jul

### ¿Qué estamos haciendo y por qué?

Hoy **no hay forma de crear usuarios** nuevos en el sistema. No queremos registro público (para que cualquiera se cree una cuenta), pero los admins necesitan poder agregar vendedores y otros admins. Vamos a crear un endpoint privado que solo los admins puedan usar.

**Importante:** No existe registro público. Solo un admin puede crear usuarios.

### Pasos

1. **Crear `handler/usuario_handler.go`.** Este handler recibe la request HTTP, parsea el body, llama al service y devuelve la respuesta. Debe:
   - Requerir JWT válido (middleware de auth)
   - Requerir rol "admin" (cuando Gabriel implemente `RequireRole`)
   - Leer del body: `{nombre, email, password, rol}`
   - Validar: email que no exista ya, password ≥ 8 chars, rol ∈ {"admin", "vendedor"}
   - Devolver 201 Created

2. **Crear `service/usuario_service.go`.** Capa intermedia que pasa datos del handler al repository. Acá se hashea el password con bcrypt antes de guardar.

3. **Agregar método al repositorio.** En `repository/usuario_repository.go`, `Create(u models.Usuario) error` que ejecute:
   ```sql
   INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES ($1, $2, $3, $4)
   ```

4. **Registrar la ruta.** En `routes/routes.go`:
   ```go
   router.Handle("/api/usuarios", authMiddleware.RequireRole("admin")(handler.CreateUsuario)).Methods("POST")
   ```

5. **NO crear registro público.** Nada de `POST /api/register`.

---

## S3-HU04-T02: Endpoint listar usuarios para admin `[backend]`
**Asignado:** Nicolás | **Fechas:** 5 jul → 7 jul

### ¿Qué estamos haciendo y por qué?

El admin necesita ver la **lista de usuarios** del sistema. Endpoint GET que devuelva todos los usuarios, sin exponer contraseñas.

### Pasos

1. En `handler/usuario_handler.go`, agregar `GetUsuarios` para `GET /api/usuarios`.

2. En repositorio, `GetAll() ([]models.Usuario, error)`:
   ```sql
   SELECT id, nombre, email, rol, creado_en, ultimo_login FROM usuarios ORDER BY id
   ```
   Sin `password_hash` en la consulta.

3. Misma protección: JWT + rol admin.

---

## S3-HU04-T03: Página frontend Gestión de Usuarios `[frontend]`
**Asignado:** Nicolás | **Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Una página en el frontend para que los admins gestionen usuarios sin usar Postman ni terminal.

### La página debe tener

1. **Formulario de creación:** nombre, email, password, selector rol (admin/vendedor), botón "Crear". Validaciones: email con @, password ≥ 8 chars, campos obligatorios.

2. **Tabla de usuarios existentes:** llama a `GET /api/usuarios`. Columnas: ID, Nombre, Email, Rol, Creado, Último login. Botón "Desactivar" (cambiar `activo = false`, no DELETE).

3. **Ruta en router:** `/gestion-usuarios` con `meta: { requiresAuth: true, role: 'admin' }`.

4. **Llamadas a API:** fetch nativo + auth headers (reutilizar `authHeaders.js` de Ignacio).

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[Propuesta Taiga Sprint 3]]
