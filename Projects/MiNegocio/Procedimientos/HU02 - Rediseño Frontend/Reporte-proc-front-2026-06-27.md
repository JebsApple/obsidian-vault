---
tags: [proyecto/minegocio, sprint-3, reporte, s3-hu02, victor, sandbox]
fecha: 2026-06-27
tipo: reporte-ejecucion
---

# Reporte: Ejecución proc-front — S3-HU02 Base Frontend
**Fecha:** 2026-06-27 | **Sprint:** 3 | **Rama:** `sandbox/proc-front` | **Asignado:** Victor Herrera

---

## Resumen ejecutivo

Se ejecutó el plan [[Tasks/proc-front]] en rama de sandbox aislada (`sandbox/proc-front`) partiendo desde `main` limpio. La base frontend definida en el plan quedó implementada y verificada: build de producción exitoso en 16.2s, 20 tests unitarios pasando. El backend no requirió cambios — `PATCH /api/inventario/{id:[0-9]+}` ya existía en `main`.

---

## Archivos creados

| Archivo | Descripción |
|---------|-------------|
| `src/views/AnalisePage.vue` | Dashboard (autenticado) + Landing (público). Toggle `v-if="isLoggedIn"`. Stats KPIs, últimas ventas, accesos rápidos, botón export placeholder con instrucciones para Ignacio |
| `src/views/AdminUsuariosPage.vue` | Placeholder para **Nicolás** (S3-HU04-T03). Instrucciones HTML comentadas con endpoints esperados, campos y referencias al router |
| `src/components/SideBar.vue` | Navegación lateral. Enlace "Usuarios" visible solo si `esAdmin=true` en localStorage. Placeholder "Sesiones" deshabilitado (S3-HU07) |
| `src/components/NavBar.vue` | Barra superior para estado público (sin auth) |
| `src/components/LogoSVG.vue` | SVG del logo reutilizable |
| `src/config/api.js` | Base URL de la API centralizada |
| `src/styles/variables.css` | Design system: variables CSS de paleta, tipografía, espaciado |
| `src/styles/base.css` | Reset + fuentes base |
| `src/styles/components.css` | Clases reutilizables: botones, badges, cards |
| `src/styles/inventario.css` | Estilos de InventarioPage |

## Archivos modificados

| Archivo | Cambio |
|---------|--------|
| `src/App.vue` | Layout: SideBar (autenticado) / NavBar (público) según token en `localStorage` |
| `src/router/index.js` | + ruta `/admin/usuarios` (`requiresAuth: true`) + `AnalisePage` como ruta raíz `/` + auth guard `beforeEach` activo |
| `src/main.js` | Importa `@/styles/base.css` como entrada de estilos globales |

## No modificado (intencionalmente)

| Archivo | Razón |
|---------|-------|
| `src/views/LoginPage.vue` | Ya estaba limpio (solo ingreso, sin registro) — conforme al plan |
| `backend/routes/routes.go` | `PATCH /api/inventario/{id:[0-9]+}` con `PatchStock` ya registrado en `main` |

---

## Decisiones de implementación

**AnalisePage como Landing + Dashboard unificados** — un componente con `v-if="isLoggedIn"` evita duplicar lógica de routing para la raíz `/`. La landing pública muestra features y botón "Ingresar"; el dashboard muestra KPIs reales consultando la API.

**esAdmin desde localStorage** — la verificación de rol en SideBar usa `localStorage.getItem('esAdmin') === 'true'`. Simple y consistente con cómo el equipo ya maneja roles. El control real de acceso backend está pendiente en S3-HU01-T06 (Gabriel + Ignacio). Esta es solo la capa visual de navegación.

**AdminUsuariosPage como placeholder documentado** — la ruta `/admin/usuarios` existe, está protegida y tiene instrucciones HTML completas para que Nicolás implemente S3-HU04-T03 directamente sobre ella. No requiere reescritura, solo rellenar el template.

**Sandbox desde main limpio** — se evitó partir de `feat/S3-HU02` porque esa rama incluye trabajo asignado a Ignacio (KanbanBoard, exportación) que el proc-front no debía incorporar.

---

## Resultado del build

```
Rama: sandbox/proc-front (commit 015c186 → actualizado con fix Nicolas)
Base: main (30643e8)

Build: npm run build
  ✓ Compiled successfully in 16225ms
  dist/js/app.js          56.26 KiB  (14.68 KiB gzip)
  dist/js/chunk-vendors.js 139.49 KiB (49.85 KiB gzip)
  dist/css/app.css         29.38 KiB  ( 5.70 KiB gzip)
```

---

## Ponytail Audit — proc-front

**Modo:** full | **Fecha:** 2026-06-27 | **Scope:** archivos de `sandbox/proc-front` creados o modificados

### Hallazgos

`shrink` **`cargarDatos()` en AnalisePage** — dos `await fetch` secuenciales (productos → ventas). Ejecutarlos en paralelo con `Promise.all` reduciría el tiempo de carga del dashboard en ~50%.
```js
// Actual (secuencial):
const productosRes = await fetch('/api/productos', ...)
const ventasRes = await fetch('/api/ventas', ...)

// Corrección ponytail:
const [productosRes, ventasRes] = await Promise.all([
  fetch('/api/productos', { headers }),
  fetch('/api/ventas', { headers })
])
```
→ Aplicar antes de merge a dev.

