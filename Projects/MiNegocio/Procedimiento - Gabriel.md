---
tags: [proyecto/minegocio, sprint-3, procedimiento, gabriel]
---

# Procedimiento — Gabriel

## S3-HU01-T01: bcrypt para passwords `[backend]` `[database]` `[bugfix]`
**Fechas:** 23 jun → 27 jun

1. En `repository/usuario_repository.go`, cambiar `WHERE password_hash = $2` por una consulta que obtenga el hash y luego usar `bcrypt.CompareHashAndPassword` en service.
2. En `service/auth_service.go`, agregar `bcrypt.GenerateFromPassword` en register. El hash reemplaza al password en texto plano antes de insertar.
3. En `scripts/migrate_bcrypt.go`, leer todos los usuarios, generar bcrypt hash de cada password existente y actualizar la tabla. Ejecutar migración una sola vez.
4. Validación dual: durante la transición, intentar bcrypt verify primero; si falla, comparar texto plano (legacy). Eliminar legacy cuando todos migren.

## S3-HU01-T02: JWT_SECRET por variable de entorno `[backend]` `[bugfix]`
**Fechas:** 23 jun → 27 jun

1. En `config/jwt.go`, cambiar `var jwtSecret = os.Getenv("JWT_SECRET")` sin fallback hardcodeado.
2. Agregar verificación al inicio: si `JWT_SECRET` está vacío, hacer `log.Fatal("JWT_SECRET no está definido")`.
3. Jenkins debe inyectar la variable vía Jenkins Credentials.
4. Dev usa `.env` o export manual.

## S3-HU01-T05: Limpieza — parte Gabriel `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

1. Eliminar `src/plugins/axios.js` y dependencia `axios` de `package.json`.
2. Eliminar `src/middleware/authGuard.js`.
3. En `routes/routes.go`, eliminar alias `router.HandleFunc("/api/login", ...)`.
4. En `models/models.go`, eliminar structs `RegisterRequest` y `TokenResponse`.
5. En `config/jwt.go`, colapsar `GenerateToken` y `GenerateRefreshToken`:
   - Crear `func generateToken(userID int, nombre, rol string, exp time.Duration)`.
   - Llamarla desde ambas funciones públicas con diferentes duraciones.

## S3-HU01-T06: Control de acceso por rol — parte Gabriel `[backend]` `[frontend]` `[bugfix]`
**Fechas:** 27 jun → 2 jul

1. En `middleware/auth_middleware.go`, después de validar el JWT, extraer `user_id`, `nombre`, `rol` de los claims y ponerlos en `r.Context()` con `context.WithValue`.
2. Crear `middleware/role_middleware.go`:
   - `RequireRole(roles ...string)` que lee el rol del context y rechaza con 403 si no coincide.
3. En `routes/routes.go`, aplicar `RequireRole("admin")` en rutas CRUD productos e inventario.
4. En `handler/interfaces.go` y `service/interfaces.go`, resolver inconsistencia: unificar todos los handlers con interfaces (como AuthHandler) o eliminar interfaces no usadas.

## S3-HU01-T07: Sistema de Logs `[backend]`
**Fechas:** 2 jul → 6 jul

1. En `main.go` o un nuevo `middleware/logger.go`, crear middleware HTTP que registre: método, ruta, status, duración.
2. Escribir logs a `logs/minegocio.log` con rotación diaria (renombrar al cambiar de día).
3. Niveles: INFO (peticiones exitosas), WARN (4xx), ERROR (5xx + errores DB).
4. Usar `log` estándar de Go con writer personalizado a archivo.

## S3-HU03-T05: Reportes PDF y Excel descargables `[backend]` `[frontend]`
**Fechas:** 2 jul → 8 jul

1. Crear `GET /api/reportes/ventas?formato=pdf|xl sx&desde=&hasta=`.
2. Consultar ventas en el período con totales y top productos.
3. Para PDF: generar HTML con tabla y convertir con `wkhtmltopdf` (ya instalado en servidor). Alternativa: usar `go  pdf` si hay librería disponible.
4. Para XLSX: usar `excelize` (agregar a `go.mod`). Crear hoja con columnas: fecha, producto, cantidad, total.
5. Response: archivo descargable con `Content-Disposition: attachment`.
6. Frontend: botón de descarga en `VentasPage.vue` que llama al endpoint.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[Deuda Técnica]]
