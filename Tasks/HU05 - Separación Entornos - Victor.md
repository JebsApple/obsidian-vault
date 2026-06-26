---
tags: [proyecto/minegocio, sprint-3, procedimiento, victor, hu05]
---

# Procedimiento — Victor — HU05: Separación de Entornos Dev/Prod

> **Fechas:** 27 jun → 2 jul (después de T05/T10)
> **Dependencias:** N/A (no depende de otros — otros dependen de esto)
> **Bloquea:** T13 de Ignacio (usuarios DB), tests de integración de Gabriel, despliegues de Nicolás

## ¿Qué estamos haciendo y por qué?

Hoy el backend PROD (`:3001`) y el futuro backend DEV (`:3000`) comparten el superusuario `postgres` de PostgreSQL. El profesor nos bajó puntos por esto en la rúbrica. Vamos a:

1. Crear **dos usuarios PostgreSQL dedicados**, uno por entorno
2. Dockerizar el backend DEV en puerto `:3000` (hoy caído/muerto)
3. Actualizar el backend PROD para usar el nuevo usuario
4. Limpiar contenedores fantasma
5. Dejar la infraestructura lista para el resto del equipo

**Arquitectura final:**

```
Usuario → :8080 (nginx DEV) → :3000 (Docker backend DEV) → cliente_dev (user: minegocio_dev)
Usuario → :8000 (nginx PROD) → :3001 (Docker backend PROD) → cliente_prod (user: minegocio_prod)
                                     ambas DBs en PostgreSQL nativo :5432
```

Jenkins solo deploya a PROD desde `main`. DEV se actualiza manualmente.

---

## Fase 0 — Crear usuarios PostgreSQL

Conectar a PostgreSQL como superusuario y crear los dos usuarios:

```bash
sudo -u postgres psql
```

```sql
-- Usuario DEV
CREATE USER minegocio_dev WITH PASSWORD 'Icin2026Dev';
GRANT CONNECT ON DATABASE cliente_dev TO minegocio_dev;
GRANT USAGE ON SCHEMA public TO minegocio_dev;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO minegocio_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO minegocio_dev;

-- Usuario PROD
CREATE USER minegocio_prod WITH PASSWORD 'Icin2026Prod';
GRANT CONNECT ON DATABASE cliente_prod TO minegocio_prod;
GRANT USAGE ON SCHEMA public TO minegocio_prod;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO minegocio_prod;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO minegocio_prod;

-- Verificar
\du
\c cliente_dev
SELECT current_user;
\c cliente_prod
SELECT current_user;
```

Salir de psql con `\q`.

### Verificación

```bash
PGPASSWORD=Icin2026Dev psql -h localhost -U minegocio_dev -d cliente_dev -c "SELECT count(*) FROM productos;"
PGPASSWORD=Icin2026Prod psql -h localhost -U minegocio_prod -d cliente_prod -c "SELECT count(*) FROM productos;"
```

Ambos deben responder con un número (no "access denied").

---

## Fase 1 — Backend DEV en Docker (:3000)

### 1. Buildear imagen

```bash
cd /home/icin/minegocio-backend
docker build -t minegocio-backend:dev .
```

### 2. Correr contenedor DEV

```bash
docker run -d \
  --name minegocio-backend-dev \
  -p 3000:3000 \
  -e DB_HOST=172.17.0.1 \
  -e DB_PORT=5432 \
  -e DB_NAME=cliente_dev \
  -e DB_USER=minegocio_dev \
  -e DB_PASSWORD=Icin2026Dev \
  -e DB_SSLMODE=disable \
  -e JWT_SECRET=MiNegocioDev2026! \
  -e JWT_EXPIRATION=86400 \
  -e JWT_REFRESH_EXPIRATION=604800 \
  -e APP_ENV=development \
  --restart unless-stopped \
  minegocio-backend:dev
```

### 3. Verificar

```bash
# Logs del contenedor
docker logs minegocio-backend-dev

# API responde
curl -s http://localhost:3000/api/productos | head -c 200

# Nginx dev proxies correctamente
curl -s http://localhost:8080/api/productos | head -c 200
```

Si la API responde 401 (por JWT), es señal de que el servidor está vivo. Hacer un login:

```bash
curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin","password":"1234"}' | head -c 300
```

---

## Fase 2 — Actualizar backend PROD a usuario dedicado

El contenedor `minegocio-backend` actual usa `DB_USER=postgres`. Vamos a actualizarlo a `minegocio_prod`.

### Opción A: recrear el contenedor (recomendada)

