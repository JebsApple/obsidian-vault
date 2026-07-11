---
tags: [proyecto/minegocio, sprint-3, hu05]
---

## S3-HU05: Separación de Entornos Dev/Prod

> **UX:** 0 | **Design:** 0 | **Front:** 0 | **Back:** 2 | **DevOps:** 3 | **Total:** 5

Storyless task — crear usuarios PostgreSQL dedicados por entorno, dockerizar backend DEV en `:3000`, migrar PROD a su propio usuario y limpiar contenedores fantasma.

**Contexto:** Antes de esta HU, ambos entornos compartían el superusuario `postgres` de PostgreSQL y el backend DEV estaba caído. Se crearon usuarios DB dedicados, se dockerizó DEV en `:3000`, se actualizó PROD a su propio usuario, y se limpiaron contenedores fantasma. Jenkins deploya solo a PROD desde `main` — DEV se actualiza manualmente.

**Arquitectura final:**

```
Usuario → :8080 (nginx DEV) → :3000 (Docker backend DEV) → cliente_dev (minegocio_dev)
Usuario → :8000 (nginx PROD) → :3001 (Docker backend PROD) → cliente_prod (minegocio_prod)
                              PostgreSQL nativo :5432
```

### Tareas

#### S3-HU05-T01: Usuarios PostgreSQL dedicados (Victor) — 27 jun → 27 jun `[database]` `[devops]`
Crear dos usuarios PostgreSQL con permisos mínimos, uno por entorno, eliminando la dependencia del superusuario `postgres`. Cada usuario solo puede conectar a su base de datos correspondiente (cross-DB access bloqueado).

```sql
CREATE USER minegocio_dev WITH PASSWORD 'Icin2026Dev';
GRANT CONNECT ON DATABASE cliente_dev TO minegocio_dev;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO minegocio_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO minegocio_dev;

CREATE USER minegocio_prod WITH PASSWORD 'Icin2026Prod';
GRANT CONNECT ON DATABASE cliente_prod TO minegocio_prod;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO minegocio_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO minegocio_prod;

REVOKE CONNECT ON DATABASE cliente_dev FROM PUBLIC;
REVOKE CONNECT ON DATABASE cliente_prod FROM PUBLIC;
```

Verificación: `PGPASSWORD=Icin2026Dev psql -h localhost -U minegocio_dev -d cliente_dev -c "SELECT count(*) FROM productos;"` debe responder 14. Archivos: N/A (SQL directo en DB).

#### S3-HU05-T02: Dockerizar backend DEV en :3000 (Victor) — 27 jun → 28 jun `[backend]` `[devops]`
Buildear imagen `minegocio-backend:dev` desde el código actual y correr contenedor `minegocio-backend-dev` en puerto `:3000`. Variables de entorno apuntan a `cliente_dev` / `minegocio_dev` con `JWT_SECRET=MiNegocioDev2026!` y `APP_ENV=development`. Verificar login (admin/1234), productos, inventario y que nginx `:8080` proxy correctamente.

```bash
docker build -t minegocio-backend:dev .
docker run -d --name minegocio-backend-dev -p 3000:3000 \
  -e DB_HOST=172.17.0.1 -e DB_PORT=5432 -e DB_NAME=cliente_dev \
  -e DB_USER=minegocio_dev -e DB_PASSWORD=Icin2026Dev -e DB_SSLMODE=disable \
  -e JWT_SECRET=MiNegocioDev2026! -e JWT_EXPIRATION=86400 \
  -e JWT_REFRESH_EXPIRATION=604800 -e APP_ENV=development \
  --restart unless-stopped minegocio-backend:dev
```

Archivos: `Dockerfile`

#### S3-HU05-T03: Migrar backend PROD a minegocio_prod (Victor) — 28 jun → 28 jun `[backend]` `[devops]`
Recrear contenedor `minegocio-backend` (`:3001`) con `DB_USER=minegocio_prod` y `DB_PASSWORD=Icin2026Prod` en vez de `postgres`. Mismos JWT_SECRET y APP_ENV que antes. Verificar login (Victor/Victor264), productos, y que nginx `:8000` proxy correctamente. Opcional: usar rename trick para evitar downtime.

