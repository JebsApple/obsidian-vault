---
tag: taiga/S3-HU02
tags:
  - taiga
  - sprint3
  - frontend
  - backend
---

# Tareas Faltantes para S3-HU02 — Sprint 3

## **Tareas a Crear en Taiga**
Basado en ramas existentes en Gitea (`S3-HU02-*`) y registros del vault.

### **S3-HU02-T06: Separación de Capas Frontend**
**Asignado:** Victor
**Fechas:** 27 jun → 2 jul
**Prioridad:** 🟡 Alta
**Tipo:** Refactor

**Descripción:**
Refactor de arquitectura CSS y servicios frontend para mejorar mantenibilidad y consistencia:
- Crear `src/styles/variables.css` con tokens de diseño (colores, radios, sombras, tipografía).
- Crear `src/styles/base.css` con estilos compartidos (botones, cards, tablas, badges, inputs).
- Migrar `fetch()` directo a servicios dedicados (`inventarioService.js`, `productosService.js`).
- Eliminar código muerto: `authGuard.js`, `axios.js`, `HelloWorld.vue`.
- Unificar umbrales de stock bajo en `src/utils/stockStatus.js` (usar `<=4` en todos los componentes).
- Consolidar lógica de autenticación en `authService.js` (evitar duplicación en `App.vue`).

**Archivos clave:**
- `src/styles/variables.css`
- `src/styles/base.css`
- `src/services/inventarioService.js`
- `src/services/productosService.js`
- `src/utils/stockStatus.js`
- `src/services/authService.js`

**Pruebas:**
- `npm run build` exitoso.
- Todas las vistas usan servicios en lugar de `fetch()` directo.
- CSS variables aplicadas en `App.vue` y componentes.
- Umbral de stock bajo consistente en `ProductosPage`, `InventarioPage` y `GaleriaProductos`.

---

### **S3-HU02-T07: Separación de Capas Backend**
**Asignado:** Gabriel
**Fechas:** 27 jun → 2 jul
**Prioridad:** 🟡 Alta
**Tipo:** Refactor

**Descripción:**
Refactor de arquitectura backend para cumplir con separación de capas (handler → service → repository):
- Mover `BuscarParams` a `models/models.go`.
- Completar interfaces en `service/interfaces.go` (`InventarioServiceI`, `VentaRepositoryI`).
- Mover I/O de archivos (ej: manejo de imágenes) de `handler` a `service`.
- Auth middleware inyecta claims en `context.Context` (evitar extracción manual en handlers).
- Unificar handlers para que **todos** reciban interfaces (no tipos concretos como `*service.InventarioService`).

**Archivos clave:**
- `models/models.go`
- `service/interfaces.go`
- `middleware/auth_middleware.go`
- `handler/inventario_handler.go`
- `handler/venta_handler.go`
- `main.go` (inyección de dependencias)

**Pruebas:**
- `go build ./...`, `go vet ./...`, `go test ./...` exitosos.
- Handlers no importan `repository/` ni hacen I/O directo.
- Claims del JWT disponibles en `context.Context` para todos los handlers.

---

### **S3-HU02-T08: Animaciones y Consistencia Visual**
**Asignado:** Victor
**Fechas:** 2 jul → 4 jul
**Prioridad:** 🟡 Alta
**Tipo:** Mejora

**Descripción:**
Unificar animaciones y estilos visuales en el frontend:
- Animaciones en `KanbanBoard.vue` (transiciones fluidas con `cubic-bezier`, delays sincronizados).
- Reemplazar colores hardcodeados por CSS variables (`var(--color-brand)`, `var(--color-text)`).
- Unificar `font-family` global en `App.vue`.
- Estilos consistentes para botones (`btn-primary`, `btn-outline`) y badges (`badge-low`, `badge-out-of-stock`).
- Eliminar estilos inline en `VentasPage` y `FormularioProducto`.

**Archivos clave:**
- `src/components/KanbanBoard.vue`
- `src/styles/variables.css`
- `src/App.vue`
- `src/views/VentasPage.vue`
- `src/components/FormularioProducto.vue`

**Pruebas:**
- Build exitoso (`npm run build`).
- Animaciones fluidas sin layout shift.
- Paleta de colores consistente en todos los componentes.

---

### **S3-HU02-T09: Nomenclatura de Vistas (Español)**
**Asignado:** Victor
**Fechas:** 4 jul → 5 jul
**Prioridad:** 🟢 Media
**Tipo:** Refactor

