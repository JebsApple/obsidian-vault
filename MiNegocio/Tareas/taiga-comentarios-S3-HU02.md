---
tag: taiga/S3-HU02
tags:
  - taiga
  - sprint3
  - frontend
  - backend
---

# Comentarios para Taiga — Sprint 3 HU02

## **1. Comentarios Técnicos por Tarea**
### **S3-HU02-T01: Navegación (NavBar + SideBar)**
- **Mejoras realizadas:**
  - Recuperación de componentes `NavBar`, `SideBar` y `LogoSVG` del rediseño S2.
  - Integración de `authService` para manejo de autenticación (JWT como única fuente de verdad).
  - Refactor de `LoginPage` con diseño centrado, validaciones de campos y spinner en botón de submit.
  - Configuración de proxy para uploads de imágenes (`/uploads/`).
- **Pruebas:**
  - Build exitoso (`npm run build`).
  - Rutas protegidas redirigen a `/login` sin token y a `/servicios` con token.
  - SideBar colapsable y responsive (oculto en pantallas <768px).
  - Botón de cerrar sesión funcional.

---

### **S3-HU02-T02: Tablero Kanban de Inventario**
- **Mejoras realizadas:**
  - Implementación de `KanbanBoard.vue` con 4 columnas de estado de stock (Agotado, Bajo, Normal, Exceso).
  - Panel de búsqueda y agregado de productos en `InventarioPage` con editor inline de stock.
  - Drag & drop funcional entre columnas (actualiza stock via `PATCH /api/inventario/{id}`).
- **Pruebas:**
  - Build exitoso (`npm run build`).
  - Búsqueda de productos con debounce (endpoint `/api/productos/buscar`).
  - Tabla de inventario muestra ID, nombre, stock con badges de color y estado.

---

### **S3-HU02-T03: Dashboard Principal (AnalisePage)**
- **Mejoras realizadas:**
  - Rediseño de `AnalisePage` con KPIs (Total productos, Ventas del día, Stock bajo, Agotados) y landing page.
  - Limpieza de estilos inline en `VentasPage` (uso de CSS con hover nativo).
  - Badge de ganancia estimada en `FormularioProducto` (verde si `precio_venta > precio_compra`, rojo si no).
- **Pruebas:**
  - Build exitoso (`npm run build`).
  - Dashboard carga KPIs desde `/api/productos` y `/api/ventas`.
  - Diseño responsive y consistente.

---

### **S3-HU02-T04: Testing Frontend (Vitest)**
- **Mejoras realizadas:**
  - Configuración de **Vitest** con 5 suites de tests para componentes críticos.
  - Tests para `authGuard`, `SideBar`, `LoginPage`, `AnalisePage` y `AdminUsuariosPage`.
- **Pruebas:**
  - `npx vitest run` (23/23 tests pasan).
  - Sin dependencias externas (solo `vitest` + `@vue/test-utils`).
  - **Nota:** Tests dependen de componentes de `T01` (fallarán en `main` hasta mergear `T01`).

---

### **S3-HU02-T05: Validaciones + Mensajes de Error Globales**
- **Mejoras realizadas:**
  - Creación de componente `AppModal` global para reemplazar `alert()` y `confirm()` nativos.
  - Integración de `AppModal` en `CarritoCompras`, `ProductosPage` y `ProductosRegistrados`.
  - Validaciones en formularios (`FormularioProducto`, `LoginPage`) con mensajes en español.
- **Pruebas:**
  - Build exitoso (`npm run build`).
  - Modal funcional con slots personalizados (header, body, footer).
  - Confirmaciones de eliminación y venta usan modal en lugar de `confirm()`.

---

### **S3-HU02-T06: Separación de Capas Frontend**
- **Mejoras realizadas:**
  - Refactor de arquitectura CSS:
    - `src/styles/variables.css`: Tokens de diseño (colores, radios, sombras).
    - `src/styles/base.css`: Estilos compartidos (botones, cards, tablas, badges).
  - Migración de `fetch()` directo a servicios (`inventarioService.js`, `productosService.js`).
  - Eliminación de código muerto (`authGuard.js`, `axios.js`, `HelloWorld.vue`).
- **Pruebas:**
  - `npm run build` exitoso.
  - Todas las vistas usan servicios en lugar de `fetch()` directo.
  - CSS variables aplicadas en `App.vue`.

---

### **S3-HU02-T07: Separación de Capas Backend**
- **Mejoras realizadas:**
  - Refactor de arquitectura backend (Go):
    - `BuscarParams` movido a `models/models.go`.
    - Interfaces completadas (`InventarioServiceI`, `InventarioRepositoryI`, `VentaRepositoryI`).
    - I/O de archivos movido de `handler` a `service`.
    - Auth middleware inyecta claims en `context.Context`.
