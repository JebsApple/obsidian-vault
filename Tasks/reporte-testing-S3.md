# Reporte de Testing — Sprint 3

## Resumen

| Rama | Estado | Bug crítico |
|------|--------|-------------|
| S3-HU01-T01 | ❌ Corregir | `>= 60` vs `> 60` en migración |
| S3-HU01-T02 | ❌ Corregir | Falta `config.LoadConfig()` en main.go |
| T01 + T02 (integración) | ✅ OK tras fix | Conflictos menores en auth_service.go |

---

## S3-HU01-T01: Migración bcrypt

### Tests ejecutados
- Compilación: ✅
- Migración de 2 usuarios: ✅
- Login post-migración: ✅

### Bug encontrado
**Archivo:** `scripts/migrate_bcrypt.go:30`
```go
if len(passHash) > 60 { // ❌ DEBE SER >= 60
```

Si el script se ejecuta **dos veces**, las contraseñas ya hasheadas se vuelven a hashear:
`"1234" → bcrypt → "$2a$10$..." (60 chars) → bcrypt → "$2b$10$..."`

El segundo hash rompe el inicio de sesión. El usuario queda bloqueado.

### Fix propuesto
```go
if len(passHash) >= 60 { // Verificar si ya es bcrypt
```

---

## S3-HU01-T02: JWT_SECRET desde variable de entorno

### Tests ejecutados
- Compilación: ✅ (con go.mod actualizado)
- Sin JWT_SECRET → panic: ✅ (tras eliminar .env)
- Login con JWT_SECRET: ✅

### Bug crítico #1
**Archivo:** `main.go`
`main()` no llama a `config.LoadConfig()`. El servidor funciona solo porque el `init()` previo de `config` fue eliminado y no se reemplazó.

### Bug crítico #2
**Archivo:** `.env` (commiteado en git)
Contiene `JWT_SECRET=MiNegocio2026_ClaveSuperSegura_Y_Unica_PorAmbiente`. Si el entorno de CI/Jenkins no inyecta `JWT_SECRET`, godotenv carga este `.env` y el servidor arranca con un secreto público en el repo.

**Fix:** Agregar `config.LoadConfig()` tras la declaración de `env` en `main.go` y agregar `.env` a `.gitignore`.

### Bug en tests #3
**Archivo:** `config/jwt_test.go`
Referencia `getJWTSecret()` que fue eliminada → `build failed` en tests.

### Bug en tests #4
**Archivo:** `middleware/auth_middleware_test.go:TestAuthMiddleware_TokenValido_Retorna200`
Espera 200, obtiene 401. `config.JWTSecret` es nil (test no llama a `config.LoadConfig()`), el token generado no es válido contra nil.

---

## Integración T01 + T02

### Merge conflicts
**Archivo:** `service/auth_service.go`
- Conflicto 1: T02 agrega llamada a `GenerateToken` para refresh token; T01 elimina el bloque de refresh token.
- Conflicto 2: Comentario de función (`"RefreshToken - Implementación real"` vs `"RefreshToken"`).

Ambos conflictos son menores y se resuelven manualmente.

### Pruebas de integración (post-fix)

| Test | Resultado |
|------|-----------|
| Login admin/1234 | ✅ Token JWT recibido |
| Login vendedor1/pass456 | ✅ Token JWT recibido |
| Login con password incorrecto | ✅ `"Usuario o contraseña incorrectos"` |
| Login usuario inexistente | ✅ `"Usuario o contraseña incorrectos"` |
| CRUD productos con token válido | ✅ 0 items (DB vacía) |
| Crear producto | ✅ Producto creado |
| Inventario | ✅ 1 item |

### Conclusión
T01 y T02 son **compatibles** tras resolver conflictos menores. Los bugs de cada rama no afectan la compatibilidad entre ambas.

---

## Notas adicionales
- Ambas ramas están basadas en `main` (no en `feat/S3-HU02`). Van a necesitar rebase contra la rama de Victor para integrar correctamente.
- `.env` NO debe trackearse en git. Agregar a `.gitignore` y documentar en un `.env.example`.
- La variable `JWT_SECRET` debe ser inyectada por Jenkins/CI en producción, no desde `.env`.
