---
tags: [proyecto/minegocio, sprint-3, procedimiento, ignacio, hu01]
---

# Procedimiento — Ignacio — HU01: Deuda Técnica

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU01-T05: Limpieza de código muerto (parte Ignacio) `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

En sprints anteriores quedó código que no se usa: archivos, funciones, campos en structs que nadie llama. Vamos a limpiarlos.

### Pasos

1. **Eliminar método `getVenta(id)`.** En `src/services/ventasService.js` hay un método que llama a `/api/ventas/{id}`, un endpoint que nunca existió en el backend. Si alguien lo llama, recibe 404. Borralo.

2. **Eliminar ContactoPage.** `src/views/ContactoPage.vue` y `src/styles/contacto.css` no están en el menú, no tienen ruta, nadie los usa. Eran un placeholder inicial. Borrá ambos.

3. **Eliminar campo no usado.** En `service/venta_service.go`, la struct `VentaService` tiene un campo `productRepo *repository.ProductoRepository` que nunca se usa. Solo está declarado y asignado. Borralo junto con la asignación en `NewVentaService`.

4. **Extraer authHeaders a un lugar común.** `productosService.js` y `ventasService.js` tienen la misma función `authHeaders()` que lee el token de localStorage y devuelve `{ Authorization: 'Bearer ' + token }`. Creá `src/utils/authHeaders.js` con esa función y reemplazá las versiones locales con un `import`. Si después cambia cómo se obtiene el token, se cambia en un solo lugar.

---

## 2. S3-HU01-T06: Control de acceso por rol (frontend) `[backend]` `[frontend]` `[bugfix]`
**Fechas:** 27 jun → 2 jul

### ¿Qué estamos haciendo y por qué?

En el carrito de compras, al registrar una venta, el sistema guarda quién fue el vendedor. Hoy está **hardcodeado** como `id_vendedor: 1`, o sea, todas las ventas quedan como hechas por el usuario con ID 1. Vamos a leer el ID real desde localStorage.

### Pasos

1. **Reemplazar el hardcode.** En `CarritoCompras.vue`, buscá `id_vendedor: 1` y reemplazalo por `id_vendedor: JSON.parse(localStorage.getItem('usuario')).id`.

2. **Manejar el caso sin usuario.** Si no hay usuario en localStorage (alguien llegó directo sin pasar por login), mostrá un error visible o redirigí al login. No asumas que siempre existe.

3. **Coordinar con Gabriel.** Cuando Gabriel implemente `RequireRole`, asegurate de que el `id_vendedor` que se envía coincida con el del token JWT. El backend debería compararlos.

---

## 3. S3-HU01-T08: EndPoints documentados `[backend]`
**Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

No hay ningún documento que liste los endpoints con sus parámetros y respuestas. La rúbrica lo pide y es necesario para que cualquiera entienda la API sin leer todo el código.

### Pasos

1. **Listar todos los endpoints** desde `routes/routes.go`.

2. **Por cada uno documentar:**
   - Método HTTP (GET, POST, PUT, DELETE)
   - Ruta exacta (`/api/productos`, `/api/ventas`, etc.)
   - Parámetros (query string, body JSON, headers)
   - Ejemplo de request
   - Ejemplo de response exitoso (200/201)
   - Posibles errores y sus códigos (400, 401, 404, 500)

3. **Tabla de códigos de error** del sistema.

4. **Mapa de URLs:**
   - Dev (nginx): `http://192.168.50.25:8080`
   - Prod (nginx): `http://192.168.50.25:8000`
   - Backend directo: `http://192.168.50.25:3001`

5. **Generar PDF** con el documento para entregar.

---

## 4. S3-HU01-T13: Usuario BD dedicado `[database]` `[devops]`
**Fechas:** 5 jul → 7 jul

### ¿Qué estamos haciendo y por qué?

Hoy la aplicación se conecta a PostgreSQL con el usuario `postgres` (el superusuario). Esto es mala práctica: si alguien explota una vulnerabilidad en la app, tiene acceso total a la base de datos. Vamos a crear un usuario `minegocio` con permisos solo para lo que necesita.

### Pasos

1. **Crear el usuario en PostgreSQL:**
   ```sql
   CREATE USER minegocio WITH PASSWORD 'una-clave-segura';
   GRANT CONNECT ON DATABASE minegocio TO minegocio;
   GRANT USAGE, SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO minegocio;
   ```

2. **Actualizar variables de entorno.** Cambiar `DB_USER=postgres` por `DB_USER=minegocio` y `DB_PASSWORD=una-clave-segura` en:
   - Desarrollo local (`.env` o export)
   - Jenkins (Jenkins Credentials)
   - Servidor de producción

3. **Documentar en README.** Agregar el paso de creación del usuario en las instrucciones de configuración de la base de datos.
