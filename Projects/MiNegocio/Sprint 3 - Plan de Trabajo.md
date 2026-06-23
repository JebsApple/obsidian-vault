---
tags: [proyecto/minegocio, sprint-3, plan]
---

# Sprint 3 — Plan de Trabajo

> **Deadline:** 10 julio 2026
> **Requerimientos generales:** Reportes PDF y Excel, Control de Versiones, Logs, EndPoints documentados, SonarQube desde local y Jenkins

---

## S3-HU01: Resolución de Deuda Técnica y Pipeline CI/CD

> **Como** administrador del sistema, **quiero** resolver las vulnerabilidades de seguridad y establecer un pipeline CI/CD completo **para** garantizar un despliegue seguro, auditado y automatizado.

### Tareas

#### S3-HU01-T01: bcrypt para passwords (Gabriel)
Migrar almacenamiento de contraseñas de texto plano a bcrypt en el backend. Incluye script de migración para usuarios existentes y validación dual durante la transición. Archivos: `repository/usuario_repository.go`, `service/auth_service.go`, `scripts/migrate_bcrypt.go`. Relación: DT-01

#### S3-HU01-T02: JWT_SECRET por variable de entorno (Gabriel)
Eliminar secret hardcodeado en `config/jwt.go`, leer `JWT_SECRET` de variable de entorno sin fallback. El servidor no arranca si no está definida. Archivos: `config/jwt.go`. Relación: DT-02

#### S3-HU01-T03: Docker multi-arquitectura + Pipeline Jenkins (Nicolás)
Corregir `Dockerfile` con `GOOS=linux GOARCH=amd64` explícito. Crear/actualizar `Jenkinsfile` del backend con stages: checkout → test → build docker → deploy a producción. Configurar webhook Gitea → Jenkins. Archivos: `Dockerfile`, `Jenkinsfile`. Relación: DT-03

#### S3-HU01-T04: SonarQube local + Jenkins (Nicolás)
Integrar análisis SonarQube en el pipeline de Jenkins y documentar cómo ejecutarlo localmente. Verificar que el escáner funcione desde ambos entornos.

#### S3-HU01-T05: Limpieza de código muerto (Ignacio)
Eliminar `HelloWorld.vue`, `plugins/axios.js`, `middleware/authGuard.js`, `esquema.sql`. Consolidar CSS duplicado en `GaleriaProductos.vue`. Remover `ventasService.getVenta(id)` si no se usa. Relación: DT-07, DT-08, DT-09, DT-13, DT-15, DT-16

#### S3-HU01-T06: Control de acceso por rol + id_vendedor dinámico (Gabriel + Ignacio)
AuthMiddleware extrae `user_id` y `rol` del JWT y los pasa al handler. Middleware `RequireRole("admin")` para rutas sensibles. Frontend obtiene `id_vendedor` desde localStorage en vez de hardcodear `1`. Archivos: `middleware/auth_middleware.go`, `middleware/role_middleware.go`, `routes/routes.go`, `CarritoCompras.vue`, `handler/venta_handler.go`. Relación: DT-04, DT-12

#### S3-HU01-T07: Sistema de Logs (Gabriel)
Implementar logging estructurado del backend a un archivo (`logs/minegocio.log`) con rotación. Registrar peticiones HTTP, errores, y eventos de autenticación.

#### S3-HU01-T08: EndPoints documentados (Ignacio)
Crear documento (PDF) con todos los endpoints de la API, métodos, parámetros, ejemplos de request/response.

#### S3-HU01-T09: Reportes PDF y Excel (Nicolás)
Implementar generación de reportes en formato PDF y Excel desde el backend. Endpoints `/api/reportes/ventas` que devuelvan archivos descargables con filtros por fecha.

#### S3-HU01-T10: Quitar comentarios en inglés del código (Victor)
Revisar todo el códigobase (frontend y backend) y reemplazar comentarios en inglés por español, o eliminarlos si son redundantes. Aplicar criterio ponytail: si el código se explica solo, el comentario sobra.

#### S3-HU01-T11: Reparar READMEs del proyecto (Victor)
Actualizar `README.md` de frontend y backend con: descripción del proyecto, stack tecnológico, instrucciones de instalación/ejecución, estructura de directorios, y enlaces a documentación relacionada. Unificar formato entre ambos.

---

## S3-HU02: Mejora de Frontend — Interfaz Moderna con Kanban y Navegación

> **Como** usuario, **quiero** una interfaz renovada con navegación intuitiva y un tablero Kanban de inventario **para** gestionar productos visualmente y moverme ágilmente entre secciones.

### Tareas

