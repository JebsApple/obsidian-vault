---
tags: [proyecto/minegocio, hotfix, deploy, bcrypt, login]
---

# Hotfix Login Bcrypt — Guía Paso a Paso

## Archivos a subir

Ubicación local: `~/hotfix-bcrypt/`

| Archivo | Repo Gitea | Carpeta destino en Gitea |
|---------|-----------|--------------------------|
| `hotfix_usuarios.sql` | MiNegocio-database | `postgres/` |
| `setup_produccion.sql` | MiNegocio-database | `postgres/` |
| `backup_server.sql` | MiNegocio-database | `postgres/` |
| `README.md` | MiNegocio-database | raíz `/` |
| `fix_admin_password.sql` | MiNegocio-backend | raíz `/` |

---

## PARTE A — Subir a Gitea (database)

### A1. Abrir Gitea

Abrir en navegador:
```
http://192.168.50.28:3000/VHerrera/MiNegocio-database
```

### A2. Navegar a carpeta postgres

Click en carpeta `postgres/` para entrar.

### A3. Subir hotfix_usuarios.sql

1. Click botón **"Upload file"** (esquina superior derecha)
2. Arrastrar `~/hotfix-bcrypt/hotfix_usuarios.sql` al área de.drop
3. **Commit message:** `fix: bcrypt hashes para todos los usuarios`
4. Click **"Commit Changes"**

### A4. Subir setup_produccion.sql

1. Click **"Upload file"**
2. Arrastrar `~/hotfix-bcrypt/setup_produccion.sql`
3. **Commit message:** `fix: seed prod users con bcrypt hashes`
4. Click **"Commit Changes"**

### A5. Subir backup_server.sql

1. Click **"Upload file"**
2. Arrastrar `~/hotfix-bcrypt/backup_server.sql`
3. **Commit message:** `fix: admin password bcrypt en backup`
4. Click **"Commit Changes"**

### A6. Subir README.md

1. Navegar a la raíz del repo (click `MiNegocio-database` en el breadcrumb)
2. Click **"Upload file"**
3. Arrastrar `~/hotfix-bcrypt/README.md`
4. **Commit message:** `fix: nota bcrypt resuelta en README`
5. Click **"Commit Changes"**

---

## PARTE B — Subir a Gitea (backend)

### B1. Abrir Gitea

```
http://192.168.50.28:3000/VHerrera/MiNegocio-backend
```

### B2. Subir fix_admin_password.sql

1. Click **"Upload file"**
2. Arrastrar `~/hotfix-bcrypt/fix_admin_password.sql`
3. **Commit message:** `fix: WHERE clause en fix_admin_password`
4. Click **"Commit Changes"**

---

## PARTE C — Ejecutar en el server

### C1. Conectar al server

```bash
ssh icin@192.168.50.25
```

### C2. Clonar el repo actualizado

```bash
cd /tmp
rm -rf MiNegocio-database
git clone git@gitea:VHerrera/MiNegocio-database.git
```

> Si `git@gitea` no funciona, usar HTTP:
> ```bash
> git clone http://192.168.50.28:3000/VHerrera/MiNegocio-database.git
> ```

### C3. Ejecutar en DEV

```bash
sudo -u postgres psql -d cliente_dev -f /tmp/MiNegocio-database/postgres/hotfix_usuarios.sql
```

**Resultado esperado:** 6 filas INSERTadas/actualizadas + tabla final con 6 usuarios con hashes `$2a$...`

### C4. Verificar DEV

```bash
sudo -u postgres psql -d cliente_dev -c "SELECT nombre, email, LEFT(password_hash,20) as hash, rol FROM usuarios;"
```

**Debe mostrar:**

| nombre           | hash (inicio)        | rol     |
| ---------------- | -------------------- | ------- |
| administrador    | $2a$10$w5WkAGIo1r... | admin   |
| usuario          | $2a$10$nJLxixmIl5... | usuario |
| VictorAdmin      | $2a$10$xMq.Y1XATM... | admin   |
| IgnacioAdmin     | $2a$10$MduST0JZC9... | admin   |
| NicolasVendedor  | $2a$10$ldDfsujus5... | usuario |
| GabrielLogistica | $2a$10$ldDfsujus5... | usuario |

### C5. Test login DEV

Abrir en navegador:
```
http://192.168.50.25:8080
```

Login con:
- **Usuario:** `administrador`
- **Pass:** `admin123`

Si ingresa al dashboard → ✅ DEV funciona.

### C6. Ejecutar en PROD

```bash
sudo -u postgres psql -d cliente_prod -f /tmp/MiNegocio-database/postgres/hotfix_usuarios.sql
```

### C7. Verificar PROD

```bash
sudo -u postgres psql -d cliente_prod -c "SELECT nombre, email, LEFT(password_hash,20) as hash, rol FROM usuarios;"
```

### C8. Test login PROD

Abrir en navegador:
```
http://192.168.50.25:8000
```

Login con:
- **Usuario:** `VictorAdmin@minegocio.cl`
- **Pass:** `Victor264`

Si ingresa al dashboard → ✅ PROD funciona.

---

## PARTE D — Verificar servicios

```bash
docker ps --filter name=minegocio --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

```bash
curl -s http://192.168.50.25:8000/api/version
```

Debe retornar: `{"version":"3.1.0"}`

---

## Credenciales

| Entorno | Usuario | Pass | Rol |
|---------|---------|------|-----|
| Dev | administrador | admin123 | admin |
| Dev | usuario | usuario123 | usuario |
| Prod | VictorAdmin@minegocio.cl | Victor264 | admin |
| Prod | IgnacioAdmin@minegocio.cl | Admin226 | admin |
| Prod | NicolasVendedor@minegocio.cl | User224 | usuario |
| Prod | GabrielLogistica@minegocio.cl | User224 | usuario |

> El campo "usuario" acepta `nombre` o `email`.

---

## Troubleshooting

**Error "relation usuarios does not exist":** La BD no tiene las tablas. Ejecutar primero `esquema.sql`.

**Error "duplicate key value violates unique constraint":** El usuario ya existe con otro email. No es error — el ON CONFLICT lo maneja.

**Login falla después del fix:** Verificar que el hash empiece con `$2a$`. Si no, el INSERT no se ejecutó.

**Backend no responde:** `docker ps` para ver si el contenedor está corriendo. Si no: `docker start minegocio-backend`.

**No puedes hacer SSH al server:** Verificar que estás en la misma red. La IP del server es `192.168.50.25`.
