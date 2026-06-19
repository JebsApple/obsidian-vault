---
tags: [proyecto/minegocio, deuda-tecnica, ponytail]
---

# Deuda Técnica — MiNegocio (ponytail-debt)

> No se encontraron marcadores `ponytail:` en el código. Esto significa que los atajos no están documentados — la deuda existe igual pero sin upgrade path definido.

## Deuda técnica identificada

### 🔴 Crítica

| ID | Deuda | Archivo | Impacto |
|----|-------|---------|---------|
| DT-01 | **Comparación password_hash texto plano** — Login usa `WHERE password_hash = $2` en vez de bcrypt. | `repository/usuario_repository.go:22` | ❌ Seguridad: contraseñas en texto plano en DB |
| DT-02 | **JWT_SECRET hardcodeado** — Default en código: `"MiNegocio2026_SuperSecretKey_CambiarEnProduccion!"`. | `config/jwt.go:33` | ❌ Seguridad: si alguien accede al binario tiene la clave |
| DT-03 | **Dockerfile no cross-compila** — Compila en la arquitectura del nodo Jenkins, falla en producción con `exec ./main: not found`. | `Dockerfile:8` | ❌ CI/CD: Jenkins no puede desplegar backend |

### 🟡 Alta

| ID | Deuda | Archivo | Impacto |
|----|-------|---------|---------|
| DT-04 | **AuthMiddleware no extrae claims** — Solo valida el token, pero no pasa user_id/rol al handler. No hay control de acceso por rol. | `middleware/auth_middleware.go:31` | ⚠️ No se puede restringir rutas por tipo de usuario |
| DT-05 | **Sin manejo de sesiones** — Tabla `registro_sesiones` existe pero no se usa. No hay registro de quién inició sesión ni cuándo. | `database/registro-sesiones/` | ⚠️ Sin auditoría de acceso |
| DT-06 | **Sin migraciones automáticas** — Los scripts SQL están en el repo pero no hay un sistema que los ejecute automáticamente al desplegar. | `database/` | ⚠️ Despliegues manuales, propenso a errores |

### 🟡 Media

| ID | Deuda | Archivo | Impacto |
|----|-------|---------|---------|
| DT-07 | **`ventasService.getVenta(id)` no se usa** — Endpoint GET /api/ventas/{id} existe pero el frontend nunca lo llama. | `services/ventasService.js` | 🗑️ Código muerto |
| DT-08 | **`axios.js` plugin no usado** — Se agregó pero todas las llamadas usan fetch nativo. | `plugins/axios.js` | 🗑️ Código muerto |
| DT-09 | **`authGuard.js` middleware no usado** — El guard del router está inline en `router/index.js`. | `middleware/authGuard.js` | 🗑️ Código muerto |
| DT-10 | **Sin tests frontend** — El backend tiene tests (`*_test.go`), el frontend no tiene ningún test. | — | 🧪 Sin cobertura frontend |
| DT-11 | **No hay CI/CD para frontend** — Solo el backend tiene Jenkinsfile. El frontend se despliega manualmente. | — | ⚙️ Proceso manual propenso a error |
| DT-12 | **Ventas: hardcodea `id_vendedor: 1`** — El carrito siempre usa vendedor ID 1 porque el middleware no extrae user_id del token. | `CarritoCompras.vue` | 🐛 Arreglar cuando DT-04 esté resuelto |

### 🟢 Baja

| ID | Deuda | Archivo | Impacto |
|----|-------|---------|---------|
| DT-13 | **`HelloWorld.vue` sin uso** — Componente boilerplate de Vue CLI, no se usa en ninguna ruta. | `components/HelloWorld.vue` | 🧹 Eliminar |
| DT-14 | **Sin tipos en frontend** — Vue Options API sin TypeScript. | — | 📝 Sin autocompletado |
| DT-15 | **CSS duplicado** — Estilos de botones/badges repetidos en `GaleriaProductos.vue` CSS scoped y `productos.css`. | — | 🧹 Consolidar |
| DT-16 | **`esquema.sql` vacío** — Archivo placeholder en raíz del repo database que nunca se llenó. | `esquema.sql` | 🧹 Eliminar o llenar |

## Resumen

**16 items de deuda técnica identificados:** 3 críticos, 4 altos, 5 medios, 4 bajos.

### Prioridad para Siguiente Sprint

| Prioridad | IDs |
|-----------|-----|
| Sprint 3 - Debe | DT-01 (bcrypt), DT-02 (JWT secret), DT-03 (Docker cross-compile) |
| Sprint 3 - Debería | DT-04 (claims en middleware), DT-12 (id_vendedor dinámico) |
| Sprint 3 - Podría | DT-07, DT-08, DT-09, DT-13 (limpiar código muerto) |
| Backlog | DT-05, DT-06, DT-10, DT-11, DT-14, DT-15, DT-16 |