#### S3-HU02-T01: NavBar y SideBar (Victor)
Recuperar componentes NavBar y SideBar del STL-redesign. NavBar superior con logo, menú de usuario y notificaciones. SideBar colapsable con enlaces a todas las secciones. Adaptar a la paleta actual (#D60000, blanco, #2C3E50). Archivos: `src/components/NavBar.vue`, `src/components/SideBar.vue`, `src/components/LogoSVG.vue`

#### S3-HU02-T02: KanbanBoard de Inventario (Victor)
Recuperar componente KanbanBoard del STL-redesign. Tablero drag & drop con 4 columnas (Agotado, Bajo, Normal, Exceso). Integrar con endpoint `PATCH /api/inventario/{id}/stock`. Archivos: `src/components/KanbanBoard.vue`, `routes/routes.go` (backend, si falta la ruta)

#### S3-HU02-T03: Dashboard principal (Victor)
Página de inicio con resumen visual: cards con KPIs (total productos, ventas del día, stock bajo), enlaces rápidos a secciones. Archivos: `src/views/AnalisePage.vue`

#### S3-HU02-T04: Testing frontend (Victor)
Agregar tests básicos al frontend (al menos 1 test por componente principal) usando Vitest o Vue Test Utils.

---

## S3-HU03: Dashboard de Ventas con Estadísticas

> **Como** administrador, **quiero** un dashboard visual de ventas con productos más vendidos, tendencias mensuales y estadísticas clave **para** tomar decisiones comerciales informadas.

### Tareas

#### S3-HU03-T01: Endpoints de estadísticas de ventas (Ignacio)
Crear endpoints en el backend:
- `GET /api/ventas/stats` — resumen: total ventas mes, ventas hoy, ticket promedio
- `GET /api/ventas/top-productos?limit=10&desde=&hasta=` — productos más vendidos
- `GET /api/ventas/tendencias?meses=12` — evolución mensual de ventas
Archivos: `handler/venta_handler.go`, `service/venta_service.go`, `repository/venta_repository.go`

#### S3-HU03-T02: Backend — agrupar ventas por período (Ignacio)
Consultas SQL para agrupar ventas por día, mes, año. Calcular variación porcentual respecto al período anterior. Implementar en repository con escaneo a structs.

#### S3-HU03-T03: Componentes de gráficos en frontend (Ignacio)
Crear componentes Vue para visualizar datos: `TopProductos.vue` (tabla/barras con productos más vendidos), `TendenciaVentas.vue` (gráfico de línea con evolución mensual), `ResumenStats.vue` (cards con KPIs). Sin librerías externas (CSS nativo o SVG inline).

#### S3-HU03-T04: Página Dashboard Ventas (Ignacio)
Nueva ruta `/dashboard-ventas` con layout de estadísticas. Integrar todos los componentes de gráficos. Filtros por rango de fechas. Archivos: `src/views/DashboardVentas.vue`, `src/router/index.js`

---

## Resumen de asignaciones

| HU          | Tarea                        | Asignado          | Prioridad  |
| ----------- | ---------------------------- | ----------------- | ---------- |
| S3-HU01-T01 | bcrypt passwords             | Gabriel           | 🔴 Crítica |
| S3-HU01-T02 | JWT_SECRET por entorno       | Gabriel           | 🔴 Crítica |
| S3-HU01-T03 | Docker multi-arch + Jenkins  | Nicolás           | 🔴 Crítica |
| S3-HU01-T04 | SonarQube local + Jenkins    | Nicolás           | 🟡 Alta    |
| S3-HU01-T05 | Limpieza código muerto       | Ignacio           | 🟢 Media   |
| S3-HU01-T06 | Control acceso + id_vendedor | Gabriel + Ignacio | 🟡 Alta    |
| S3-HU01-T07 | Sistema de Logs              | Gabriel           | 🟡 Alta    |
| S3-HU01-T08 | EndPoints documentados       | Ignacio           | 🟡 Alta    |
| S3-HU01-T09 | Reportes PDF y Excel         | Nicolás           | 🟡 Alta    |
| S3-HU01-T10 | Quitar comentarios inglés    | Victor            | 🟢 Media   |
| S3-HU01-T11 | Reparar READMEs              | Victor            | 🟢 Media   |
| S3-HU02-T01 | NavBar y SideBar             | Victor            | 🟡 Alta    |
| S3-HU02-T02 | KanbanBoard                  | Victor            | 🟡 Alta    |
| S3-HU02-T03 | Dashboard principal          | Victor            | 🟡 Alta    |
| S3-HU02-T04 | Testing frontend             | Victor            | 🟢 Media   |
| S3-HU03-T01 | Endpoints estadísticas       | Ignacio           | 🟡 Alta    |
| S3-HU03-T02 | SQL agrupación ventas        | Ignacio           | 🟡 Alta    |
| S3-HU03-T03 | Componentes gráficos         | Ignacio           | 🟡 Alta    |
| S3-HU03-T04 | Página Dashboard Ventas      | Ignacio           | 🟡 Alta    |

---

## Enlaces relacionados

- [[Deuda Técnica]] — items DT-01 a DT-16
- [[Propuesta Taiga Sprint 3]] — propuesta anterior con más HUs
- [[rubricaEquipo6]] — rúbrica de evaluación
