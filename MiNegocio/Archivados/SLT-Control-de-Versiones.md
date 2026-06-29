---
tags: [proyecto/minegocio, slt, versionado, git]
---

# SLT-Control-de-Versiones

> **Storyless Task** — Sin HU asociada (requerimiento general)

## Objetivo

Implementar versionado semántico mediante git tags en los 3 repos (frontend, backend, database) para rastrear releases.

## Esquema

```
3.0.0
│ │ └── hotfix/parche (commit pequeño, bugfix)
│ └──── feature mergeada a main (funcionalidad nueva)
└────── sprint number (S3 = 3)
```

## Tareas

### 1. Taggear `main` con `3.0.0` al mergear primera feature
```bash
git checkout main && git pull origin main
git tag -a 3.0.0 -m "S3: primera feature mergeada"
git push origin 3.0.0
```
Ejecutar en: frontend, backend, database.

### 2. Script auto-tag (opcional)
Hook post-merge o Jenkins step que detecte merge a main y auto-incremente el middle number.

### 3. Backend: loguear versión al arrancar
En `main.go`, al iniciar el servidor:
```go
log.Printf("minegocio-backend v%s iniciado", version)
```
Donde `version` se obtiene de `git describe --tags` en build time (ldflags):
```go
var version = "dev"
// en Dockerfile o go build:
// go build -ldflags="-X main.version=$(git describe --tags --always)" -o main .
```

## Ramas

- `SLT-control-de-versiones` en los 3 repos

## Archivos afectados

- `main.go` (backend) — variable `version` + log startup
- `Dockerfile` (backend) — agregar `-ldflags` al `go build`
- Opcional: hook post-merge o Jenkinsfile stage

## Prioridad: 🟢 Baja

Sin blocker. Hacer antes del primer merge a main.
