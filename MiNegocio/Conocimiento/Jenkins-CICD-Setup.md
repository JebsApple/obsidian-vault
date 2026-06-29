---
tags: [jenkins, cicd, devops, produccion]
---

# Jenkins CI/CD Setup

**Fecha:** 2026-06-19
**Equipo 6**

## Servidores

| Server | IP | Rol |
|--------|----|-----|
| A | 192.168.50.28 | Jenkins (8080), Gitea (3000), SonarQube (9000) |
| B | 192.168.50.25 | Producción (frontend:8000, backend:3001, DB:5432) |

## Pipelines en Jenkins

Ver `http://192.168.50.28:8080/job/MiNegocio.cl/`

### MiNegocio-backend
- Pipeline from SCM (`ssh://git@192.168.50.28:22/VHerrera/MiNegocio-backend.git`)
- 4 stages: Checkout → Test (docker run golang:1.22-alpine) → Build Docker → Deploy (SSH a Server B)
- Puerto: 3001 (host) → 3000 (contenedor)

### MiNegocio-Front
- Pipeline script inline
- 3 stages: Checkout → npm build → SCP dist/* a Server B

### MiNegocio-database
- Creado, pendiente de probar/ajustar

## Credenciales Jenkins (System → Global)

| ID | Tipo |
|----|------|
| `prod-ssh-key` | SSH key (icin@192.168.50.25) |
| `gitea-ssh-key` | SSH key (git@192.168.50.28) |
| `db-password` | Secret text (Icin2026) |
| `jwt-secret` | Secret text (ProdSecretKey2026!) |

## Detalles Técnicos

### Conexión SSH Jenkins → Server B
- Usuario: `icin`
- Clave privada en credencial `prod-ssh-key`
- Host key de 192.168.50.25 agregada a `/var/lib/jenkins/.ssh/known_hosts`

### Backend en Producción
```bash
docker run -d --name minegocio-backend \
  --restart unless-stopped \
  -p 3001:3000 \
  -e APP_ENV=production \
  -e DB_HOST=172.17.0.1 \
  -e DB_PASSWORD=Icin2026 \
  -e DB_NAME=cliente_prod \
  -e JWT_SECRET=ProdSecretKey2026! \
  minegocio-backend:latest
```

### Frontend en Producción
- Servido por nginx host en puerto 8000
- `/var/www/prod/frontend/` (actualizado via SCP desde Jenkins)
- También servido por contenedor Docker en puerto 8081

### Base de Datos
```
cliente_prod (PostgreSQL 16, localhost:5432)
Usuario: postgres / Icin2026
Usuarios aplicación: Victor / Victor264
```

## Archivos Clave
- Jenkinsfile: `/home/icin/minegocio-backend/Jenkinsfile`
- Nginx prod: `/etc/nginx/sites-available/minegocio-prod`
- Frontend dist: `/var/www/prod/frontend/`

## Notas
- El usuario `deployadmin6` NO se creó (se usa `icin` para deploy por simplicidad)
- Docker Pipeline plugin no instalado en Jenkins → `agent docker` no funciona, se usa workaround con `sh 'docker run ...'`
- Los pipelines NO tienen webhook automático aún (trigger manual o polling)