```bash
docker stop minegocio-backend
docker rm minegocio-backend

docker run -d \
  --name minegocio-backend \
  -p 3001:3000 \
  -e DB_HOST=172.17.0.1 \
  -e DB_PORT=5432 \
  -e DB_NAME=cliente_prod \
  -e DB_USER=minegocio_prod \
  -e DB_PASSWORD=Icin2026Prod \
  -e DB_SSLMODE=disable \
  -e JWT_SECRET=ProdSecretKey2026! \
  -e JWT_EXPIRATION=86400 \
  -e JWT_REFRESH_EXPIRATION=604800 \
  -e APP_ENV=production \
  --restart unless-stopped \
  minegocio-backend:latest
```

### Opción B: sin recrear (para evitar downtime)

```bash
docker rename minegocio-backend minegocio-backend-old
# Correr el mismo comando de Opción A
docker run -d ... (mismos args)
# Verificar que funciona
curl http://localhost:3001/api/productos
# Eliminar el viejo
docker rm minegocio-backend-old
```

### Verificación PROD

```bash
# API responde
curl -s http://localhost:3001/api/productos | head -c 200

# Nginx prod proxies correctamente
curl -s http://localhost:8000/api/productos | head -c 200

# Login
curl -s -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin","password":"1234"}' | head -c 300
```

---

## Fase 3 — Limpieza de contenedores

### Eliminar Docker frontend fantasma (:8081)

```bash
docker stop frontend
docker rm frontend
```

Este contenedor montaba `/home/icin/minegocio-frontend/dist/` en nginx, pero ya tenemos nginx nativo haciendo esto mejor en `:8000` y `:8080`.

### Detener sandbox-db (opcional)

```bash
docker stop sandbox-db
docker rm sandbox-db
```

Conservar la imagen por si la necesitas después para tests.

### Verificar contenedores activos

```bash
docker ps
# Deberías ver solo:
# - minegocio-backend (PROD, :3001)
# - minegocio-backend-dev (DEV, :3000)
```

---

## Fase 4 — Verificación final del sistema

### Test integral DEV

```bash
# 1. Login
TOKEN_DEV=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin","password":"1234"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# 2. CRUD productos
curl -s http://localhost:8080/api/productos -H "Authorization: Bearer $TOKEN_DEV" | python3 -m json.tool 2>/dev/null | head -20

# 3. Inventario
curl -s http://localhost:8080/api/inventario -H "Authorization: Bearer $TOKEN_DEV" | python3 -m json.tool 2>/dev/null | head -20
```

### Test integral PROD

```bash
# Login
TOKEN_PROD=$(curl -s -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin","password":"1234"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# CRUD productos
curl -s http://localhost:8000/api/productos -H "Authorization: Bearer $TOKEN_PROD" | python3 -m json.tool 2>/dev/null | head -20
```

### Verificar JWT_SECRETs distintos

Los tokens de DEV no deben funcionar en PROD y viceversa:

```bash
# Token DEV contra API PROD → debe dar 401
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/productos \
  -H "Authorization: Bearer $TOKEN_DEV"
# → debe responder 401
```

---

## Rollback (si algo sale mal)

### Volver a usuario postgres en PROD

```bash
docker stop minegocio-backend && docker rm minegocio-backend
docker run -d --name minegocio-backend -p 3001:3000 \
  -e DB_HOST=172.17.0.1 -e DB_PORT=5432 -e DB_NAME=cliente_prod \
  -e DB_USER=postgres -e DB_PASSWORD=Icin2026 \
  -e DB_SSLMODE=disable \
  -e JWT_SECRET=ProdSecretKey2026! -e APP_ENV=production \
  minegocio-backend:latest
```

### Eliminar usuarios PostgreSQL

```sql
REVOKE ALL PRIVILEGES ON DATABASE cliente_dev FROM minegocio_dev;
DROP USER IF EXISTS minegocio_dev;
REVOKE ALL PRIVILEGES ON DATABASE cliente_prod FROM minegocio_prod;
DROP USER IF EXISTS minegocio_prod;
```

---

## Resumen de cambios

| Componente | Antes | Después |
|------------|-------|---------|
| Usuario DB PROD | `postgres` (superuser) | `minegocio_prod` |
| Usuario DB DEV | inexistente | `minegocio_dev` |
| Backend DEV | Puerto :3000 caído | Docker `minegocio-backend-dev` en :3000 |
| Backend PROD | :3001 con `postgres` | :3001 con `minegocio_prod` |
| Docker frontend (:8081) | nginx fantasma | **Eliminado** |
| sandbox-db (:5433) | PostgreSQL temporal | **Detenido** (imagen conservada) |
