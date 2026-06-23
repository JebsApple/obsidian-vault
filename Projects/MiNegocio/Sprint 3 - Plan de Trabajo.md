---
tags: [proyecto/minegocio, sprint-3, plan]
---

# Sprint 3 — Plan de Trabajo

> **Deadline:** 10 julio 2026
> **QA:** 8 julio 2026 (2 días antes)
> **Hoy:** 23 junio 2026 — **17 días hábiles**
> **Requerimientos generales:** Reportes PDF y Excel, Control de Versiones, Logs, EndPoints documentados, SonarQube desde local y Jenkins

---

## S3-HU01: Resolución de Deuda Técnica y Pipeline CI/CD

> **UX:** 0 | **Design:** 0 | **Front:** 3 | **Back:** 13 | **Total:** 16

> **Como** administrador del sistema, **quiero** resolver las vulnerabilidades de seguridad y establecer un pipeline CI/CD completo **para** garantizar un despliegue seguro, auditado y automatizado.

### Tareas

#### S3-HU01-T01: bcrypt para passwords (Gabriel) — 23 jun → 27 jun
Migrar almacenamiento de contraseñas de texto plano a bcrypt en el backend. Incluye script de migración para usuarios existentes y validación dual durante la transición. Archivos: `repository/usuario_repository.go`, `service/auth_service.go`, `scripts/migrate_bcrypt.go`. Relación: DT-01

#### S3-HU01-T02: JWT_SECRET por variable de entorno (Gabriel) — 23 jun → 27 jun
Eliminar secret hardcodeado en `config/jwt.go`, leer `JWT_SECRET` de variable de entorno sin fallback. El servidor no arranca si no está definida. Archivos: `config/jwt.go`. Relación: DT-02

#### S3-HU01-T03: Docker multi-arquitectura + Pipeline Jenkins (Nicolás) — 23 jun → 30 jun
Corregir `Dockerfile` con `GOOS=linux GOARCH=amd64` explícito. Crear/actualizar `Jenkinsfile` del backend con stages: checkout → test → build docker → deploy a producción. Configurar webhook Gitea → Jenkins. Archivos: `Dockerfile`, `Jenkinsfile`. Relación: DT-03

#### S3-HU01-T04: SonarQube local + Jenkins (Nicolás) — 30 jun → 4 jul
Integrar análisis SonarQube en el pipeline de Jenkins y documentar cómo ejecutarlo localmente. Verificar que el escáner funcione desde ambos entornos.

#### S3-HU01-T05: Limpieza de código muerto — frontend + backend (Ignacio) — 23 jun → 27 jun
**Frontend:** Eliminar `HelloWorld.vue`, `plugins/axios.js` (+ dependencia axios de package.json), `middleware/authGuard.js`, `ContactoPage.vue`, `contacto.css`, `ventasService.getVenta(id)`. Consolidar CSS duplicado de botones/badges entre `GaleriaProductos.vue` y `productos.css`. Unificar umbral de stock bajo (Actual: <=4 en ProductosPage/InventarioPage vs <=10 en GaleriaProductos → usar constante en `src/utils/stockStatus.js`). Extraer `authHeaders()` duplicado a `src/utils/authHeaders.js`. `App.vue.cerrarSesion` usa `authService.logout()` en vez de replicar localStorage.removeItem. **Backend:** Eliminar `var magicBytes` de `middleware/upload.go`, structs `RegisterRequest`/`TokenResponse` de `models/models.go`, alias `/api/login` de `routes/routes.go`, campo `productRepo` no usado de `VentaService`. Colapsar `GenerateToken`/`GenerateRefreshToken` en una función con parámetro duration. Relación: DT-07, DT-08, DT-09, DT-13, DT-15, DT-16 + hallazgos PonytailAudit