```bash
docker run -d --name minegocio-backend -p 3001:3000 \
  -e DB_HOST=172.17.0.1 -e DB_PORT=5432 -e DB_NAME=cliente_prod \
  -e DB_USER=minegocio_prod -e DB_PASSWORD=Icin2026Prod -e DB_SSLMODE=disable \
  -e JWT_SECRET=ProdSecretKey2026! -e JWT_EXPIRATION=86400 \
  -e JWT_REFRESH_EXPIRATION=604800 -e APP_ENV=production \
  --restart unless-stopped minegocio-backend:latest
```

Archivos: N/A (Docker runtime).

#### S3-HU05-T04: Limpieza de contenedores fantasma (Victor) — 28 jun → 28 jun `[devops]`
Eliminar contenedores muertos: `frontend-dev`, `backend-dev`, `db-prod`, `nifty_albattani`. Eliminar Docker frontend fantasma (`frontend`, nginx `:8081`, redundante con nginx nativo). Detener `sandbox-db` (PostgreSQL temporal `:5433`, conservar imagen). Verificar que solo queden los 2 contenedores activos: `minegocio-backend` (PROD) y `minegocio-backend-dev` (DEV).

```bash
docker stop frontend && docker rm frontend
docker rm frontend-dev backend-dev db-prod nifty_albattani
docker stop sandbox-db && docker rm sandbox-db
```

Archivos: N/A.

#### S3-HU05-T05: Verificación integral de entornos separados (Victor) — 28 jun → 28 jun `[test]` `[devops]`
Test completo de ambos entornos de forma independiente:

| Test | Esperado |
|------|----------|
| Login DEV (admin/1234) → token | ✅ Token JWT |
| GET /api/productos DEV con token | ✅ HTTP 200 |
| GET /api/inventario DEV con token | ✅ HTTP 200 |
| Via nginx :8080 DEV | ✅ HTTP 200 |
| Login PROD (Victor/Victor264) → token | ✅ Token JWT |
| GET /api/productos PROD con token | ✅ HTTP 200 |
| Via nginx :8000 PROD | ✅ HTTP 200 |
| Token DEV contra API PROD | ✅ HTTP 401 |
| Token PROD contra API DEV | ✅ HTTP 401 |
| DB `cliente_dev` (minegocio_dev) | ✅ 14 productos |
| DB `cliente_prod` (minegocio_prod) | ✅ 3 productos |

Archivos: N/A (tests de integración vía curl).

---

## Resumen de cambios

| Componente | Antes | Después |
|------------|-------|---------|
| Usuario DB PROD | `postgres` (superuser) | `minegocio_prod` |
| Usuario DB DEV | inexistente | `minegocio_dev` |
| Backend DEV | Puerto :3000 caído | Docker `minegocio-backend-dev` en :3000 |
| Backend PROD | :3001 con `postgres` | :3001 con `minegocio_prod` |
| Docker frontend (:8081) | nginx fantasma | **Eliminado** |
| Contenedores muertos | frontend-dev, backend-dev, db-prod | **Eliminados** |
| sandbox-db (:5433) | PostgreSQL temporal | **Detenido** (imagen conservada) |
| Tokens JWT | Un solo secreto | `MiNegocioDev2026!` vs `ProdSecretKey2026!` |

## Dependencias

- S3-HU05-T01 (usuarios DB) bloquea T02 (Docker DEV) y T03 (actualizar PROD)
- S3-HU05-T01 reduce alcance de S3-HU01-T13 (Ignacio): ya no crea usuarios, solo los documenta
- S3-HU05 completa afecta a S3-HU01-T11 (Victor): README debe documentar arquitectura 2 entornos
- Jenkins (S3-HU01-T03/T12) no requiere cambios — deploya solo a PROD desde `main`

## Procedimiento detallado

Ver [[MiNegocio/Procedimientos/HU05 - Separación Entornos/Procedimiento - Victor]] para el procedimiento paso a paso con comandos exactos, verificación y rollback.

## Enlaces relacionados

- [[MiNegocio/Procedimientos/HU05 - Separación Entornos/Procedimiento - Victor]] — procedimiento detallado
- [[MiNegocio/Tareas/taiga-updates-S3]] — addendum Taiga con cambios en tareas
- [[MiNegocio/Tareas/proc-front]] — plan base frontend S3-HU02