- **Pruebas:**
  - `go build ./...`, `go vet ./...`, `go test ./...` exitosos.
  - Handlers ya no importan `repository/` ni hacen I/O directo.

---

### **S3-HU02-T15: Pestañas estilo archivador + sidebar colapsable**
- **Mejoras realizadas:**
  - Rediseño de los switches de vista (Tablero/Stock en Inventario, Galería/Registrados en Productos) a **pestañas tipo archivador**, con curva cóncava invertida en la unión interior entre ambas pestañas (técnica `mask: radial-gradient` en la esquina contigua de la pestaña activa).
  - Estilos unificados en `src/styles/productos.css` como **fuente única** importada por `Productos.vue` e `Inventario.vue` (clases `vista-switch` / `vista-tab` / `tab-inicio` / `tab-fin` / `vista-tab-badge` / `vista-panel`). Eliminados los estilos `pill-switch`/`switch-btn` duplicados de cada vista.
  - Accesibilidad: `role="tablist"`/`role="tab"`/`role="tabpanel"`, `aria-selected`, `aria-controls` y `type="button"` en las pestañas (patrón WAI-ARIA Tabs).
  - SideBar: el colapso manual ahora está disponible **siempre** (antes solo aparecía en pantallas <60% del ancho). La flechita a la derecha del nombre de usuario recoge la barra dejando solo el logo "MiNegocio" + chevron-down para reexpandir, con transición suave.
  - Micro-animaciones: rotación/scale elástico (`cubic-bezier`) en la flechita de colapso y en los iconos de acción (hover).
  - Responsividad conservada en breakpoints 768/480 (pestañas a ancho completo, panel sin overflow).
- **Pruebas:**
  - Build exitoso (`npm run build` con Node 20). Bundle `app.1b09e67b.js`.
  - Desplegado a entorno dev (`rsync` a `/var/www/dev/frontend/`). HTTP 200 en `http://192.168.50.25:8080`.
  - Code review automatizado (vue-reviewer): estructura `Transition`/`v-if`/`v-else` intacta, reactividad de `vistaActiva` correcta. Issue ARIA (HIGH) **resuelto**; quedan 2 MEDIUM menores (paginación fuera del panel —aceptable como control independiente—).
- **Nota:** trabajo en rama local `S3-HU02-T15-tabs-archivador-sidebar-colapsable`. **No pusheado a Gitea** (pendiente de confirmación de Victor y del número de tarea en Taiga).

---

## **2. Tareas a Crear en Taiga**
| **ID Tarea**               | **Nombre**                          | **Tipo**          | **Prioridad** | **Descripción**                                                                                     |
|----------------------------|-------------------------------------|-------------------|---------------|-----------------------------------------------------------------------------------------------------|
| **S3-HU02-T08**            | Animaciones y consistencia visual   | Mejora            | Alta          | Unificar animaciones en KanbanBoard, CSS global, y reemplazar colores hardcodeados por variables. |
| **S3-HU02-T09**            | Nomenclatura de vistas (español)    | Refactor          | Media         | Renombrar vistas sin sufijo `Page` y actualizar router.                                            |
| **S3-HU02-T10**            | Limpieza de CSS duplicado           | Refactor          | Media         | Mover reglas de badges/botones de `GaleriaProductos` a `base.css`.                                |
| **S3-HU02-T11**            | Iconos para assets                  | Feature           | Baja          | Definir y agregar iconos en `src/assets/icons/` para componentes.                                  |
| **S3-HU02-T12**            | Merge a `dev` y pruebas integradas  | Tarea técnica     | Alta          | Coordinar merge de `S3-HU02` a `dev` y ejecutar pruebas integradas.                                |

---

## **3. Notas Adicionales**
1. **Dependencias entre tareas**:
   - `T04` (Testing) depende de `T01` (NavBar/SideBar). No mergear `T04` a `main` hasta completar `T01`.
   - `T06` (Capas frontend) y `T07` (Capas backend) son prerequisitos para `T10` (CSS dedup).

2. **Ownership**:
   - `S3-HU02` es liderado por **Victor**.
   - `ContactoPage.vue` y `AdminUsuariosPage.vue` **no deben modificarse** (asignados a Ignacio y Nicolás, respectivamente).

3. **Próximos pasos**:
   - Crear las tareas `T08`, `T09`, `T10`, `T11` y `T12` en Taiga.
   - Coordinar merge de `S3-HU02` a `dev` con el equipo.
   - Subir ramas a Gitea (instrucciones en [[instrucciones-subida-gitea-S3]]).