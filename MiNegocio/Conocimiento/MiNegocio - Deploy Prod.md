---
tags: [proyecto/minegocio, guia, deploy, jenkins]
updated: 2026-06-19
---

# MiNegocio — Despliegue a Producción vía Jenkins

## Arquitectura

```
Gitea/Jenkins (192.168.50.28)
  └── Jenkins pipeline (Jenkinsfile en repo backend)
        └── SSH a Servidor Producción (192.168.50.25)
              ├── docker run backend (puerto 3001)
              ├── nginx (puerto 8000) → proxy /api/ → localhost:3001
              └── frontend estático en /var/www/prod/frontend/
```

## Jenkins Credenciales

| Dato | Valor |
|------|-------|
| URL | http://192.168.50.28:8080 |
| Usuario | equipo6 |
| Password | equipo!"#$ |

Fuente: [[Cuentas Jenkins-sonarqube]]

## Paso a paso

### 1. Hacer push a main

El pipeline de Jenkins se gatilla automáticamente al hacer push a la rama `main` del repo backend (webhook configurado en Gitea). Si no hay webhook, se puede ejecutar manualmente.

```bash
# Frontend
cd /home/icin/minegocio-frontend
git add -A
git commit -m "descripcion de cambios"
git push gitea main

# Backend
cd /home/icin/minegocio-backend
git add -A
git commit -m "descripcion de cambios"
git push gitea main
```

### 2. Ir a Jenkins

1. Abrir http://192.168.50.28:8080 en el navegador
2. Iniciar sesión con usuario `equipo6` y password `equipo!"#$`
3. Hacer clic en el pipeline "MiNegocio-backend" (o el nombre que tenga configurado)
4. Si el push a main no gatilló automáticamente:
   - Clic en "Build Now" (esquina superior izquierda)
5. Esperar a que los stages se ejecuten:
   - **Checkout** — clona el repo
   - **Test** — ejecuta `go test ./...`
   - **Build Docker** — construye imagen Docker del backend
   - **Deploy Producción** — transfiere la imagen a 192.168.50.25 y levanta el contenedor

### 3. Verificar despliegue

Una vez que el pipeline termine exitosamente:

```bash
# Verificar que el contenedor esté corriendo (en 192.168.50.25)
ssh deploy@192.168.50.25 "docker ps | grep minegocio-backend"

# Probar endpoint
curl http://192.168.50.25:8000/api/productos
```

El frontend no se despliega por Jenkins. Se actualiza manualmente (ver sección [[#Despliegue manual del frontend]]).

## Lo que hace el Jenkinsfile

El archivo `Jenkinsfile` está en `/home/icin/minegocio-backend/Jenkinsfile` y realiza:

| Stage | Acción |
|-------|--------|
| Checkout | Clona `main` del repo backend |
| Test | `go test ./...` en contenedor golang:1.22-alpine |
| Build Docker | `docker build -t minegocio-backend .` |
| Deploy Producción | `ssh` a 192.168.50.25, `docker save`/`load`, detiene contenedor anterior, levanta nuevo con `docker run -d --name minegocio-backend -p 3001:3000 -e DB_NAME=cliente_prod ...` |

Las variables sensibles se inyectan desde Jenkins Credentials:
- `db-password` → password de PostgreSQL para `cliente_prod`
- `jwt-secret` → secreto JWT
- `prod-ssh-key` → clave SSH para conectar a 192.168.50.25 como usuario `deploy`

## ⚠️ Problema conocido: Docker build falla por arquitectura

El `Dockerfile` del backend compila un binario para la **arquitectura del nodo de Jenkins** (`linux/amd64` en 192.168.50.28), pero el servidor de producción (192.168.50.25) corre en otra arquitectura, causando:

```
exec ./main: not found
```

### Solución temporal: despliegue manual del backend

Mientras no se arregle el Dockerfile, el backend debe compilarse y ejecutarse nativamente:

```bash
# En 192.168.50.25 (este servidor)
cd /home/icin/minegocio-backend

# Compilar
go build -o main .

# Ejecutar (detener versión anterior primero)
pkill -f "minegocio-backend/main" 2>/dev/null
DB_PASSWORD=Icin2026 nohup ./main > /tmp/backend.log 2>&1 &
```

### Solución permanente

Modificar el `Dockerfile` para compilar con `GOARCH` explícito:

```dockerfile
RUN GOOS=linux GOARCH=amd64 go build -o main .
```

(o `GOARCH=arm64` según el servidor de producción).

## Despliegue manual del frontend

El frontend no tiene pipeline Jenkins. Se actualiza manualmente:

```bash
cd /home/icin/minegocio-frontend

# 1. Compilar
npm run build

# 2. Copiar a prod
cp -r dist/* /var/www/prod/frontend/

# 3. Probar
curl http://192.168.50.25:8000/
curl http://192.168.50.25:8080/  (dev)
```

## Comandos útiles para verificar

```bash
# Ver nginx
curl -s -o /dev/null -w "%{http_code}" http://192.168.50.25:8000/    # prod
curl -s -o /dev/null -w "%{http_code}" http://192.168.50.25:8080/    # dev

# Ver backend (desde Jenkins o servidor)
curl -s http://localhost:3001/api/productos | head -c 200             # prod backend
curl -s http://localhost:3000/api/productos | head -c 200             # dev backend

# Ver logs backend
tail -f /tmp/backend.log

# Ver contenedores Docker
docker ps -a | grep minegocio
```

## Enlaces relacionados
- [[Cuentas Jenkins-sonarqube]]
- [[Configuración de usuario de despliegue entre Server A (Jenkins) y Server B (Tomcat) Objetivo]]
- [[MiNegocio]]