**Descripción:**
Renombrar vistas para usar nomenclatura en español y consistente:
- Eliminar sufijo `Page` de todas las vistas (ej: `AnalisePage.vue` → `Analise.vue`).
- Actualizar rutas en `src/router/index.js`.
- Desactivar regla ESLint `multi-word` para vistas de 1 palabra (ej: `Login.vue`).
- Verificar que todos los imports y referencias en el código estén actualizados.

**Archivos clave:**
- `src/views/Analise.vue`
- `src/views/Login.vue`
- `src/views/Productos.vue`
- `src/views/Ventas.vue`
- `src/views/Inventario.vue`
- `src/router/index.js`

**Pruebas:**
- Build exitoso (`npm run build`).
- Todas las rutas funcionan sin errores 404.
- Navegación entre vistas intacta.

---

### **S3-HU02-T10: Limpieza de CSS Duplicado**
**Asignado:** Victor
**Fechas:** 5 jul → 6 jul
**Prioridad:** 🟢 Media
**Tipo:** Refactor

**Descripción:**
Eliminar CSS duplicado y consolidar estilos:
- Mover reglas de badges y botones de `GaleriaProductos.vue` a `src/styles/base.css`.
- Unificar estilos de tablas en `ProductosRegistrados.vue` y `InventarioPage.vue`.
- Eliminar estilos inline en `CarritoCompras.vue` (usar clases globales).
- Revisar `productos.css` y `servicios.css` para evitar solapamientos con `base.css`.

**Archivos clave:**
- `src/styles/base.css`
- `src/views/GaleriaProductos.vue`
- `src/views/ProductosRegistrados.vue`
- `src/views/InventarioPage.vue`
- `src/views/CarritoCompras.vue`

**Pruebas:**
- Build exitoso (`npm run build`).
- Diseño visual consistente en todas las vistas.

---

### **S3-HU02-T11: Iconos para Assets**
**Asignado:** Victor
**Fechas:** 6 jul → 7 jul
**Prioridad:** 🟢 Baja
**Tipo:** Feature

**Descripción:**
Agregar iconos para mejorar la experiencia visual:
- Crear directorio `src/assets/icons/` con iconos SVG (ej: `icon-dashboard.svg`, `icon-products.svg`).
- Usar iconos en `SideBar.vue` y `NavBar.vue`.
- Iconos para acciones comunes (editar, eliminar, agregar) en `GaleriaProductos.vue` y `ProductosRegistrados.vue`.
- Icono de alerta para stock bajo/agotado en `KanbanBoard.vue`.

**Archivos clave:**
- `src/assets/icons/`
- `src/components/SideBar.vue`
- `src/components/NavBar.vue`
- `src/components/KanbanBoard.vue`
- `src/views/GaleriaProductos.vue`

**Pruebas:**
- Build exitoso (`npm run build`).
- Iconos visibles y consistentes en todas las vistas.

---

### **S3-HU02-T12: Merge a `dev` y Pruebas Integradas**
**Asignado:** Victor (coordinación)
**Fechas:** 8 jul → 9 jul
**Prioridad:** 🔴 Crítica
**Tipo:** Tarea técnica

**Descripción:**
Coordinar merge de todas las ramas `S3-HU02-*` a `dev` y ejecutar pruebas integradas:
- Verificar que todas las ramas estén actualizadas con `main`.
- Resolver conflictos de merge (priorizar cambios de `T01` y `T02`).
- Ejecutar pruebas unitarias (`npx vitest run`).
- Ejecutar pruebas de integración (navegación entre vistas, autenticación, drag & drop en Kanban).
- Validar que el build de producción (`npm run build`) sea exitoso.
- Documentar cualquier incidencia en [[S3-HU02-Registro-Taiga]].

**Pruebas:**
- `npm run build` exitoso.
- Todas las vistas funcionales en entorno de desarrollo.
- Pruebas unitarias pasan (23/23).

---

## **Dependencias y Notas**
1. **Dependencias entre tareas**:
   - `T06` (Capas frontend) y `T07` (Capas backend) son prerequisitos para `T10` (CSS dedup).
   - `T04` (Testing) depende de `T01` (NavBar/SideBar). No mergear `T04` a `main` hasta completar `T01`.

2. **Ownership**:
   - `S3-HU02` es liderado por **Victor**.
   - `T07` (Backend) requiere coordinación con **Gabriel**.
   - `ContactoPage.vue` y `AdminUsuariosPage.vue` **no deben modificarse** (asignados a Ignacio y Nicolás).

3. **Próximos pasos**:
   - Crear las tareas `T06` a `T12` en Taiga.
   - Subir ramas a Gitea (instrucciones en [[instrucciones-subida-gitea-S3]]).
   - Coordinar merge a `dev` con el equipo.