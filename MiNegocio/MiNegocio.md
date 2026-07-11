---
tags: [proyecto, proyecto/minegocio, dropeado, portfolio]
updated: 2026-07-10
vinculos:
  - "[[Sesion-2026-06-27]]"
  - "[[Sesion-2026-06-28]]"
  - "[[Sesion-2026-06-30-tabs-archivador-sidebar]]"
  - "[[Sesion-2026-07-10-auditoria-preprod-checkpoint]]"
  - "[[Sesion-2026-07-10-handoff-opencode]]"
---

> **2026-07-10 — DROPEADO.** Proyecto archivado como portfolio. Código queda en Gitea y local pero sin desarrollo activo. Continuaré en otros proyectos de software.

> **2026-07-10 (cortado por cuota, continúa opencode):** Auditoría pre-producción en curso. **Empezar por [[Sesion-2026-07-10-handoff-opencode]]** — tiene la acción inmediata pendiente (fix a medio hacer en `Inventario.vue`) y todo lo que falta commitear. [[Sesion-2026-07-10-auditoria-preprod-checkpoint]] tiene el contexto de la primera mitad de la sesión.

# Proyecto: MiNegocio

Sistema de gestión de negocio (inventario, ventas, productos).

## Stack
- **Frontend:** Vue.js 3, vue-router, vue-cli-service — `/home/icin/minegocio-frontend/`
- **Backend:** Go, endpoints REST puerto 3000 — `/home/icin/minegocio-backend/`
- **Database:** PostgreSQL 16 — `/home/icin/minegocio-database/`
- **Paleta:** rojo `#d60000`, blanco, negro
- **Reverse Proxy:** nginx dev en puerto 8080, prod en puerto 8000 (dockerizado)