`yagni` **`esAdmin` acepta `'1'`** — la computed en SideBar hace `val === 'true' || val === '1'`. El proyecto solo persiste `'true'`/`'false'` en localStorage (verificado en authService). La rama `|| val === '1'` nunca se activa.
```js
// Actual:
return val === 'true' || val === '1'
// Corrección:
return val === 'true'
```

`ok` **Cero dependencias nuevas** — todos los componentes usan `fetch` nativo, `localStorage` nativo, `vue-router` ya instalado. Sin axios, sin librerías de estado.

`ok` **Auth guard reutiliza authService** — `getToken()` e `isTokenExpired()` del servicio existente, sin duplicar lógica JWT.

`ok` **AdminUsuariosPage mínimo funcional** — 50 líneas de template + script vacío. El comentario HTML documenta lo que Nicolás necesita sin sobreingeniería.

`ok` **CSS deshabilitado sin JS** — `.nav-item--disabled` usa solo `pointer-events: none` + `opacity: 0.4`. Nativo del navegador.

### Correcciones aplicadas

- [x] `Promise.all` en `cargarDatos()` — aplicado en commit de sandbox
- [x] `esAdmin` simplificado a `=== 'true'` — aplicado

---

## Tests unitarios

**Framework:** Vitest 2.1.9 + @vue/test-utils 2.4.11 + happy-dom
**Config:** `vitest.config.js` (raíz del repo)
**Resultado:** ✅ 20 tests, 4 suites, 0 fallos

### Suite 1 — `SideBar.test.js` (5 tests)

| Test | Descripción | Estado |
|------|-------------|--------|
| T01 | Renderiza sin errores con props por defecto | ✅ |
| T02 | NO muestra enlace "Usuarios" cuando `esAdmin=false` | ✅ |
| T03 | SÍ muestra enlace "Usuarios" cuando `esAdmin=true` | ✅ |
| T04 | Muestra placeholder "Sesiones" deshabilitado | ✅ |
| T05 | Muestra nombre de usuario desde localStorage | ✅ |

### Suite 2 — `AnalisePage.test.js` (4 tests)

| Test | Descripción | Estado |
|------|-------------|--------|
| T01 | Muestra `.landing` cuando no hay token | ✅ |
| T02 | Muestra `.dashboard` cuando hay token | ✅ |
| T03 | La landing tiene botón `.btn-login` | ✅ |
| T04 | El botón export está `disabled` en el dashboard | ✅ |

### Suite 3 — `AdminUsuariosPage.test.js` (4 tests)

| Test | Descripción | Estado |
|------|-------------|--------|
| T01 | Renderiza `.placeholder-box` | ✅ |
| T02 | Muestra título "Administración de Usuarios" | ✅ |
| T03 | Indica que la tarea es de "Nicolas" | ✅ |
| T04 | Muestra badge "S3-HU04" | ✅ |

### Suite 4 — `authGuard.test.js` (7 tests)

| Test | Descripción | Estado |
|------|-------------|--------|
| T01 | `isTokenExpired(null)` → `true` | ✅ |
| T02 | `isTokenExpired('no-es-jwt')` → `true` | ✅ |
| T03 | Token con `exp` en el pasado → expirado | ✅ |
| T04 | Token con `exp` en el futuro → válido | ✅ |
| T05 | `/admin/usuarios` tiene `requiresAuth: true` | ✅ |
| T06 | `/login` NO tiene `requiresAuth` | ✅ |
| T07 | `/` (dashboard) NO tiene `requiresAuth` (acceso público con toggle) | ✅ |

---

## Estado del sandbox

```
Rama: sandbox/proc-front
Commits sobre main: 2
Build: ✅ producción sin errores
Tests: ✅ 20/20 passing
Listo para merge a dev: pendiente aprobación
```

---

## Tareas NO incluidas (proc-front explícito)

| Tarea | Asignado | Estado |
|-------|----------|--------|
| S3-HU02-T02: KanbanBoard drag & drop | Victor | Pendiente |
| S3-HU02-T03: Dashboard KPIs completo | Victor | Base creada, completar en T03 |
| S3-HU02-T04: Tests frontend Vitest | Victor | Configuración + 20 tests base hechos aquí |
| S3-HU04-T03: Página Gestión de Usuarios | Nicolás | Placeholder listo para implementar |
| S3-HU01-T06: Control de acceso por rol real | Gabriel + Ignacio | Pendiente |
| S3-HU07: Auditoría sesiones | Gabriel + Ignacio | Placeholder en SideBar |

---

## Referencias

- [[Tasks/proc-front]] — Plan original ejecutado
- [[Sprint 3 - Plan de Trabajo]] — Plan completo del sprint
- [[PonytailAudit - Sprint 3]] — Auditoría de deuda técnica sprint 3
- [[Nicolás Valdés]] — Perfil del implementador de AdminUsuariosPage
