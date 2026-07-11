---
tag: taiga/S3-HU02
tags:
  - taiga
  - sprint-3
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
  - Configuración de **Vitest** + `@vue/test-utils` + `happy-dom` (entorno DOM simulado).
  - 10 suites, 54 tests que cubren servicios, componentes y páginas.
  - Tests mockean `fetch` (servicios) o JWT (componentes), sin依赖encia de backend real.
  - `npm test` alias de `npx vitest run`.
- **Pruebas — paso a paso para recrear cada test manualmente:**

  **1. `authService.test.js` (8 tests) — Servicio de autenticación**
  ```
  [AUTH-01] login guarda token y refresh_token en localStorage
    → mock fetch retorna { token, refresh_token }
    → login({ user, pass }) debe setear ambos en localStorage
  
  [AUTH-02] login lanza "Credenciales inválidas" si 401
    → mock fetch retorna ok: false
    → login("x", "y") debe reject con el mensaje
  
  [AUTH-03] logout elimina token y refresh_token de localStorage
    → setear ambos manualmente
    → logout() debe limpiarlos (getItem → null)
  
  [AUTH-04] getToken retorna el token almacenado
    → setear 'mi-token'
    → getToken() === 'mi-token'
  
  [AUTH-05] getUserFromToken retorna null sin token
    → localStorage vacío
    → getUserFromToken() === null
  
  [AUTH-06] getUserFromToken retorna null si expiró
    → JWT falso con exp pasado
    → getUserFromToken() === null
  
  [AUTH-07] getUserFromToken decodifica claims válidos
    → JWT falso con exp futuro + user_id + nombre + rol
    → getUserFromToken() = { id, nombre, rol }
  
  [AUTH-08] getUserFromToken usa "vendedor" por defecto
    → JWT falso sin claim rol
    → .rol === 'vendedor'
  ```

  **2. `productosService.test.js` (8 tests) — CRUD productos**
  ```
  [PROD-01] getProductos retorna lista desde GET /api/productos
  [PROD-02] getProductosById retorna { id: 5 } desde GET /api/productos/5
  [PROD-03] createProducto hace POST con body correcto
  [PROD-04] updateProducto hace PUT a /api/productos/{id}
  [PROD-05] deleteProducto hace DELETE y retorna ok
  [PROD-06] getProductosById lanza 404 si no existe
  [PROD-07] searchProducts incluye ?q=consulta en URL
  [PROD-08] uploadImage envía FormData (sin Content-Type manual)
  ```

  **3. `ventasService.test.js` (4 tests) — Ventas**
  ```
  [VENTA-01] createVenta hace POST con items array
  [VENTA-02] getVentas retorna historial desde GET /api/ventas
  [VENTA-03] createVenta falla si la API responde error
  [VENTA-04] getVentas retorna [] si no hay datos
  ```

  **4. `inventarioService.test.js` (5 tests) — Inventario**
  ```
  [INV-01] getAll retorna [{ id, stock }] desde GET /api/inventario
  [INV-02] updateStock hace PATCH a /api/inventario/{id} con body { stock }
  [INV-03] updateStock lanza error si la API falla
  [INV-04] buscarProductos normaliza { productos: [...] } a array plano
  [INV-05] buscarProductos acepta array directo también
  ```

  **5. `KanbanBoard.test.js` (6 tests) — Componente Kanban**
  ```
  [KANBAN-01] renderiza 3 columnas (Bodega, Vitrina, Sin clasificar)
  [KANBAN-02] getProductosPorUbicacion('Bodega') solo items con ubicacion='Bodega'
  [KANBAN-03] toggleExpand alterna columna expandida (null → nombre → null)
  [KANBAN-04] handleDrop a distinta columna emite 'product-moved' con productId + nuevaUbicacion
  [KANBAN-05] handleDrop a misma columna NO emite evento
  [KANBAN-06] producto con ubicacion desconocida cae en 'Sin clasificar'
  ```

  **6. `SideBar.test.js` (5 tests) — Navegación lateral**
  ```
  [SIDEBAR-01] renderiza sin errores con router mock
  [SIDEBAR-02] NO muestra enlace Usuarios si rol=vendedor
  [SIDEBAR-03] SÍ muestra enlace Usuarios si rol=admin
  [SIDEBAR-04] muestra placeholder Sesiones deshabilitado (.nav-item--disabled)
  [SIDEBAR-05] muestra nombre de usuario desde JWT
  ```

  **7. `Login.test.js` (3 tests) — Página de login**
  ```
  [LOGIN-01] renderiza input usuario y contraseña
  [LOGIN-02] botón submit deshabilitado si campos vacíos
  [LOGIN-03] botón se habilita al escribir en ambos campos
  ```

  **8. `Analisis.test.js` (4 tests) — Dashboard**
  ```
  [ANALISIS-01] renderiza tarjetas KPI
  [ANALISIS-02] muestra Total Productos
  [ANALISIS-03] muestra Ventas del Día
  [ANALISIS-04] muestra alerta Stock Bajo
  ```

  **9. `authGuard.test.js` (7 tests) — Guard de rutas**
  ```
  [GUARD-01] redirige a /login si no hay token
  [GUARD-02] permite acceso si hay token válido
  [GUARD-03] redirige si token expiró
  [GUARD-04] redirige a / si no es admin
  [GUARD-05] permite acceso admin
  [GUARD-06] redirige a /login desde ruta admin sin token
  [GUARD-07] mantiene ruta destino después de login
  ```

  **10. `AdminUsuariosPage.test.js` (4 tests) — Gestión usuarios**
  ```
  [ADMIN-01] renderiza tabla vacía
  [ADMIN-02] muestra mensaje de bienvenida
  [ADMIN-03] botón crear usuario existe
  [ADMIN-04] modal de creación se abre al hacer click
  ```

  **Comando para verificar todo:**
  ```bash
  npx vitest run
  # Expected: 54 passed, 0 failed
  ```

  **Para cobertura (útil para SonarQube):**
  ```bash
  npm install -D @vitest/coverage-v8
  npx vitest run --coverage
  # Reporte en coverage/lcov.info
  ```

- **Nota:** Tests dependen de componentes de otras tareas (ej. SideBar.test.js depende de T01).

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