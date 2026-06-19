---
tags: [proyecto/minegocio, taiga, sprint-3, plan]
---

# Propuesta Taiga — Sprint 3

> Basado en: estado actual del proyecto (2026-06-19), bugs reparados, páginas creadas, y deuda técnica documentada.

---

## ✅ Logrado (Sprint 2 — completado)

| Historia | Descripción | Estado |
|----------|-------------|--------|
| HU-01 | Login funcional con JWT (comparación contra DB por nombre o email) | ✅ |
| HU-02 | Punto de Venta con carrito, búsqueda de productos, registro de ventas | ✅ |
| HU-03 | CRUD productos (crear, listar, editar, eliminar con soft delete) | ✅ |
| HU-04 | Galería de productos con búsqueda, filtros, imágenes drag&drop | ✅ |
| HU-05 | Inventario (vista con estado Normal/Bajo/Agotado) | ✅ |
| HU-06 | Registro de Ventas (historial con producto, cantidad, fecha) | ✅ |
| HU-07 | Navegación central con links condicionales según sesión | ✅ |
| HU-08 | HomePage auto-redirect según auth | ✅ |
| HU-09 | NavBar con logout | ✅ |

## 📋 Pendiente para Sprint 3

### 🚨 Deuda Técnica Crítica (debe hacerse)

| ID | Tarea | Historia | Prioridad | Esfuerzo |
|----|-------|----------|-----------|----------|
| SP3-01 | **Migrar login a bcrypt** — Cambiar `password_hash` en DB y login para usar bcrypt. Respaldar usuarios primero. Reemplazar comparación texto plano en `usuario_repository.go`. | Técnica | 🔴 Crítica | M |
| SP3-02 | **JWT_SECRET vía entorno** — Quitar default hardcodeado de `config/jwt.go`. En Jenkins, inyectar secreto vía credencial. Tanto dev como prod deben definir `JWT_SECRET`. | Técnica | 🔴 Crítica | S |
| SP3-03 | **Arreglar Docker cross-compilation** — Agregar `GOARCH=amd64` (o el que corresponda) al Dockerfile para que Jenkins pueda desplegar backend en producción. | Técnica / DevOps | 🔴 Crítica | S |

### 🎯 Funcionalidades Nuevas

| ID | Tarea | Historia | Prioridad | Esfuerzo |
|----|-------|----------|-----------|----------|
| SP3-04 | **Control de acceso por rol** — Extraer claims (user_id, rol) del JWT en `AuthMiddleware` y pasarlos al handler. Restringir acciones según admin/vendedor. | Administración | 🟡 Alta | M |
| SP3-05 | **id_vendedor dinámico** — Usar user_id del token JWT en vez de hardcodear `1` al registrar venta. | Ventas | 🟡 Alta | S |
| SP3-06 | **Pipeline CI/CD frontend** — Crear Jenkinsfile para frontend que compile (`npm run build`) y copie a `/var/www/prod/frontend/`. | DevOps | 🟡 Alta | M |
| SP3-07 | **Registro de sesiones** — Conectar tabla `registro_sesiones` con login/logout para auditoría. | Administración | 🟡 Alta | M |
| SP3-08 | **Auto-migraciones DB** — Script que ejecute migraciones SQL pendientes al iniciar backend (ej: migrate o simple boot script). | Técnica | 🟡 Alta | L |

### 🧹 Limpieza

| ID | Tarea | Prioridad | Esfuerzo |
|----|-------|-----------|----------|
| SP3-09 | Eliminar `HelloWorld.vue`, `plugins/axios.js`, `middleware/authGuard.js`, `esquema.sql` vacío | 🟢 Baja | S |
| SP3-10 | Consolidar CSS duplicado (botones/badges repetidos) | 🟢 Baja | S |
| SP3-11 | Agregar tests básicos al frontend | 🟡 Media | M |

### 📝 Documentación

| ID | Tarea | Prioridad | Esfuerzo |
|----|-------|-----------|----------|
| SP3-12 | Documentar API endpoints en `/api/docs` o wiki | 🟡 Media | M |
| SP3-13 | Instrucciones de setup local para nuevo desarrollador | 🟢 Baja | S |

---

## Propuesta de User Stories para Taiga

### US-01: Login Seguro con bcrypt
> **Como** administrador del sistema, **quiero** que las contraseñas se almacenen con bcrypt **para** proteger los datos del negocio incluso si la base de datos se ve comprometida.

**Criterios de aceptación:**
- Las contraseñas existentes en DB se migran a bcrypt (ejecutar script `migrate_bcrypt.go`)
- Nuevos registros usan bcrypt
- Login existente sigue funcionando

### US-02: Control de Acceso por Rol
> **Como** administrador, **quiero** que cada usuario tenga permisos según su rol **para** evitar que vendedores modifiquen productos o vean datos sensibles.

**Criterios de aceptación:**
- Middleware extrae user_id y rol del JWT
- Vendedores solo pueden ver productos y registrar ventas
- Admins pueden todo (CRUD productos, ver inventario, ver ventas)
- id_vendedor se obtiene del token, no se hardcodea

### US-03: Despliegue Automatizado Frontend
> **Como** desarrollador, **quiero** que el frontend se despliegue automáticamente via Jenkins **para** evitar errores manuales al copiar archivos.

**Criterios de aceptación:**
- Jenkinsfile en frontend compila y despliega a producción
- Pipeline se gatilla con push a main
- Notifica éxito/fallo

### US-04: Auditoría de Sesiones
> **Como** administrador, **quiero** saber quién inició sesión y cuándo **para** poder auditar el uso del sistema.

**Criterios de aceptación:**
- Cada login crea un registro en `registro_sesiones`
- Logout actualiza `cierre_sesion`
- Vista de sesiones activas y últimas 100 sesiones

### US-05: Docker Build Multi-arquitectura
> **Como** desarrollador, **quiero** que `docker build` funcione tanto en Jenkins como en servidor de producción **para** que el CI/CD no falle por incompatibilidad de arquitectura.

**Criterios de aceptación:**
- Dockerfile compila con `GOARCH` explícito
- Imagen corre sin error `exec ./main: not found`
- Backend expone puerto 3001 (producción) correctamente

---

## Asignación sugerida

| Tarea | Asignado | Revisor |
|-------|----------|---------|
| SP3-01 (bcrypt) | Gabriel (backend) | Victor (DB) |
| SP3-02 (JWT secret) | Gabriel (backend) | MelusineZoe |
| SP3-03 (Docker cross) | Gabriel (backend) | Nicolás |
| SP3-04 (Claims) | Gabriel/MelusineZoe | Ignacio |
| SP3-05 (id_vendedor) | Gabriel (backend) | Ignacio (frontend) |
| SP3-06 (CI/CD frontend) | Nicolás | LaManzana |
| SP3-07 (Sesiones) | Gabriel | Victor |
| SP3-08 (Migraciones) | Victor (DB) | Gabriel |
| SP3-09/10 (Limpieza) | Ignacio (frontend) | — |
| SP3-11 (Tests frontend) | Ignacio | LaManzana |