#### S3-HU01-T06: Control de acceso por rol + id_vendedor dinámico (Gabriel + Ignacio) — 27 jun → 2 jul
AuthMiddleware extrae `user_id` y `rol` del JWT y los pasa al handler via `context.WithValue`. Middleware `RequireRole("admin")` para rutas sensibles (CRUD productos, inventario). Frontend obtiene `id_vendedor` desde `JSON.parse(localStorage.getItem('usuario')).id` en vez de hardcodear `1`. Backend valida que id_vendedor coincida con el token. Resolver inconsistencia arquitectónica: unificar que todos los handlers reciban interfaces (como AuthHandler/ProductoHandler) o ninguno. Archivos: `middleware/auth_middleware.go`, `middleware/role_middleware.go`, `routes/routes.go`, `CarritoCompras.vue`, `handler/venta_handler.go`, `handler/inventario_handler.go`, `handler/interfaces.go`, `service/interfaces.go`. Relación: DT-04, DT-12

#### S3-HU01-T07: Sistema de Logs (Gabriel) — 2 jul → 6 jul
Implementar logging estructurado del backend a archivo (`logs/minegocio.log`) con rotación diaria. Registrar: peticiones HTTP entrantes (método, ruta, status, duración), errores de base de datos, eventos de autenticación (login exitoso/fallido, token expirado). Niveles: INFO, WARN, ERROR. No usar librerías externas (log estándar de Go + writer a archivo).

#### S3-HU01-T08: EndPoints documentados (Ignacio) — 5 jul → 8 jul
Crear documento (PDF) listando todos los endpoints de la API actual. Por cada endpoint: método HTTP, ruta completa, parámetros (query/body/headers), ejemplo de request, ejemplo de response (200/400/401/404/500), si requiere JWT. Incluir tabla de códigos de error del sistema y mapa de URLs (dev:8080, prod:8000, backend directo:3001 según mapeo de infraestructura actual).

#### S3-HU01-T09: Reportes PDF y Excel (Nicolás) — 2 jul → 8 jul
Implementar endpoints de generación de reportes descargables en el backend: `GET /api/reportes/ventas?formato=pdf&desde=&hasta=` y `GET /api/reportes/ventas?formato=xlsx&desde=&hasta=`. El reporte debe incluir: lista de ventas en el período, totales, top productos vendidos. En frontend, botón de descarga en la página de Ventas. Sin librerías externas para PDF (generar HTML → convertir con wkhtmltopdf o similar ya instalado en el servidor). Para XLSX, usar `excelize` o similar de Go.

#### S3-HU01-T10: Quitar comentarios en inglés del código (Victor) — 23 jun → 27 jun
Revisar todo el códigobase. Comentarios en inglés → español o eliminar si son redundantes. Objetivos específicos: comentarios en `models/models.go` que no aportan ("model se usa para identificar las tablas de bd y como dto"), código comentado (`//import "time"` en repository/usuario_repository.go), y hallazgos de PonytailAudit. Aplicar criterio ponytail: si el código se explica solo, el comentario sobra.

