---
tags: [proyecto, minegocio, activo]
updated: 2026-06-19
---

# Proyecto: MiNegocio

Sistema de gestión de negocio (inventario, ventas, productos).

## Stack
- **Frontend:** Vue.js 3, vue-router, vue-cli-service — `/home/icin/minegocio-frontend/`
- **Backend:** Go, endpoints REST puerto 3000 — `/home/icin/minegocio-backend/`
- **Database:** PostgreSQL — `/home/icin/minegocio-database/`
- **Paleta:** rojo `#d60000`, blanco, negro
- **Reverse Proxy:** nginx en puerto 80 (PROD) y 8080 (DEV)

## Gitea
- URL: http://192.168.50.28:3000
- SSH: `git@gitea` (ver [[conexion-remota#SSH a Gitea para agentes AI]])
- Repos: `VHerrera/MiNegocio-frontend`, `VHerrera/MiNegocio-backend`, `VHerrera/MiNegocio-database`

## Equipo
Victor Herrera (VHerrera), Gabriel, Ignacio, Nicolás

## Ramas activas (2026-06-19)
| Repo | Rama | Estado |
|------|------|--------|
| Frontend | main | STL-Redesign revertido ✅, funcionalidades S2 conservadas (JWT, Carga Imágenes, UX Login) |
| Backend | main | JWT + Ventas API integrados ✅ |
| Database | 240Optimizacion&softdelete | Activa |

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

## Entornos DEV
- **Frontend DEV:** http://192.168.50.25:8080 (nginx) y http://192.168.50.25:8081 (container)
- **Backend DEV:** http://192.168.50.25:3000 (container)
- **PROD:** nginx puerto 80 → `/var/www/prod/frontend/`

## Usuarios
| Entorno | Email | Password | Rol |
|---------|-------|----------|-----|
| DEV | admin@test.com | 1234 | admin |
| PROD | Victor@user.cl | Victor264 | admin |

## S2-Post-STL-Revert (COMPLETADO 2026-06-19)
- Reversión del STL-Frontend-Redesign (pospuesto a S3)
- JWT Backend + Frontend (S2-HU03)
- Ventas API backend (S2-HU02-API)
- Carga de imágenes drag&drop preservada (S2-HU04)
- UX Login con paleta #D60000/blanco/#2C3E50
- Ver reporte detallado: [[S2-Post-STL-Revert-Report]]

## nginx config
- **DEV** (`sites-available/minegocio-dev`): escucha 8080, sirve `/var/www/dev/frontend/`, proxy `/api/` → `localhost:3000`
- **PROD** (`sites-available/minegocio-prod`): escucha 80, sirve `/var/www/prod/frontend/`
