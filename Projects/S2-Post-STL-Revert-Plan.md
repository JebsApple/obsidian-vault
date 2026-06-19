---
tags: [plan, accion, sprint2, revert, slt-frontend]
updated: 2026-06-19
---

# Plan de Acción: Reversión STL-Redesign + Conservación de Funcionalidades

> Creado: 2026-06-19
> Autor: Victor / AI
> Estado: Pendiente de ejecución

## Objetivo

Deshacer los cambios del `S2-STL-Frontend-Redesign` en `minegocio-frontend`, manteniendo únicamente las funcionalidades implementadas por el equipo:
- Registro de ventas (Ignacio — S2-HU02)
- Tokens JWT y sesiones de usuario (Gabriel — S2-HU03)
- Lector de código de barras (Nicolás — S2-HU01)
- Carga de imágenes para productos (Victor — S2-HU04)

El rediseño (NavBar, SideBar, KanbanBoard, AnalisePage, InventarioPage, nuevos estilos) se pospone a **Sprint 3**.

---

## Estado actual (pre-ejecución)

### Frontend (`minegocio-frontend`)

| Capa | Rama | Quién | Estado en origin/main |
|------|------|-------|-----------------------|
| S2-HU02 Punto de Venta | `S2-HU02-Punto-de-Venta` | Ignacio | ✅ Mergeado |
| S2-HU04 Galería | `S2-HU04-Frontend-Galeria` | Victor | ✅ Mergeado |
| S2-HU04 Carga Imágenes | `S2-HU04-Frontend-CargaImagenes` | Victor | ❌ Solo local |
| **S2-STL Rediseño** | **`S2-STL-Frontend-Redesign`** | **?** | **❌ Solo local (a eliminar)** |
| feat/registro-usuarios | `feat/registro-usuarios` | Victor | ❌ Solo local (pospuesto S3) |

### Backend (`minegocio-backend`)

| Rama | Quién | Estado |
|------|-------|--------|
| `origin/main` (CRUD productos, inventario, imágenes, búsqueda) | Varios | ✅ En main |
| `origin/S2-HU03` (JWT) | Gabriel | ❌ No mergeado |
| `origin/S2-HU02-API` (Ventas endpoints) | Ignacio | ❌ No mergeado (basado en versión anterior) |

### Base de Datos

| Migración | Estado |
|-----------|--------|
| `registro-ventas/sprint2_create_registro_ventas.sql` | Pendiente |
| `registro-sesiones/sprint2_create_registro_sesiones` | Pendiente |
| `inventario_view.sql` | Aplicada |

---

## Plan detallado

### Fase 0: Herramientas
- [x] Instalar ponytail (`DietrichGebert/ponytail`) para minimalismo en código
- Configurar plugin en `opencode.json`

### Fase 1: Backend

#### 1A. Resetear `main` a `origin/main`
```bash
git checkout main
git reset --hard origin/main
```
Estado post-reset: `origin/main` (commit `9b8d22f`) — CRUD productos, inventario, imágenes, búsqueda.

#### 1B. Aplicar JWT de Gabriel (S2-HU03)
- **Problema:** `origin/S2-HU03` está basada en versión anterior (pre-reestructuración S2-Backend).
- **Solución:** No merge directo. Portar manualmente:
  - `config/jwt.go` → mantener, actualizar
  - `middleware/auth_middleware.go` → mantener
  - `handler/auth_handler.go` → extender con refresh token
  - `service/auth_service.go` → extender
- NO portar archivos de reestructuración antigua.

#### 1C. Aplicar Ventas de Ignacio (S2-HU02-API)
- Portar a estructura actual (handler/service/repository/models):
  - `models/venta.go` → agregar structs a `models/models.go`
  - `service/venta_service.go` → nuevo
  - `repository/venta_repository.go` → nuevo
  - `handler/ventas.go` → nuevo (corregir `package handler`)
  - `routes/routes.go` → registrar `/api/ventas`
  - `main.go` → instanciar VentaHandler

### Fase 2: Frontend

#### 2A. Resetear `main` a `origin/main`
```bash
git checkout main
git reset --hard origin/main
```
Estado: `origin/main` (commit `3f6a676`) — POS + Galería.
- Se pierde: NavBar, SideBar, KanbanBoard, AnalisePage, InventarioPage, LogoSVG, base.css, variables.css, config/api.js
- App.vue vuelve a: header rojo simple + router-view
- Router vuelve a: rutas básicas sin auth

#### 2B. Aplicar Carga de Imágenes (Victor)
- Cherry-pick commit `b7501b4` (feat(S2-HU04): carga de imágenes con drag&drop)
- Trae: `FormularioProducto.vue` (barcode + imágenes), modificaciones a `ProductosPage.vue`, `productosService.js`

#### 2C. Aplicar JWT Frontend (Gabriel)
- Desde `origin/S2-HU03`, portar manteniendo SU estructura:
  - `src/plugins/axios.js` — interceptor Axios
  - `src/services/authService.js` — login/logout/token management
  - `src/middleware/authGuard.js` — guard de rutas
- **Correcciones necesarias** (commits a rama de Gabriel, no introducir conceptos nuevos):
  1. LoginPage debe guardar token en localStorage
  2. Router: `beforeEach` global con `meta.requiresAuth`
  3. VentasService: agregar Bearer headers
  4. Agregar `jwt-decode` a package.json

#### 2D. UX Login + Consistencia Visual
- Login con `login.css` propio (sin depender de base.css/variables.css del STL)
- Paleta: `#D60000`, blanco, `#2C3E50`
- Responsive (viewport 375px)

### Fase 3: Base de Datos

#### 3A. Revisar estado actual
```bash
psql -U postgres -d cliente_dev -c '\dt'
```

#### 3B. Aplicar migraciones necesarias
- `registro-ventas/sprint2_create_registro_ventas.sql`
- Índice UNIQUE en `codigo_barras` de `productos` (si no existe)
- Alinear estructura backend (ventas/venta_items) con migración SQL (registro_ventas)

### Fase 4: Commits y Push

```bash
# Backend
cd /home/icin/minegocio-backend
git add . && git commit -m "feat: integrar JWT (S2-HU03) + ventas API (S2-HU02)"
git push origin main

# Frontend
cd /home/icin/minegocio-frontend
git add . && git commit -m "feat: revertir STL-redesign, conservar funcionalidades S2"
git push origin main
```

---

## Decisiones

| Tema | Decisión |
|------|----------|
| FormularioProducto (barcode + imágenes) | ✅ Conservar |
| NavBar/SideBar/KanbanBoard | ❌ Eliminar (S3) |
| AnalisePage/InventarioPage | ❌ Eliminar (S3) |
| base.css/variables.css | ❌ Eliminar (S3) |
| RegistroPage | ❌ Eliminar (S3) |
| store/auth.js | ❌ Reemplazar por authService.js de Gabriel |
| Código de Gabriel | ✅ Mantener intacto, correcciones en commits separados |
| Código de Ignacio | ✅ Conservar su implementación, commit con nota para S3 |

---

## Ramas

### Frontend
| Rama | Acción |
|------|--------|
| `main` | Reset + re-aplicar |
| `feat/registro-usuarios` | Intacta (S3) |
| `S2-HU03` (Gabriel) | Commit con fixes menores |

### Backend
| Rama | Acción |
|------|--------|
| `main` | Reset + mergear |
| `S2-HU02-API` (Ignacio) | Commit con nota de modificación para S3 |
