---
tags: [proyecto/minegocio, sprint-3, procedimiento, nicolas, hu04]
---

# Procedimiento — Nicolás — HU04: Admin / Gestión de Usuarios

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU04-T01: Endpoint backend creación de usuarios `[backend]` `[database]`
**Fechas:** 2 jul → 5 jul

### ¿Qué estamos haciendo y por qué?

Hoy **no hay forma de crear usuarios** nuevos en el sistema. No queremos registro público (para que cualquiera se cree una cuenta), pero los admins necesitan poder agregar vendedores y otros admins. Vamos a crear un endpoint privado, solo para admins.

**Importante:** No existe registro público de usuarios. Solo un admin puede crear usuarios. Este es un requisito explícito.

### Pasos

1. **Crear `handler/usuario_handler.go`.** Un handler recibe la request HTTP, interpreta los datos, llama al service y devuelve la respuesta. Este handler (`CreateUsuario`) debe:
   - Requerir JWT válido (usa el middleware de auth)
   - Requerir rol "admin" (cuando Gabriel implemente `RequireRole`)
   - Leer del body: `{nombre, email, password, rol}`
   - Validar: email que no exista ya (consultar DB), password ≥ 8 caracteres, rol ∈ {"admin", "vendedor"}
   - Devolver 201 Created si todo sale bien

2. **Crear `service/usuario_service.go`.** Capa intermedia que pasa datos del handler al repository. Acá se hashea el password con bcrypt antes de guardar.

3. **Agregar método al repositorio.** En `repository/usuario_repository.go`, agregar `Create(u models.Usuario) error` que ejecute:
   ```sql
   INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES ($1, $2, $3, $4)
   ```
   El `password_hash` es el bcrypt generado en el service.

4. **Registrar la ruta.** En `routes/routes.go`:
   ```go
   router.Handle("/api/usuarios", authMiddleware.RequireRole("admin")(handler.CreateUsuario)).Methods("POST")
   ```

5. **NO crear registro público.** Nada de `POST /api/register`. Solo admins crean usuarios.

---

## 2. S3-HU04-T02: Endpoint listar usuarios para admin `[backend]`
**Fechas:** 5 jul → 7 jul

### ¿Qué estamos haciendo y por qué?

El admin necesita ver la **lista de usuarios** del sistema para gestionarlos.

### Pasos

1. En `handler/usuario_handler.go`, agregá `GetUsuarios` para `GET /api/usuarios`.

2. En repositorio, `GetAll() ([]models.Usuario, error)`:
   ```sql
   SELECT id, nombre, email, rol, creado_en, ultimo_login FROM usuarios ORDER BY id
   ```
   **Sin `password_hash`** en la consulta — ese campo nunca debe salir en una respuesta HTTP.

3. Misma protección: JWT + rol admin.

---

## 3. S3-HU04-T03: Página frontend Gestión de Usuarios `[frontend]`
**Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Una página en el frontend donde los admins puedan gestionar usuarios sin usar Postman ni la terminal.

### La página debe tener

1. **Formulario de creación:**
   - Campos: nombre, email, password, selector rol (admin/vendedor)
   - Botón "Crear usuario"
   - Validaciones antes de enviar: email con @, password ≥ 8 caracteres, ningún campo vacío

2. **Tabla de usuarios existentes:**
   - Debajo del formulario
   - Llama a `GET /api/usuarios`
   - Columnas: ID, Nombre, Email, Rol, Creado, Último login
   - Botón "Desactivar" (cambia `activo = false`, no DELETE. No se borra de la DB)

3. **Ruta en el router:**
   - `/gestion-usuarios`
   - `meta: { requiresAuth: true, role: 'admin' }` — solo admins pueden acceder

4. **Llamadas a la API:**
   - Usar `fetch` nativo (no axios)
   - Incluir header `Authorization: Bearer <token>` (reutilizar `authHeaders.js` que creó Ignacio)
