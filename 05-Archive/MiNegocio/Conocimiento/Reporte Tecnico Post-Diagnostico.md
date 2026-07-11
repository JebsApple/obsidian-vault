---
tags: [proyecto/minegocio, reporte, diagnostico, completo]
---

# Reporte Técnico — Post-Diagnóstico (2026-07-09)

## Credenciales

| Servicio | URL | Usuario | Pass | Notas |
|----------|-----|---------|------|-------|
| **Jenkins** | `http://192.168.50.28:8080` | `equipo6` | `equipo!"#$` | Pipelines: MiNegocio-backend, MiNegocio-Front, MiNegocio-database |
| **SonarQube** | `http://192.168.50.28:9000` | `equipo6` | `Equipo1234567!` | 0 analysis measures — pipeline no tiene sonar-scanner |
| **Gitea** | `http://192.168.50.28:3000` | VHerrera | (token en vault: `token gitea.md`) | SSH: `git@gitea:VHerrera/repo.git` |
| **Server prod** | `192.168.50.25` | — | — | Backend dev:3000, prod:3001. Nginx dev:8080, prod:8000. PG 16 en 5432 |
| **DB PostgreSQL** | localhost:5432 | `cliente_dev` | — | Password en `DB_PASSWORD=Icin2026` |

---

## Bugs Fixeados

### 1. Login no funciona (admin123)
- **Causa raíz:** `setup_produccion.sql:97` tiene `password_hash = 'CAMBIAR_POR_HASH_REAL'` — texto literal, no un hash bcrypt valido.
- `bcrypt.CompareHashAndPassword` siempre falla contra texto plano.
- **Fix:** Generado hash bcrypt para `admin123`: `$2a$10$aqx0YRKaR/gtJX7TnRDDge.43cmaM4qBfaCjG4NJzBvyt0OiSmyAS`
- **Archivos:** `fix_admin_password.sql` (update directo a DB) + `setup_produccion.sql` actualizado.

### 2. Servidor caído por disco lleno (04:43)
- PostgreSQL crasheó con `checkpointer signal 6` por disco al 82%.
- **Fix:** `docker system prune -af`, `apt clean`, limpiar `/tmp/` y `~/.cache/` → 73%.
- Restart PostgreSQL + dev container.

### 3. Sin endpoint `/api/register`
- `AuthHandler` solo tenía Login y Refresh.
- **Fix:** Agregado `Register` a `AuthServiceI` + `AuthService` + `AuthHandler`.
- **Rutas:** `POST /api/register` y `POST /api/auth/register`.
- **Body:** `{ nombre, email, password }` → bcrypt hash → usuario en DB → JWT response.

### 4. SideBar test failure en Jenkins
- SideBar faltaba `estadoInterno`, `eraAncha`, `actualizarBreakpoint()`.
- 13 tests fallaban con `actualizarBreakpoint is not a function`.
- **Fix:** Agregados data properties + resize handler.

---

## Feature Branches — Estado Actual

| Branch | Backend | Frontend |
|--------|---------|----------|
| **dev** | CRUD Usuarios + Proveedores completo | AdminUsuariosPage (WIP), Sin proveedores |
| **feat-proveedores** | IDÉNTICO a dev (sin diff) | No existe |
| **feat-usuarios** | Quita proveedores de dev | No existe |

**Conclusión:** La rama dev ya tiene backend completo con Usuarios y Proveedores. feat-usuarios es un snapshot anterior (no mergeable). feat-proveedores no tiene trabajo real.

---

## Frontend — Nuevos Archivos Creados

| Archivo | Propósito |
|---------|-----------|
| `src/services/usuariosService.js` | `getUsuarios()`, `createUsuario()` |
| `src/services/proveedoresService.js` | CRUD completo proveedores (GET/POST/PUT/DELETE) |
| `src/views/AdminUsuariosPage.vue` | Tabla + modal crear (nombre, email, password, rol) |
| `src/views/AdminProveedoresPage.vue` | Tabla + modal crear/editar + confirmación eliminar |
| `src/components/SideBar.vue` | Menús Usuarios + Proveedores agregados |
| `src/router/index.js` | Rutas `/admin/usuarios` y `/admin/proveedores` |

---

## Hot-Reload Dev

| Componente | Herramienta | Archivos |
|------------|-------------|----------|
| Backend Go | `air-verse/air` | `Dockerfile.dev`, `.air.toml` |
| Frontend Vue | `vue-cli-service serve` | Nativo (solo correr `npm run serve`) |

---

## Pendientes / Sugerencias de Mejora