#### S3-HU01-T11: Reparar READMEs del proyecto (Victor) — 27 jun → 30 jun
Reescribir `README.md` de frontend y backend con contenido consistente. Debe incluir: descripción del proyecto, stack tecnológico (Go + gorilla/mux + PostgreSQL para backend, Vue 3 + vue-router para frontend), instrucciones paso a paso para dev (clonar, variables de entorno, DB, npm install/go run, puertos) y para prod (Docker, build, despliegue), URLs de ambientes (http://192.168.50.25:8000 prod, :8080 dev), estructura de directorios, y enlaces a documentación. Corregir inconsistencia actual (rubric: README dice nginx pero usan Docker en prod).

---

## S3-HU02: Mejora de Frontend — Interfaz Moderna con Kanban y Navegación

> **UX:** 3 | **Design:** 3 | **Front:** 13 | **Back:** 2 | **Total:** 21

> **Como** usuario, **quiero** una interfaz renovada con navegación intuitiva y un tablero Kanban de inventario **para** gestionar productos visualmente y moverme ágilmente entre secciones.

### Tareas

#### S3-HU02-T01: NavBar y SideBar (Victor) — 23 jun → 30 jun
Recuperar componentes NavBar y SideBar del STL-redesign (commits pasados). NavBar superior con logo SVG, menú de usuario (nombre desde localStorage), indicador de sesión activa y botón de cerrar sesión. SideBar colapsable con iconos y enlaces a: Dashboard, Productos, Registrados, Ventas, Inventario. Adaptar paleta actual (#D60000 primario, blanco fondo, #2C3E50 texto). Responsive: SideBar se oculta en <768px mostrando solo iconos o menú hamburguesa. Archivos: `src/components/NavBar.vue`, `src/components/SideBar.vue`, `src/components/LogoSVG.vue`, `src/App.vue` (layout con sidebar)

#### S3-HU02-T02: KanbanBoard de Inventario (Victor) — 30 jun → 4 jul
Recuperar componente KanbanBoard del STL-redesign. Tablero drag & drop con 4 columnas (Agotado — stock=0, Bajo — stock 1-4, Normal — stock 5+, Exceso — stock>20). Las cards muestran nombre, código de barras, imagen (thumbnail) y stock actual. Al soltar en otra columna, llama `PATCH /api/inventario/{id}/stock` con el nuevo valor. Si la ruta PATCH no existe en backend, crearla en `routes/routes.go`. Usar umbrales unificados (definir constante en utils/stockStatus.js). Archivos: `src/components/KanbanBoard.vue`, `routes/routes.go`, `handler/inventario_handler.go`

#### S3-HU02-T03: Dashboard principal (Victor) — 4 jul → 8 jul
Rediseñar página de inicio (`AnalisePage.vue`) con cards de KPIs: total productos, ventas del día, stock bajo (umbral <=4), productos agotados. Cada card con icono y color semántico. Enlaces rápidos a Galería, Ventas, Inventario. Últimas 5 ventas registradas (tabla pequeña). Sin librerías externas — CSS grid/flexbox nativo. Archivos: `src/views/AnalisePage.vue`

#### S3-HU02-T04: Testing frontend (Victor) — 5 jul → 8 jul
Agregar tests básicos con Vitest. Prioridad: 1 test por componente recuperado (NavBar, SideBar, KanbanBoard) verificando render básico y props. 1 test de integración para flujo login → token en localStorage → redirección. Sin TypeScript, sin librerías de test adicionales (vitest ya viene con vue-cli). Archivos: tests en `src/__tests__/`

---

## S3-HU03: Dashboard de Ventas con Estadísticas

> **UX:** 3 | **Design:** 3 | **Front:** 5 | **Back:** 8 | **Total:** 19

> **Como** administrador, **quiero** un dashboard visual de ventas con productos más vendidos, tendencias mensuales y estadísticas clave **para** tomar decisiones comerciales informadas.

### Tareas

#### S3-HU03-T01: Endpoints de estadísticas de ventas (Ignacio) — 23 jun → 28 jun
Crear endpoints backend para el dashboard:
- `GET /api/ventas/stats` — resumen del día/mes: cantidad ventas, total $, ticket promedio, producto más vendido
- `GET /api/ventas/top-productos?limite=10&desde=&hasta=` — top N productos por cantidad vendida, con nombre, código, total unidades, total $, % del total
- `GET /api/ventas/tendencias?meses=12` — array mes a mes: {mes, año, total_ventas, cantidad_ventas, variacion_% respecto al mes anterior}
Todos los endpoints requieren JWT y responden JSON. Response con errores semánticos (400 bad request si faltan parámetros, 401 si token inválido). Archivos: `handler/venta_handler.go`, `service/venta_service.go`, `repository/venta_repository.go`, `routes/routes.go`

#### S3-HU03-T02: Backend — agrupar ventas por período (Ignacio) — 28 jun → 2 jul
Consultas SQL en `venta_repository.go` para agrupar ventas: por día (`DATE(fecha_venta)`), por mes (`DATE_TRUNC('month', fecha_venta)`), por año. Calcular variación porcentual con LAG. JOIN con productos para top-productos (tabla venta_items). Escanear resultados a structs nuevas en models. Archivos: `repository/venta_repository.go`, `models/models.go`

#### S3-HU03-T03: Componentes de gráficos en frontend (Ignacio) — 2 jul → 6 jul
Componentes Vue para visualización de datos (sin librerías externas — CSS nativo + SVG inline o divs con height dinámico):
- `TopProductos.vue` — tabla ordenable + barras horizontales proporcionales al %
- `TendenciaVentas.vue` — gráfico de línea SVG con meses en eje X, monto en eje Y, tooltip al hover
- `ResumenStats.vue` — 4 cards: ventas hoy, ventas mes, ticket promedio, producto top
Props tipadas (sin TS, usar comentarios JSDoc). Cada componente acepta datos y estado de carga/error. Archivos: `src/components/TopProductos.vue`, `src/components/TendenciaVentas.vue`, `src/components/ResumenStats.vue`

#### S3-HU03-T04: Página Dashboard Ventas (Ignacio) — 6 jul → 8 jul
Nueva vista `DashboardVentas.vue` que integra los 3 componentes de stats. Layout: ResumenStats arriba (fila de 4 cards), luego TendenciaVentas (ancho completo), luego TopProductos (tabla). Selector de rango de fechas (fecha inicio, fecha fin) que recarga los datos. Ruta `/dashboard-ventas` registrada en router/index.js con meta.requiresAuth. Llamadas a los 3 endpoints con fetch nativo + auth headers. Manejo de estados: loading (skeleton/spinner), error (mensaje visible), empty (texto "sin datos"). Archivos: `src/views/DashboardVentas.vue`, `src/router/index.js`

---

## S3-HU04: Administración de Usuarios — Creación por Admin

> **UX:** 2 | **Design:** 1 | **Front:** 3 | **Back:** 5 | **Total:** 11

> **Como** administrador, **quiero** una página para crear cuentas de usuario para mis trabajadores **para** que cada vendedor tenga su propio acceso sin necesidad de registro público.

**Dependencia:** S3-HU01-T06 (control de acceso por rol) — solo accesible con rol admin.

### Tareas

#### S3-HU04-T01: Endpoint backend creación de usuarios (Nicolás) — 2 jul → 5 jul
`POST /api/usuarios` (requiere JWT + rol admin). Recibe: `{nombre, email, password, rol}`. Validaciones: email único, password mínimo 8 chars, rol válido ("admin" o "vendedor"). Guarda con bcrypt. Response: `{id, nombre, email, rol, creado_en}`. Sin endpoint de registro público — solo creación por admin. Archivos: `handler/usuario_handler.go`, `service/usuario_service.go`, `repository/usuario_repository.go`, `routes/routes.go`

#### S3-HU04-T02: Endpoint listar usuarios para admin (Nicolás) — 5 jul → 7 jul
`GET /api/usuarios` (requiere JWT + rol admin). Lista todos los usuarios del sistema: id, nombre, email, rol, fecha creación, último login. Sin contraseñas. Para que el admin pueda ver quiénes tienen acceso. Archivos: `handler/usuario_handler.go`, `repository/usuario_repository.go`

#### S3-HU04-T03: Página frontend Gestión de Usuarios (Nicolás) — 5 jul → 8 jul
Nueva vista `GestionUsuarios.vue` solo visible para admin. Formulario de creación: nombre, email, password, selector de rol (admin/vendedor), botón crear. Validaciones en frontend (email válido, password coinciden, campos obligatorios). Tabla de usuarios existentes con opción de desactivar (sin eliminar). Ruta `/gestion-usuarios` con meta.requiresAuth + meta.role="admin". Archivos: `src/views/GestionUsuarios.vue`, `src/router/index.js`

---

## Resumen de asignaciones

| HU | Tarea | Asignado | Fechas | Prioridad |
| --- | --- | --- | --- | --- |
| S3-HU01-T01 | bcrypt passwords | Gabriel | 23 jun → 27 jun | 🔴 Crítica |
| S3-HU01-T02 | JWT_SECRET por entorno | Gabriel | 23 jun → 27 jun | 🔴 Crítica |
| S3-HU01-T03 | Docker multi-arch + Jenkins | Nicolás | 23 jun → 30 jun | 🔴 Crítica |
| S3-HU01-T04 | SonarQube local + Jenkins | Nicolás | 30 jun → 4 jul | 🟡 Alta |
| S3-HU01-T05 | Limpieza código muerto (frontend+backend) | Ignacio | 23 jun → 27 jun | 🟢 Media |
| S3-HU01-T06 | Control acceso por rol + id_vendedor dinámico | Gabriel + Ignacio | 27 jun → 2 jul | 🟡 Alta |
| S3-HU01-T07 | Sistema de Logs backend | Gabriel | 2 jul → 6 jul | 🟡 Alta |
| S3-HU01-T08 | Documentación de EndPoints (PDF) | Ignacio | 5 jul → 8 jul | 🟡 Alta |
| S3-HU01-T09 | Reportes PDF y Excel descargables | Nicolás | 2 jul → 8 jul | 🟡 Alta |
| S3-HU01-T10 | Quitar comentarios en inglés del código | Victor | 23 jun → 27 jun | 🟢 Media |
| S3-HU01-T11 | Reparar READMEs (frontend+backend) | Victor | 27 jun → 30 jun | 🟢 Media |
| S3-HU02-T01 | NavBar y SideBar desde STL-redesign | Victor | 23 jun → 30 jun | 🟡 Alta |
| S3-HU02-T02 | KanbanBoard de Inventario drag & drop | Victor | 30 jun → 4 jul | 🟡 Alta |
| S3-HU02-T03 | Dashboard principal con KPIs | Victor | 4 jul → 8 jul | 🟡 Alta |
| S3-HU02-T04 | Testing frontend con Vitest | Victor | 5 jul → 8 jul | 🟢 Media |
| S3-HU03-T01 | Endpoints de estadísticas de ventas | Ignacio | 23 jun → 28 jun | 🟡 Alta |
| S3-HU03-T02 | SQL agrupación ventas por período | Ignacio | 28 jun → 2 jul | 🟡 Alta |
| S3-HU03-T03 | Componentes de gráficos (Top/Tendencia/Stats) | Ignacio | 2 jul → 6 jul | 🟡 Alta |
| S3-HU03-T04 | Página Dashboard Ventas con filtros | Ignacio | 6 jul → 8 jul | 🟡 Alta |
| S3-HU04-T01 | Endpoint creación usuarios (admin-only) | Nicolás | 2 jul → 5 jul | 🟡 Alta |
| S3-HU04-T02 | Endpoint listar usuarios (admin-only) | Nicolás | 5 jul → 7 jul | 🟡 Alta |
| S3-HU04-T03 | Página Gestión de Usuarios | Nicolás | 5 jul → 8 jul | 🟡 Alta |

---

## Enlaces relacionados

- [[Deuda Técnica]] — items DT-01 a DT-16
- [[Propuesta Taiga Sprint 3]] — propuesta anterior con más HUs
- [[rubricaEquipo6]] — rúbrica de evaluación
- [[PonytailAudit-2026-06-19]] — auditoría de código muerto e inconsistencias
- [[Auditoria-Presentacion-2026-06-20]] — auditoría de estado pre-presentación
