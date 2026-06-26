---
tags: [proyecto/minegocio, sprint-3, procedimiento, victor, hu05]
---

# Procedimiento — Victor — HU05: Separación de Entornos Dev/Prod

**Fechas:** 27 jun → 28 jun

---

## Fase 0 — Crear usuarios PostgreSQL

```bash
PGPASSWORD=Icin2026 psql -h localhost -U postgres
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

-- Bloquear cross-DB access
REVOKE CONNECT ON DATABASE cliente_dev FROM PUBLIC;
REVOKE CONNECT ON DATABASE cliente_prod FROM PUBLIC;
GRANT CONNECT ON DATABASE cliente_dev TO minegocio_dev, postgres;
GRANT CONNECT ON DATABASE cliente_prod TO minegocio_prod, postgres;
```

### Verificación

```bash
PGPASSWORD=Icin2026Dev psql -h localhost -U minegocio_dev -d cliente_dev -c "SELECT count(*) FROM productos;"
# → 14

PGPASSWORD=Icin2026Prod psql -h localhost -U minegocio_prod -d cliente_prod -c "SELECT count(*) FROM productos;"
# → 3

# Cross-DB debe fallar
PGPASSWORD=Icin2026Dev psql -h localhost -U minegocio_dev -d cliente_prod -c "SELECT 1;"
# → FATAL: permission denied for database "cliente_prod"
```

---

## Fase 1 — Dockerizar backend DEV en :3000

```bash
# Buildear imagen
cd /home/icin/minegocio-backend
docker build -t minegocio-backend:dev .

# Correr contenedor DEV
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

### Verificación DEV

```bash
# Login (user y pass, no email/password)
TOKEN_DEV=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"user":"admin","pass":"1234"}' | python3 -c "import sys,json; print(json.load(sys.stdin).get('token','NO_TOKEN'))")

# Productos
curl -s http://localhost:3000/api/productos -H "Authorization: Bearer $TOKEN_DEV" | head -c 200

# Via nginx
curl -s http://localhost:8080/api/productos -H "Authorization: Bearer $TOKEN_DEV" | head -c 200
```

---

## Fase 2 — Migrar PROD a minegocio_prod

```bash
# Opción con rename (mínimo downtime)
docker rename minegocio-backend minegocio-backend-old

# Crear nuevo contenedor
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

# Verificar que funciona
sleep 2
curl -s http://localhost:3001/api/productos | head -c 100

# Eliminar contenedor viejo
docker rm minegocio-backend-old
```

### Verificación PROD

```bash
TOKEN_PROD=$(curl -s -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"user":"Victor","pass":"Victor264"}' | python3 -c "import sys,json; print(json.load(sys.stdin).get('token','NO_TOKEN'))")

curl -s http://localhost:3001/api/productos -H "Authorization: Bearer $TOKEN_PROD" | head -c 200
curl -s http://localhost:8000/api/productos -H "Authorization: Bearer $TOKEN_PROD" | head -c 200
```

---

## Fase 3 — Limpieza

```bash
# Eliminar contenedores muertos
docker rm frontend-dev backend-dev db-prod nifty_albattani

# Eliminar frontend fantasma (nginx :8081)
docker stop frontend && docker rm frontend

# Detener sandbox-db (temporal)
docker stop sandbox-db && docker rm sandbox-db
```

---

## Fase 4 — Verificación integral

```bash
# Tokens no deben funcionar entre entornos
CROSS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/api/productos -H "Authorization: Bearer $TOKEN_DEV")
echo "Token DEV en PROD: HTTP $CROSS (debe ser 401)"

CROSS2=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/productos -H "Authorization: Bearer $TOKEN_PROD")
echo "Token PROD en DEV: HTTP $CROSS2 (debe ser 401)"
```

---

## Rollback

### Volver a postgres en PROD

```bash
docker stop minegocio-backend && docker rm minegocio-backend
docker run -d --name minegocio-backend -p 3001:3000 \
  -e DB_HOST=172.17.0.1 -e DB_PORT=5432 -e DB_NAME=cliente_prod \
  -e DB_USER=postgres -e DB_PASSWORD=Icin2026 -e DB_SSLMODE=disable \
  -e JWT_SECRET=ProdSecretKey2026! -e APP_ENV=production \
  --restart unless-stopped minegocio-backend:latest
```

### Eliminar usuarios DB

```sql
REVOKE ALL PRIVILEGES ON DATABASE cliente_dev FROM minegocio_dev;
DROP USER IF EXISTS minegocio_dev;
REVOKE ALL PRIVILEGES ON DATABASE cliente_prod FROM minegocio_prod;
DROP USER IF EXISTS minegocio_prod;
```

---

## Keywords para la exposición

| Pregunta | Respuesta |
|----------|-----------|
| ¿Por qué dos usuarios DB en vez de uno? | Principio de mínimo privilegio: cada entorno solo ve sus datos. Si un entorno se compromete, el otro no se afecta. |
| ¿Por qué no separar por puerto de DB? | Simplifica administración (un solo PostgreSQL). La separación lógica por DB name + usuario es suficiente. |
| ¿Por qué Docker para DEV si es manual? | El mismo binario (Go) corre en ambos entornos sin compilar dos veces. Solo cambian las variables de entorno. |
| ¿Qué pasa si olvido setear JWT_SECRET? | El servidor no arranca — T02 fuerza panic si no hay JWT_SECRET. |