## Gitea
- URL: http://192.168.50.28:3000
- SSH: `git@gitea` (ver [[conexion-remota#SSH a Gitea para agentes AI]])
- Repos: `VHerrera/MiNegocio-frontend`, `VHerrera/MiNegocio-backend`, `VHerrera/MiNegocio-database`

## Equipo
Victor Herrera (VHerrera), Gabriel, Ignacio, Nicolás

## Ramas activas (2026-06-30)
| Repo | Rama | Estado |
|------|------|--------|
| Frontend | main | Estable. Ultimo commit: `30643e8` |
| Frontend | `dev` | OK Rama de desarrollo creada desde S3-HU02 para testeo del equipo |
| Frontend | `S3-HU02` (integradora) | OK Al dia -- contiene T13 (fusion vistas + cropper) + T14 (sidebar + pestanas archivador + fix POS) |
| Frontend | `S3-HU02-T01-navegacion-barra-lateral` | OK En Gitea |
| Frontend | `S3-HU02-T02-tablero-kanban` | OK En Gitea |
| Frontend | `S3-HU02-T03-panel-principal` | OK En Gitea |
| Frontend | `S3-HU02-T04-pruebas` | OK En Gitea |
| Frontend | `S3-HU02-T05-validaciones` | OK En Gitea |
| Frontend | `S3-HU02-T06-capas-frontend` | OK En Gitea |
| Frontend | `S3-HU02-T07-kanban-inventario` | OK En Gitea |
| Frontend | `S3-HU02-T08-ajustes-estilo` | OK En Gitea |
| Frontend | `S3-HU02-T09-nombres-archivos-espanol` | OK En Gitea |
| Frontend | `S3-HU02-T11-iconos` | OK En Gitea |
| Frontend | `S3-HU02-T12-codigo-barras-y-acceso-roles` | OK Pusheada a Gitea |
| Frontend | `S3-HU01-T05-limpieza-frontend` | OK En Gitea |
| Frontend | `S3-HU01-T10-comentarios-espanol` | OK En Gitea |
| Frontend | `S3-HU01-T11-readme-frontend` | OK En Gitea |
| Frontend | `S3-HU02-T13-fusion-vistas-recorte-imagen` | OK En Gitea |
| Frontend | `S3-HU02` (working tree) | PENDIENTE commit: T08 animaciones + T15 IVA/proveedor + fix fantasmas + kanban ubicaciones + logo landing (2026-07-02, sin push, auditado) |
| Backend | `S3-HU02-T15-iva-proveedores` (local) | PENDIENTE commit: precio_sin_iva + id_proveedor + fix fantasmas COALESCE + endpoints ubicaciones (2026-07-02, sin push) |
| Database | `S3-HU02-T15-iva-proveedores` (local) | PENDIENTE commit: proveedores + IVA/proveedor + tabla ubicaciones (2026-07-02, sin push; ALTER sin aplicar a dev) |
| Frontend | main (v3.0.0) | Tag semver -- esperar merge de S3-HU02 para v3.1.0 |
| Backend | main | Estable con JWT + Ventas API + CRUD productos |
| Backend | `S3-HU01-T01` | bcrypt passwords (Gabriel) |
| Backend | `S3-HU01-T02` | JWT_SECRET por entorno (Gabriel) |
| Backend | `feat/S3-HU02` | Kanban endpoint |
| Database | main | Esquema base |
| Database | `S3-HU02-T13-fusion-vistas-recorte-imagen` | ✅ En Gitea — esquema completo + seed usuarios DEV + migraciones |

## Frontend — Rutas
| Ruta | Vista | Auth | Descripción |
|------|-------|------|-------------|
| `/` | HomePage | No | Redirige a `/servicios` si hay sesión, o a `/login` si no |
| `/login` | LoginPage | No | Autenticación |
| `/servicios` | ServiciosPage | Sí | Dashboard con enlaces a todas las secciones |
| `/productos` | ProductosPage | Sí | CRUD productos |
| `/productos-registrados` | ProductosRegistrados | Sí | Galería con búsqueda |
| `/ventas` | VentasPage | Sí | Punto de venta con carrito y búsqueda de productos |
| `/inventario` | InventarioPage | Sí | Tabla de stock |
| `/registro-ventas` | RegistroVentasPage | Sí | Historial de ventas |
| `/contacto` | ContactoPage | No | Placeholder |
| `/admin/usuarios` | AdminUsuariosPage | Sí + admin | Placeholder gestión usuarios (solo admin) |

## Endpoints API disponibles
| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| POST | `/api/login` | No | Login legacy |
| POST | `/api/auth/login` | No | Login JWT |
| POST | `/api/auth/refresh` | No | Refresh token |
| GET | `/api/productos` | Sí | Listar activos |
| GET | `/api/productos/buscar` | Sí | Búsqueda con filtros |
| POST | `/api/productos` | Sí | Crear producto |
| PUT | `/api/productos/{id}` | Sí | Actualizar producto |
| DELETE | `/api/productos/{id}` | Sí | Soft delete |
| POST | `/api/productos/{id}/imagen` | Sí | Subir imagen |
| DELETE | `/api/productos/{id}/imagen` | Sí | Eliminar imagen |
| GET | `/api/inventario` | Sí | Inventario |
| GET | `/api/ventas` | Sí | Listar ventas |
| POST | `/api/ventas` | Sí | Crear venta |

## Entornos

### Desarrollo (DEV)
- **URL:** http://192.168.50.25:8080
- **Frontend:** `/var/www/dev/frontend/` (servido por nginx)
- **Backend:** Proceso nativo en `localhost:3000`
- **DB:** `cliente_dev`, password `Icin2026`
- **Config nginx:** `/etc/nginx/sites-available/minegocio-dev` — proxy `/api/` y `/uploads/` a localhost:3000

### Producción (PROD)
- **URL:** http://192.168.50.25:8000 (puerto 8000, nginx dockerizado)
- **Frontend:** `/var/www/prod/frontend/`
- **Backend:** NO corre actualmente (Jenkins lo despliega vía Docker)
- **DB:** `cliente_prod` (en el mismo PostgreSQL, puerto 5432)
- **Config nginx:** `/etc/nginx/sites-available/minegocio-prod` — puerto 8000, proxy a localhost:3001
- **Nota:** Cuando Jenkins despliega backend, lo hace como contenedor Docker escuchando en puerto 3001 en 192.168.50.25

### Usuarios DB
| Usuario | Password | Rol      |
| ------- | -------- | -------- |
| admin   | 1234     | admin    |
| user    | 1234     | vendedor |

## Bugs reparados (2026-06-19)
- **Ventas no registraban:** CarritoCompras.vue enviaba `precio_unitario` (backend espera `precio_venta`) y formato incorrecto. Ahora envía `{items: [{producto_id, cantidad, precio_venta}], id_vendedor}`.
- **VentasPage sin productos reales:** Usaba datos hardcodeados. Ahora carga desde `/api/productos/buscar`.
- **HomePage pantalla en blanco:** Redirige a `/login` o `/servicios` según auth.
- **Nav descentrado y sin links:** Centrado con flex. Links a Inventario, Galería, Ventas, Registro Ventas (visibles con sesión).

## Páginas agregadas (2026-06-19)
- **InventarioPage.vue** — GET /api/inventario, tabla con stock y estado.
- **RegistroVentasPage.vue** — GET /api/ventas, historial con producto, cantidad, fecha.
- **ServiciosPage.vue** — Dashboard con botones a todas las secciones.

## nginx config
- **DEV** (`sites-available/minegocio-dev`): escucha 8080, sirve `/var/www/dev/frontend/`, proxy `/api/` y `/uploads/` → `localhost:3000`
- **PROD** (`sites-available/minegocio-prod`): escucha 8000, sirve `/var/www/prod/frontend/`, proxy `/api/` y `/uploads/` → `localhost:3001`

## Jenkins CI/CD
Ver [[MiNegocio - Deploy Prod]] para instrucciones detalladas de despliegue.

## Archivos clave
- Backend: `/home/icin/minegocio-backend/main.go`
- Frontend: `/home/icin/minegocio-frontend/src/`
- DB scripts: `/home/icin/minegocio-database/`
- Nginx DEV: `/etc/nginx/sites-available/minegocio-dev`
- Nginx PROD: `/etc/nginx/sites-available/minegocio-prod`
