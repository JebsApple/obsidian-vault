---
tags: [minegocio, ponytail, auditoria]
---

# Ponytail Audit — MiNegocio Sprint 3
**Fecha:** 2026-06-23 | **Scope:** Backend Go + Frontend Vue.js + DevOps | **Modo:** full

---

## Estado actual antes del Sprint 3

### Backend Go — Hallazgos

`delete` **`var magicBytes`** — middleware/upload.go declara variable global que nunca se lee. `DetectImageMIME` usa lógica inline. → Victor HU01-T05

`delete` **`RegisterRequest` y `TokenResponse`** — structs en models/models.go sin uso real. → Gabriel HU01-T05

`delete` **`router.HandleFunc("/api/login", ...)`** — alias redundante en routes/routes.go. → Gabriel HU01-T05

`delete` **`productRepo *repository.ProductoRepository`** en VentaService — campo inyectado pero jamás accedido. → Ignacio HU01-T05

`yagni` **Interfaces decorativas** — `VentaRepositoryI`, `VentaServiceI`, `InventarioHandler` sin uso real como tipos. `AuthHandler` y `ProductoHandler` sí usan interfaces → inconsistencia. → Gabriel HU01-T06

`shrink` **`GenerateToken` y `GenerateRefreshToken`** — código duplicado, solo varía la duración. Colapsar en una función privada. → Gabriel HU01-T05

`security` **bcrypt** — contraseñas en texto plano. → Gabriel HU01-T01

`security` **JWT_SECRET hardcodeado** — en config/jwt.go. → Gabriel HU01-T02

`missing` **Logs** — sin sistema de logging. → Gabriel HU01-T07

`missing` **Control de acceso por rol** — cualquiera con token puede todo. → Gabriel HU01-T06

`missing` **id_vendedor hardcodeado** — CarritoCompras.vue usa `id_vendedor: 1`. → Ignacio HU01-T06

### Frontend Vue.js — Hallazgos

`delete` **`HelloWorld.vue`** — scaffold vue-cli sin uso. → Victor HU01-T05

`delete` **`authGuard.js`** — no importado, reemplazado por meta.requiresAuth. → Gabriel HU01-T05

`delete` **`axios.js`** + dependencia axios — el proyecto usa fetch nativo. → Gabriel HU01-T05

`delete` **`ventasService.getVenta(id)`** — endpoint inexistente. → Ignacio HU01-T05

`delete` **`ContactoPage.vue` + `contacto.css`** — página placeholder sin uso. → Ignacio HU01-T05

`shrink` **`App.vue.cerrarSesion`** — duplica authService.logout(). → Victor HU01-T05

`shrink` **Umbral stock duplicado** — <=4 vs <=10 según el componente. Extraer a utils/stockStatus.js. → Victor HU01-T05

`native` **`authHeaders()` duplicado** — en productosService.js y ventasService.js. Extraer a utils/authHeaders.js. → Ignacio HU01-T05

`missing` **NavBar/SideBar** — navegación básica actual sin sidebar. → Victor HU02-T01

`missing` **Dashboard KPIs** — página principal sin indicadores. → Victor HU02-T03

`missing` **Validaciones + errores visibles** — rúbrica penaliza. → Victor HU02-T05

`missing` **Testing** — sin tests frontend. → Victor HU02-T04

### DevOps — Hallazgos

`bug` **Dockerfile sin GOARCH** — compila para arquitectura incorrecta en algunos entornos. → Nicolás HU01-T03

`missing` **Jenkinsfile frontend** — solo existe backend. → Nicolás HU01-T12

`missing` **SonarQube** — no integrado. → Nicolás HU01-T04

`security` **Usuario BD postgres** — usa superusuario. → Ignacio HU01-T13

`security` **Usuario Jenkins icin** — demasiados permisos. → Nicolás HU01-T14

`missing` **READMEs inconsistentes** — nginx vs Docker. → Victor HU01-T11

`missing` **Comentarios en inglés** — mezcla de idiomas. → Victor HU01-T10

### Backend Features Nuevas — Hallazgos

`missing` **Endpoints stats ventas** — no existe GET /api/ventas/stats, top-productos, tendencias. → Ignacio HU03-T01/T02

`missing` **Reportes PDF/Excel** — no existe GET /api/reportes/ventas. → Gabriel HU03-T05

`missing` **Endpoints documentados** — sin documento de API. → Ignacio HU01-T08

`missing` **CRUD usuarios** — no existe POST/GET /api/usuarios. → Nicolás HU04-T01/T02

### Frontend Features Nuevas — Hallazgos

`missing` **KanbanBoard** — sin tablero visual de inventario. → Victor HU02-T02

`missing` **Dashboard Ventas** — sin página de estadísticas. → Ignacio HU03-T03/T04

`missing` **Gestión Usuarios** — sin página admin. → Nicolás HU04-T03

---

## Resumen de deuda por integrante

| Integrante | Tasks | Tipo |
|------------|-------|------|
| **Gabriel** | T01 bcrypt, T02 JWT_SECRET, T05 limpieza (backend), T06 roles (backend), T07 logs, HU03-T05 reportes | Seguridad + limpieza + features |
| **Ignacio** | T05 limpieza (frontend), T06 roles (frontend), T08 endpoints doc, HU03-T01/T02 stats, HU03-T03/T04 dashboard, HU01-T13 DB user | Limpieza + features + DevOps |
| **Nicolás** | HU01-T03 Docker/Jenkins back, HU01-T04 SonarQube, HU01-T12 Frontend CI/CD, HU01-T14 Jenkins user, HU04 usuarios | DevOps + features |
| **Victor** | HU01-T05 limpieza (frontend), HU01-T10 comentarios, HU01-T11 READMEs, HU02-T01 NavBar/SideBar, HU02-T02 Kanban, HU02-T03 Dashboard, HU02-T04 Testing, HU02-T05 validaciones | Limpieza + rediseño + testing |

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[PonytailAudit - Sprint 2]]