### 🔴 Alta prioridad

| # | Ítem | Contexto |
|---|------|----------|
| 1 | **Hacer merge de AdminUsuariosPage y AdminProveedoresPage a dev** | Ya existen localmente pero no están en Gitea |
| 2 | **Desplegar backend con hot-reload en prod** | Usar `Dockerfile.dev` para dev container |
| 3 | **SideBar tests en Jenkins** | Verificar que el zip/build refleja el SideBar fixeado |
| 4 | **Crear usuarios test con hash bcrypt real** | seed SQL necesita hashes reales, no placeholders |

### 🟡 Media prioridad

| # | Ítem | Contexto |
|---|------|----------|
| 5 | **LoginPage.vue: register usa `nombre` y `user` como campos separados** | Register envía `{nombre, email, password}` pero el Register handler no valida `user`. Coherencia: login usa `user` + `pass`, register usa `nombre` + `email` + `password` |
| 6 | **Agregar sonar-scanner al pipeline de Jenkins** | SonarQube registrado pero sin análisis |
| 7 | **Endpoints PUT/DELETE para usuarios** | Backend solo tiene GET/POST `/api/usuarios`. No se puede editar/desactivar usuarios desde el frontend |
| 8 | **AdminUsuariosPage: mostrar si el usuario logueado es admin** | No hay protección visual; cualquier usuario logueado ve el menú |
| 9 | **Pull-to-refresh en tablas** | AdminUsuarios y AdminProveedores cargan datos en mounted pero no tienen botón de recarga |

### 🟢 Baja prioridad / Nice-to-have

| # | Ítem | Contexto |
|---|------|----------|
| 10 | **Ruta `/api/productos/buscar` antes que `/api/productos`** | gorilla/mux puede matchear `buscar` como `{id}` si el orden es incorrecto (ya está bien en routes.go, pero frágil) |
| 11 | **Agregar lazy loading a rutas** | `component: () => import(...)` para reducir bundle inicial |
| 12 | **Variables CSS compartidas entre Admin pages** | AdminUsuariosPage y AdminProveedoresPage tienen estilos duplicados |
| 13 | **Analisis.vue (dashboard legacy) no se usa** | Existe en views/ pero no está en router. AnalisePage.vue es el activo. Decidir si borrar o migrar funcionalidad |
| 14 | **KanbanBoard usa defaultStatus hardcodeado** | Los thresholds (stock 0→agotado, 1-4→bajo, 5+→normal) deberían venir de la view `inventario_view` |
| 15 | **JWT claims no se pasan a handlers** | AuthMiddleware no extrae usuario logueado. No sabemos quién hizo la request. Afecta sesiones |
| 16 | **PatchStock handler existe sin ruta registrada** | Código muerto en `inventario_handler.go` |

---

## API Endpoints Completos

| Método | Ruta | Auth | Estado |
|--------|------|------|--------|
| POST | `/api/login` | No | ✅ |
| POST | `/api/register` | No | ✅ (nuevo) |
| POST | `/api/auth/refresh` | No | ✅ |
| GET | `/api/productos` | JWT | ✅ |
| GET | `/api/productos/buscar` | JWT | ✅ |
| POST | `/api/productos` | JWT | ✅ |
| PUT | `/api/productos/{id}` | JWT | ✅ |
| DELETE | `/api/productos/{id}` | JWT | ✅ |
| POST | `/api/productos/{id}/imagen` | JWT | ✅ |
| DELETE | `/api/productos/{id}/imagen` | JWT | ✅ |
| GET | `/api/inventario` | JWT | ✅ |
| PATCH | `/api/inventario/{id}` | JWT | ❌ sin ruta |
| GET | `/api/ubicaciones` | JWT | ✅ |
| GET | `/api/ventas` | JWT | ✅ |
| POST | `/api/ventas` | JWT | ✅ |
| GET | `/api/usuarios` | JWT | ✅ |
| POST | `/api/usuarios` | JWT | ✅ |
| GET | `/api/proveedores` | JWT | ✅ |
| POST | `/api/proveedores` | JWT | ✅ |
| PUT | `/api/proveedores/{id}` | JWT | ✅ |
| DELETE | `/api/proveedores/{id}` | JWT | ✅ |
| GET | `/api/version` | No | ✅ |

## Notas para Claude

- Este archivo es el source of truth del estado actual del proyecto.
- Claude debe leer este reporte al iniciar una sesión para entender el contexto completo.
- Los pendientes tienen prioridad numérica. Empezar por #1.
- Las contraseñas están en texto plano en este archivo — NO subir a Gitea.
